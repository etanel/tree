import 'package:tree/database/tables.dart';
import 'package:tree/functions.dart';
import 'package:tree/struct/notificationsGlobal.dart';
import 'package:tree/widgets/lineGraph.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

// ── Streak helpers ───────────────────────────────────────────────────────────

/// Returns the current consecutive-day streak ending today (or yesterday).
/// [logs] must be the full list of HabitLog entries for a single habit.
int calculateStreak(List<HabitLog> logs) {
  if (logs.isEmpty) return 0;

  final Set<DateTime> completedDays = _uniqueDays(logs);
  DateTime day = DateTime.now().justDay();

  // Allow streak to start from yesterday if today isn't completed yet
  if (!completedDays.contains(day)) {
    day = day.justDay(dayOffset: -1);
  }

  int streak = 0;
  while (completedDays.contains(day)) {
    streak++;
    day = day.justDay(dayOffset: -1);
  }
  return streak;
}

/// Returns the all-time longest consecutive-day streak.
int calculateLongestStreak(List<HabitLog> logs) {
  if (logs.isEmpty) return 0;

  final List<DateTime> sortedDays = _uniqueDays(logs).toList()..sort();

  int longest = 1;
  int current = 1;
  for (int i = 1; i < sortedDays.length; i++) {
    if (sortedDays[i].difference(sortedDays[i - 1]).inDays == 1) {
      current++;
      if (current > longest) longest = current;
    } else {
      current = 1;
    }
  }
  return longest;
}

// ── Completion helpers ───────────────────────────────────────────────────────

/// Returns `true` when at least one log exists for today.
bool isCompletedToday(List<HabitLog> logs) {
  final DateTime today = DateTime.now().justDay();
  return logs.any((l) => l.dateCreated.justDay() == today);
}

/// Returns a 0.0 – 1.0 completion rate over the last [days] days
/// (including today).  E.g. 7 days → 4 completed → 0.571…
double getCompletionRate(List<HabitLog> logs, int days) {
  if (days <= 0) return 0.0;

  final DateTime today = DateTime.now().justDay();
  final DateTime start = today.justDay(dayOffset: -(days - 1));
  final Set<DateTime> completedDays = _uniqueDays(logs);

  int count = 0;
  for (int i = 0; i < days; i++) {
    if (completedDays.contains(start.justDay(dayOffset: i))) {
      count++;
    }
  }
  return count / days;
}

// ── Heatmap data ─────────────────────────────────────────────────────────────

/// Returns a `Map<DateTime, int>` where:
///   - key   = day (midnight-normalised via `justDay()`)
///   - value = number of completions on that day
///
/// This is compatible with the heatmap widget in homePageHeatmap.dart.
/// To feed it into `HeatMap`, convert to `List<Pair>`:
/// ```dart
/// data.entries.map((e) => Pair(0, e.value.toDouble(), dateTime: e.key)).toList()
/// ```
Map<DateTime, int> getHabitActivityData(List<HabitLog> logs) {
  final Map<DateTime, int> data = {};
  for (final log in logs) {
    final DateTime day = log.dateCreated.justDay();
    data[day] = (data[day] ?? 0) + 1;
  }
  return data;
}

// ── Notification helpers ─────────────────────────────────────────────────────

// Notification IDs for habit reminders start at 2000 to avoid collisions
// with daily reminders (0–14) and upcoming transactions (100+).
const int _habitNotificationIdBase = 2000;

/// Schedules a daily local notification for a habit at its configured
/// `reminderTime` (stored as "HH:mm" in the Habit row).
///
/// Does nothing on web or if reminders are disabled for this habit.
Future<void> scheduleHabitReminder(Habit habit) async {
  if (kIsWeb) return;
  if (habit.reminderEnabled == false || habit.reminderTime == null) return;

  // Cancel any existing notification for this habit first
  await cancelHabitReminder(habit.habitPk);

  // Parse "HH:mm" time string
  final parts = habit.reminderTime!.split(':');
  final int hour = int.tryParse(parts[0]) ?? 8;
  final int minute = parts.length > 1 ? (int.tryParse(parts[1]) ?? 0) : 0;

  final int notificationId = _habitNotificationId(habit.habitPk);

  final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'habitReminders',
    'Habit Reminders',
    importance: Importance.max,
    priority: Priority.high,
  );

  final DarwinNotificationDetails darwinDetails =
      DarwinNotificationDetails(threadIdentifier: 'habitReminders');

  final NotificationDetails notificationDetails = NotificationDetails(
    android: androidDetails,
    iOS: darwinDetails,
  );

  // Schedule for the next occurrence of this time
  tz.TZDateTime scheduledDate = _nextInstanceOfTime(hour, minute);

  await flutterLocalNotificationsPlugin.zonedSchedule(
    id: notificationId,
    title: habit.name,
    body: habit.note.isNotEmpty ? habit.note : 'Time to complete your habit!',
    scheduledDate: scheduledDate,
    notificationDetails: notificationDetails,
    payload: 'habitReminder?habitPk=${habit.habitPk}',
    androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    matchDateTimeComponents: DateTimeComponents.time, // repeat daily
  );

  print(
      "Habit reminder for '${habit.name}' scheduled at $hour:$minute with id $notificationId");
}

/// Cancels the daily reminder notification for the given habit.
Future<void> cancelHabitReminder(String habitPk) async {
  if (kIsWeb) return;
  final int notificationId = _habitNotificationId(habitPk);
  await flutterLocalNotificationsPlugin.cancel(id: notificationId);
  print("Cancelled habit reminder with id $notificationId");
}

// ── Private helpers ──────────────────────────────────────────────────────────

/// Generates a deterministic notification ID from a habitPk string.
int _habitNotificationId(String habitPk) {
  return _habitNotificationIdBase + habitPk.hashCode.abs() % 10000;
}

/// Returns the next [tz.TZDateTime] for the given hour:minute that is in
/// the future.
tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
  final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
  tz.TZDateTime scheduled =
      tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
  if (scheduled.isBefore(now)) {
    scheduled = scheduled.add(const Duration(days: 1));
  }
  return scheduled;
}

/// Extracts the set of unique midnight-normalised days from a log list.
Set<DateTime> _uniqueDays(List<HabitLog> logs) {
  return logs.map((l) => l.dateCreated.justDay()).toSet();
}

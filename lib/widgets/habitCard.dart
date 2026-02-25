import 'package:tree/colors.dart';
import 'package:tree/database/tables.dart';
import 'package:tree/functions.dart';
import 'package:tree/struct/databaseGlobal.dart';
import 'package:tree/struct/habitsFunctions.dart';
import 'package:tree/struct/settings.dart';
import 'package:tree/widgets/categoryIcon.dart';
import 'package:tree/widgets/openBottomSheet.dart';
import 'package:tree/widgets/openPopup.dart';
import 'package:tree/widgets/tappable.dart';
import 'package:tree/widgets/textWidgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class HabitCard extends StatelessWidget {
  const HabitCard({
    Key? key,
    required this.habit,
    required this.logs,
    this.onTap,
    this.onLongPress,
    this.useHorizontalPaddingConstrained = true,
  }) : super(key: key);

  final Habit habit;
  final List<HabitLog> logs;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool useHorizontalPaddingConstrained;

  @override
  Widget build(BuildContext context) {
    final bool completedToday = isCompletedToday(logs);
    final int streak = calculateStreak(logs);

    final Color habitColor = HexColor(
      habit.colour,
      defaultColor: Theme.of(context).colorScheme.primary,
    );
    final Color pastelColor = dynamicPastel(
      context,
      habitColor,
      amountLight: 0.55,
      amountDark: 0.35,
    );

    return Padding(
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: getHorizontalPaddingConstrained(
          context,
          enabled: useHorizontalPaddingConstrained,
        ),
      ),
      child: Tappable(
        borderRadius: 0,
        onTap: onTap ??
            () {
              // TODO: Navigate to HabitDetailPage once it is created
              // pushRoute(context, HabitDetailPage(habit: habit));
            },
        onLongPress: onLongPress ?? () => _showEditDeletePopup(context),
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsetsDirectional.only(
            start: 20,
            end: 25,
            top: 10,
            bottom: 10,
          ),
          child: Row(
            children: [
              // ── Habit icon ──────────────────────────────────────────────
              _HabitIcon(
                habit: habit,
                size: 28,
                insetPadding: 18,
              ),
              const SizedBox(width: 15),

              // ── Name + 7-day dots ───────────────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFont(
                            text: habit.name,
                            fontSize: 17,
                            maxLines: 1,
                          ),
                        ),
                        const SizedBox(width: 8),

                        // ── Streak badge ──────────────────────────────────
                        if (streak > 0) ...[
                          Icon(
                            Icons.local_fire_department_rounded,
                            size: 16,
                            color: dynamicPastel(
                              context,
                              habitColor,
                              inverse: true,
                              amountLight: 0.1,
                              amountDark: 0.1,
                            ),
                          ),
                          const SizedBox(width: 2),
                          TextFont(
                            text: streak.toString(),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            textColor: dynamicPastel(
                              context,
                              habitColor,
                              inverse: true,
                              amountLight: 0.1,
                              amountDark: 0.1,
                            ),
                          ),
                          const SizedBox(width: 10),
                        ],

                        // ── Today toggle button ─────────────────────────
                        _CompletionToggle(
                          completed: completedToday,
                          habitColor: habitColor,
                          pastelColor: pastelColor,
                          onToggle: () async {
                            await database.toggleHabitLog(
                              habit.habitPk,
                              DateTime.now(),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // ── 7-day completion dots ─────────────────────────────
                    _SevenDayDots(
                      logs: logs,
                      habitColor: habitColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditDeletePopup(BuildContext context) async {
    DeletePopupAction? action = await openDeletePopup(
      context,
      title: habit.name,
      subtitle: "edit-or-delete".tr(
        namedArgs: {"name": habit.name},
        // Fallback in case the key is not localised yet
      ),
    );
    if (action == DeletePopupAction.Delete) {
      await database.deleteHabit(habit.habitPk);
    }
  }
}

// ─── Habit Icon (mirrors CategoryIconPercent style) ──────────────────────────

class _HabitIcon extends StatelessWidget {
  const _HabitIcon({
    required this.habit,
    this.size = 28,
    this.insetPadding = 18,
  });

  final Habit habit;
  final double size;
  final double insetPadding;

  @override
  Widget build(BuildContext context) {
    final Color habitColor = HexColor(
      habit.colour,
      defaultColor: Theme.of(context).colorScheme.primary,
    );
    final Color backgroundColor = dynamicPastel(
      context,
      habitColor,
      amountLight: 0.55,
      amountDark: 0.35,
    );

    return SizedBox(
      height: size + insetPadding,
      width: size + insetPadding,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          // Background circle
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.light
                  ? backgroundColor
                  : backgroundColor.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            height: size + insetPadding,
            width: size + insetPadding,
          ),

          // Asset icon (if set and no emoji)
          if (habit.iconName != null && habit.emojiIconName == null)
            CacheCategoryIcon(
              iconName: habit.iconName!,
              size: size,
            ),

          // Emoji icon (takes precedence over asset icon)
          if (habit.emojiIconName != null)
            EmojiIcon(
              emojiIconName: habit.emojiIconName,
              size: size * 0.92,
            ),

          // Fallback when no icon is set
          if (habit.iconName == null && habit.emojiIconName == null)
            Icon(
              appStateSettings["outlinedIcons"]
                  ? Icons.check_circle_outlined
                  : Icons.check_circle_rounded,
              size: size,
              color: habitColor,
            ),
        ],
      ),
    );
  }
}

// ─── Today completion toggle ─────────────────────────────────────────────────

class _CompletionToggle extends StatelessWidget {
  const _CompletionToggle({
    required this.completed,
    required this.habitColor,
    required this.pastelColor,
    required this.onToggle,
  });

  final bool completed;
  final Color habitColor;
  final Color pastelColor;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Tappable(
      borderRadius: 100,
      color: completed
          ? dynamicPastel(
              context,
              habitColor,
              inverse: true,
              amountLight: 0.1,
              amountDark: 0.1,
            )
          : appStateSettings["materialYou"]
              ? Theme.of(context).colorScheme.secondaryContainer
              : getColor(context, "lightDarkAccentHeavy"),
      onTap: onToggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: 34,
        height: 34,
        alignment: Alignment.center,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: Icon(
            completed
                ? (appStateSettings["outlinedIcons"]
                    ? Icons.check_outlined
                    : Icons.check_rounded)
                : null,
            key: ValueKey(completed),
            size: 20,
            color: completed
                ? Colors.white
                : getColor(context, "black").withOpacity(0.3),
          ),
        ),
      ),
    );
  }
}

// ─── 7-day completion dots ───────────────────────────────────────────────────

class _SevenDayDots extends StatelessWidget {
  const _SevenDayDots({
    required this.logs,
    required this.habitColor,
  });

  final List<HabitLog> logs;
  final Color habitColor;

  @override
  Widget build(BuildContext context) {
    final DateTime today = DateTime.now();
    final Set<DateTime> completedDays =
        logs.map((l) => l.dateCreated.justDay()).toSet();

    final Color activeColor = dynamicPastel(
      context,
      habitColor,
      inverse: true,
      amountLight: 0.1,
      amountDark: 0.1,
    );
    final Color inactiveColor = appStateSettings["materialYou"]
        ? Theme.of(context).colorScheme.secondaryContainer
        : getColor(context, "lightDarkAccentHeavy");

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(7, (i) {
        // i=0 is 6 days ago, i=6 is today
        final DateTime day = today.justDay(dayOffset: i - 6);
        final bool done = completedDays.contains(day);
        final bool isToday = i == 6;

        return Padding(
          padding: EdgeInsetsDirectional.only(end: i < 6 ? 4 : 0),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOutCubic,
            width: isToday ? 8 : 6,
            height: isToday ? 8 : 6,
            decoration: BoxDecoration(
              color: done ? activeColor : inactiveColor,
              shape: BoxShape.circle,
            ),
          ),
        );
      }),
    );
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tree/colors.dart';
import 'package:tree/database/tables.dart';
import 'package:tree/functions.dart';
import 'package:tree/pages/addHabitPage.dart';
import 'package:tree/pages/homePage/homePageHeatmap.dart';
import 'package:tree/struct/databaseGlobal.dart';
import 'package:tree/struct/habitsFunctions.dart';
import 'package:tree/struct/settings.dart';
import 'package:tree/widgets/categoryIcon.dart';
import 'package:tree/widgets/dropdownSelect.dart';
import 'package:tree/widgets/framework/pageFramework.dart';
import 'package:tree/widgets/lineGraph.dart';
import 'package:tree/widgets/navigationSidebar.dart';
import 'package:tree/widgets/openPopup.dart';
import 'package:tree/widgets/tappable.dart';
import 'package:tree/widgets/textWidgets.dart';
import 'package:tree/widgets/transactionEntry/transactionEntry.dart';

class HabitPage extends StatelessWidget {
  const HabitPage({
    super.key,
    required this.habitPk,
  });
  final String habitPk;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Habit>(
        stream: database.getHabit(habitPk),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Color? accentColor = HexColor(snapshot.data?.colour);
            return CustomColorTheme(
              accentColor: snapshot.data?.colour == null ? null : accentColor,
              child: _HabitPageContent(
                habit: snapshot.data!,
              ),
            );
          }
          return SizedBox.shrink();
        });
  }
}

class _HabitPageContent extends StatefulWidget {
  const _HabitPageContent({
    Key? key,
    required this.habit,
  }) : super(key: key);

  final Habit habit;

  @override
  State<_HabitPageContent> createState() => _HabitPageContentState();
}

class _HabitPageContentState extends State<_HabitPageContent> {
  @override
  Widget build(BuildContext context) {
    Color? pageBackgroundColor =
        Theme.of(context).brightness == Brightness.dark &&
                appStateSettings["forceFullDarkBackground"]
            ? Colors.black
            : appStateSettings["materialYou"]
                ? dynamicPastel(context, Theme.of(context).colorScheme.primary,
                    amount: 0.92)
                : null;
    String pageId = widget.habit.habitPk;

    return StreamBuilder<List<HabitLog>>(
      stream: database.watchHabitLogs(widget.habit.habitPk),
      builder: (context, snapshot) {
        final logs = snapshot.data ?? [];
        return WillPopScope(
          onWillPop: () async {
            if ((globalSelectedID.value[pageId] ?? []).length > 0) {
              globalSelectedID.value[pageId] = [];
              globalSelectedID.notifyListeners();
              return false;
            } else {
              return true;
            }
          },
          child: PageFramework(
            belowAppBarPaddingWhenCenteredTitleSmall: 0,
            subtitleAlignment: AlignmentDirectional.bottomStart,
            backgroundColor: pageBackgroundColor,
            listID: pageId,
            actions: [
              CustomPopupMenuButton(
                showButtons: enableDoubleColumn(context),
                keepOutFirst: true,
                forceKeepOutFirst: true,
                items: [
                  DropdownItemMenu(
                    id: "edit-habit",
                    label: "edit-habit"
                        .tr(), // Might need a fallback string if not translated
                    icon: appStateSettings["outlinedIcons"]
                        ? Icons.edit_outlined
                        : Icons.edit_rounded,
                    action: () {
                      pushRoute(
                        context,
                        AddHabitPage(
                          habit: widget.habit,
                          routesToPopAfterDelete: RoutesToPopAfterDelete.All,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
            title: widget.habit.name,
            capitalizeTitle: false,
            appBarBackgroundColor:
                Theme.of(context).colorScheme.secondaryContainer,
            appBarBackgroundColorStart:
                Theme.of(context).colorScheme.secondaryContainer,
            textColor: getColor(context, "black"),
            dragDownToDismiss: true,
            slivers: [
              // ── Header (Icon + Name) ──────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsetsDirectional.only(top: 40, bottom: 25),
                  child: Column(
                    children: [
                      CategoryIcon(
                        categoryPk: "-1",
                        category: TransactionCategory(
                          categoryPk: "-1",
                          name: "",
                          dateCreated: DateTime.now(),
                          dateTimeModified: null,
                          order: 0,
                          income: false,
                          iconName: widget.habit.iconName,
                          colour: widget.habit.colour,
                          emojiIconName: widget.habit.emojiIconName,
                        ),
                        size: 60,
                        sizePadding: 45,
                        borderRadius: 100,
                        canEditByLongPress: false,
                        margin: EdgeInsetsDirectional.zero,
                        onLongPress: () {},
                        onTap: () {},
                      ),
                      SizedBox(height: 15),
                      TextFont(
                        text: widget.habit.name,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        textColor: getColor(context, "black"),
                        textAlign: TextAlign.center,
                      ),
                      if (widget.habit.note.isNotEmpty)
                        Padding(
                          padding: const EdgeInsetsDirectional.only(
                              top: 5, start: 20, end: 20),
                          child: TextFont(
                            text: widget.habit.note,
                            fontSize: 16,
                            textColor:
                                getColor(context, "black").withOpacity(0.6),
                            textAlign: TextAlign.center,
                            maxLines: 5,
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // ── Stats Row ─────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsetsDirectional.symmetric(
                      horizontal: 20, vertical: 10),
                  child: Row(
                    children: [
                      _StatBox(
                        title: "Current Streak",
                        value: calculateStreak(logs).toString(),
                        icon: Icons.local_fire_department_rounded,
                        color: Colors.orange,
                      ),
                      SizedBox(width: 10),
                      _StatBox(
                        title: "Longest Streak",
                        value: calculateLongestStreak(logs).toString(),
                        icon: Icons.emoji_events_rounded,
                        color: Colors.amber,
                      ),
                      SizedBox(width: 10),
                      _StatBox(
                        title: "30-Day Rate",
                        value: (getCompletionRate(logs, 30) * 100)
                                .toStringAsFixed(0) +
                            "%",
                        icon: Icons.donut_large_rounded,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ],
                  ),
                ),
              ),

              // ── This Week ─────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsetsDirectional.symmetric(
                      horizontal: 20, vertical: 15),
                  child: Container(
                    padding: EdgeInsetsDirectional.all(15),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: boxShadowCheck(boxShadowGeneral(context)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFont(
                          text: "This Week",
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          textColor: getColor(context, "textLight"),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: _buildWeekIndicators(logs),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ── Heatmap ───────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsetsDirectional.only(top: 10, bottom: 20),
                  child: _HabitHeatmap(logs: logs),
                ),
              ),

              // ── Recent Logs Header ────────────────────────────────────
              if (logs.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(
                        start: 22, bottom: 5, top: 10),
                    child: TextFont(
                      text: "Recent Logs",
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      textColor: getColor(context, "textLight"),
                    ),
                  ),
                ),

              // ── Logs List ─────────────────────────────────────────────
              if (logs.isEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.all(30),
                    child: TextFont(
                      text:
                          "No logs yet. Complete your habit to see history here.",
                      fontSize: 14,
                      textColor: getColor(context, "textLight"),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final log = logs[index];
                      return _HabitLogEntry(
                        log: log,
                        habit: widget.habit,
                      );
                    },
                    childCount: logs.length > 50
                        ? 50
                        : logs.length, // Limit to recent 50
                  ),
                ),

              SliverToBoxAdapter(child: SizedBox(height: 75)),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildWeekIndicators(List<HabitLog> logs) {
    List<Widget> indicators = [];
    final today = DateTime.now().justDay();
    final firstDayOfWeekOffset = appStateSettings["firstDayOfWeek"] == -1
        ? MaterialLocalizations.of(context).firstDayOfWeekIndex
        : (int.tryParse(appStateSettings["firstDayOfWeek"].toString()) ??
            MaterialLocalizations.of(context).firstDayOfWeekIndex);

    // Calculate start of current week
    int daysSinceFirstDay = today.weekday - firstDayOfWeekOffset;
    if (daysSinceFirstDay < 0) daysSinceFirstDay += 7;
    // We want to show the last 7 days ending today, or the current week? Let's show the last 7 days ending today for simplicity and immediate relevance.
    DateTime startDay = today.justDay(dayOffset: -6);

    for (int i = 0; i < 7; i++) {
      DateTime day = startDay.justDay(dayOffset: i);
      bool isCompleted = logs.any((l) => l.dateCreated.justDay() == day);
      bool isToday = day == today;

      indicators.add(
        Expanded(
          child: Column(
            children: [
              TextFont(
                text: getWordedDateShort(day, showTodayTomorrow: false)
                    .split(" ")
                    .first,
                fontSize: 12,
                textColor: isToday
                    ? Theme.of(context).colorScheme.primary
                    : getColor(context, "textLight"),
                fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
              ),
              SizedBox(height: 5),
              Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.secondaryContainer,
                  shape: BoxShape.circle,
                  border: isToday && !isCompleted
                      ? Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2)
                      : null,
                ),
                child: isCompleted
                    ? Icon(Icons.check_rounded,
                        size: 18,
                        color: Theme.of(context).colorScheme.onPrimary)
                    : null,
              ),
            ],
          ),
        ),
      );
    }
    return indicators;
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsetsDirectional.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(15),
          boxShadow: boxShadowCheck(boxShadowGeneral(context)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            SizedBox(height: 8),
            TextFont(
              text: value,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            SizedBox(height: 2),
            TextFont(
              text: title,
              fontSize: 11,
              textColor: getColor(context, "textLight"),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _HabitHeatmap extends StatelessWidget {
  const _HabitHeatmap({required this.logs});
  final List<HabitLog> logs;

  @override
  Widget build(BuildContext context) {
    final Map<DateTime, int> activityData = getHabitActivityData(logs);
    final List<Pair> points = activityData.entries
        .map((e) => Pair(0, e.value.toDouble(), dateTime: e.key))
        .toList();

    // Sort points by date ascending for HeatMap
    points.sort((a, b) =>
        (a.dateTime ?? DateTime.now()).compareTo(b.dateTime ?? DateTime.now()));

    // HeatMap requires a pad of empty days until today if there are no logs today
    if (points.isNotEmpty &&
        points.last.dateTime?.justDay() != DateTime.now().justDay()) {
      points.add(Pair(0, 0.0, dateTime: DateTime.now().justDay()));
    } else if (points.isEmpty) {
      points.add(Pair(0, 0.0, dateTime: DateTime.now().justDay()));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 22, bottom: 8),
          child: TextFont(
            text: "Activity",
            fontSize: 16,
            fontWeight: FontWeight.bold,
            textColor: getColor(context, "textLight"),
          ),
        ),
        HeatMap(
          points: points,
        ),
      ],
    );
  }
}

class _HabitLogEntry extends StatelessWidget {
  const _HabitLogEntry({required this.log, required this.habit});
  final HabitLog log;
  final Habit habit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsetsDirectional.symmetric(horizontal: 13, vertical: 4),
      child: Tappable(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: 15,
        onTap: () {
          // Future enhancement: Edit log popup
        },
        child: Padding(
          padding: const EdgeInsetsDirectional.all(15),
          child: Row(
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFont(
                      text: getWordedDateShortMore(log.dateCreated,
                          includeTime: true),
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    if (log.note != null && log.note!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsetsDirectional.only(top: 3),
                        child: TextFont(
                          text: log.note!,
                          fontSize: 13,
                          textColor: getColor(context, "textLight"),
                          maxLines: 2,
                        ),
                      ),
                  ],
                ),
              ),
              if (log.amount != null && habit.goalAmount != null)
                TextFont(
                  text:
                      "${log.amount!.toStringAsFixed(log.amount!.truncateToDouble() == log.amount ? 0 : 2)} ${habit.goalUnit ?? ''}"
                          .trim(),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  textColor: Theme.of(context).colorScheme.primary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

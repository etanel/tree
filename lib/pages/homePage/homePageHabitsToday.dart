import 'package:tree/colors.dart';
import 'package:tree/database/tables.dart';
import 'package:tree/functions.dart';
import 'package:tree/struct/databaseGlobal.dart';
import 'package:tree/struct/habitsFunctions.dart';
import 'package:tree/struct/settings.dart';
import 'package:tree/widgets/categoryIcon.dart';
import 'package:tree/widgets/navigationFramework.dart';
import 'package:tree/widgets/tappable.dart';
import 'package:tree/widgets/textWidgets.dart';
import 'package:tree/widgets/util/keepAliveClientMixin.dart';
import 'package:flutter/material.dart';

class HomePageHabitsToday extends StatelessWidget {
  const HomePageHabitsToday({super.key});

  @override
  Widget build(BuildContext context) {
    return KeepAliveClientMixin(
      child: StreamBuilder<List<Habit>>(
        stream: database.watchAllHabits(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return SizedBox.shrink();
          final habits = snapshot.data!;
          if (habits.isEmpty) return SizedBox.shrink();

          return Padding(
            padding: const EdgeInsetsDirectional.only(
                bottom: 13, start: 13, end: 13),
            child: Container(
              decoration: BoxDecoration(
                color: appStateSettings["materialYou"]
                    ? dynamicPastel(
                        context,
                        Theme.of(context).colorScheme.secondaryContainer,
                        amountLight: 0.6,
                        amountDark: 0.4,
                      )
                    : getColor(context, "lightDarkAccentHeavyLight"),
                borderRadius: BorderRadiusDirectional.all(Radius.circular(15)),
                boxShadow: boxShadowCheck(boxShadowGeneral(context)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Header ───────────────────────────────────────────
                  Tappable(
                    borderRadius: 15,
                    onTap: () {
                      PageNavigationFramework.changePage(context, 18,
                          switchNavbar: true);
                    },
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(
                        start: 18,
                        end: 12,
                        top: 14,
                        bottom: 8,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFont(
                              text: "Habits",
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(
                            appStateSettings["outlinedIcons"]
                                ? Icons.chevron_right_outlined
                                : Icons.chevron_right_rounded,
                            color: getColor(context, "black").withOpacity(0.3),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // ── Habit rows ───────────────────────────────────────
                  _HabitsTodayList(habits: habits),
                  SizedBox(height: 8),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _HabitsTodayList extends StatelessWidget {
  const _HabitsTodayList({required this.habits});
  final List<Habit> habits;

  @override
  Widget build(BuildContext context) {
    // Build a stream for each habit's logs so we can check today's completion.
    // We use a nested StreamBuilder per habit, same pattern as
    // _HabitCardWithLogs in habitsListPage.dart.
    return Column(
      children: [
        for (int i = 0; i < habits.length; i++)
          _HabitRowWithLogs(
            habit: habits[i],
            isLast: i == habits.length - 1,
          ),
      ],
    );
  }
}

class _HabitRowWithLogs extends StatelessWidget {
  const _HabitRowWithLogs({
    required this.habit,
    this.isLast = false,
  });

  final Habit habit;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<HabitLog>>(
      stream: database.watchHabitLogs(habit.habitPk),
      builder: (context, logSnapshot) {
        final logs = logSnapshot.data ?? [];
        final bool completedToday = isCompletedToday(logs);
        final int streak = calculateStreak(logs);

        final Color habitColor = HexColor(
          habit.colour,
          defaultColor: Theme.of(context).colorScheme.primary,
        );

        return Tappable(
          borderRadius: 0,
          color: Colors.transparent,
          onTap: () async {
            await database.toggleHabitLog(
              habit.habitPk,
              DateTime.now(),
            );
          },
          child: Padding(
            padding: EdgeInsetsDirectional.only(
              start: 18,
              end: 18,
              top: 6,
              bottom: isLast ? 6 : 4,
            ),
            child: Row(
              children: [
                // ── Icon ─────────────────────────────────────────
                CategoryIcon(
                  categoryPk: "-1",
                  category: TransactionCategory(
                    categoryPk: "-1",
                    name: "",
                    dateCreated: DateTime.now(),
                    dateTimeModified: null,
                    order: 0,
                    income: false,
                    iconName: habit.iconName,
                    colour: habit.colour,
                    emojiIconName: habit.emojiIconName,
                  ),
                  size: 22,
                  sizePadding: 16,
                  borderRadius: 100,
                  canEditByLongPress: false,
                  margin: EdgeInsetsDirectional.zero,
                ),
                SizedBox(width: 12),

                // ── Name + streak ────────────────────────────────
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFont(
                          text: habit.name,
                          fontSize: 15,
                          maxLines: 1,
                          textColor: completedToday
                              ? getColor(context, "black").withOpacity(0.4)
                              : null,
                        ),
                      ),
                      if (streak > 0 && !completedToday) ...[
                        Icon(
                          Icons.local_fire_department_rounded,
                          size: 14,
                          color: dynamicPastel(
                            context,
                            habitColor,
                            inverse: true,
                            amountLight: 0.1,
                            amountDark: 0.1,
                          ),
                        ),
                        SizedBox(width: 2),
                        TextFont(
                          text: streak.toString(),
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          textColor: dynamicPastel(
                            context,
                            habitColor,
                            inverse: true,
                            amountLight: 0.1,
                            amountDark: 0.1,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(width: 8),

                // ── Completion indicator ─────────────────────────
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: completedToday
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
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 250),
                    child: Icon(
                      completedToday
                          ? (appStateSettings["outlinedIcons"]
                              ? Icons.check_outlined
                              : Icons.check_rounded)
                          : null,
                      key: ValueKey(completedToday),
                      size: 16,
                      color: completedToday
                          ? Colors.white
                          : getColor(context, "black").withOpacity(0.3),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

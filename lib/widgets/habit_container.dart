import 'package:tree/colors.dart';
import 'package:tree/database/tables.dart';
import 'package:tree/functions.dart';
import 'package:tree/pages/add_habitspage.dart';
import 'package:tree/struct/databaseGlobal.dart';
import 'package:tree/struct/habitsFunctions.dart';
import 'package:tree/struct/settings.dart';
import 'package:tree/widgets/openContainerNavigation.dart';
import 'package:tree/widgets/openPopup.dart';
import 'package:tree/widgets/tappable.dart';
import 'package:tree/widgets/textWidgets.dart';
import 'package:tree/widgets/budgetcontainer.dart' show AnimatedGooBackground;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tree/widgets/openSnackbar.dart';
import 'package:tree/widgets/globalSnackbar.dart';

class HabitContainer extends StatelessWidget {
  const HabitContainer({
    super.key,
    required this.habit,
    this.height = 183,
    this.intermediatePadding = true,
  });

  final Habit habit;
  final double height;
  final bool intermediatePadding;

  String _frequencyLabel(HabitFrequency f) {
    switch (f) {
      case HabitFrequency.daily:
        return "daily".tr();
      case HabitFrequency.specificDays:
        return "specific-days".tr();
      case HabitFrequency.weekly:
        return "weekly".tr();
      case HabitFrequency.monthly:
        return "monthly".tr();
    }
  }

  @override
  Widget build(BuildContext context) {
    Color habitColor = HexColor(
      habit.colour,
      defaultColor: Theme.of(context).colorScheme.primary,
    );

    ColorScheme habitColorScheme = ColorScheme.fromSeed(
      seedColor: habitColor,
      brightness: determineBrightnessTheme(context),
    );

    Color backgroundColor = appStateSettings["materialYou"]
        ? habit.colour == null
            ? appStateSettings["accentSystemColor"] == true &&
                    appStateSettings["materialYou"] &&
                    appStateSettings["batterySaver"] == false
                ? dynamicPastel(
                    context,
                    Theme.of(context).colorScheme.primary,
                    amountDark: 0.85,
                    amountLight: 0.96,
                  )
                : dynamicPastel(
                    context,
                    HexColor(appStateSettings["accentColor"]),
                    amountDark: 0.8,
                    amountLight: appStateSettings["batterySaver"] ? 0.8 : 0.92,
                  )
            : dynamicPastel(
                context,
                habitColorScheme.secondaryContainer,
                amountDark: 0.6,
                amountLight: 0.75,
              )
        : getColor(context, "lightDarkAccentHeavyLight");

    Widget content = StreamBuilder<List<HabitLog>>(
      stream: database.watchHabitLogs(habit.habitPk),
      builder: (context, snapshot) {
        List<HabitLog> logs = snapshot.data ?? [];
        int currentStreak = calculateStreak(logs);
        bool completedToday = isCompletedToday(logs);
        double completionRate = getCompletionRate(logs, 30);

        return Container(
          child: ClipRRect(
            clipBehavior: Clip.antiAlias,
            borderRadius: BorderRadiusDirectional.circular(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // ── Top section: animated background + habit info ──
                Stack(
                  children: [
                    Positioned.fill(
                      child: AnimatedGooBackground(
                        randomOffset: habit.name.length,
                        color: habitColor.withValues(alpha: 0.8),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(
                        start: 23,
                        end: 23,
                        bottom: 13,
                        top: 13,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ── Habit icon + name row ──
                          Row(
                            children: [
                              if (habit.emojiIconName != null)
                                Padding(
                                  padding:
                                      const EdgeInsetsDirectional.only(end: 10),
                                  child: TextFont(
                                    text: habit.emojiIconName!,
                                    fontSize: 28,
                                  ),
                                )
                              else if (habit.iconName != null)
                                Padding(
                                  padding:
                                      const EdgeInsetsDirectional.only(end: 10),
                                  child: Image.asset(
                                    "assets/categories/${habit.iconName!}",
                                    width: 30,
                                    height: 30,
                                    color: dynamicPastel(
                                      context,
                                      habitColor,
                                      amount: 0.7,
                                      inverse: true,
                                    ),
                                  ),
                                ),
                              Flexible(
                                child: TextFont(
                                  text: habit.name,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          // ── Streak + frequency ──
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.local_fire_department_rounded,
                                size: 18,
                                color: currentStreak > 0
                                    ? Colors.orange
                                    : getColor(context, "black").withAlpha(100),
                              ),
                              SizedBox(width: 3),
                              TextFont(
                                text:
                                    "$currentStreak ${currentStreak == 1 ? "day".tr() : "days".tr()}",
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                              SizedBox(width: 12),
                              TextFont(
                                text: _frequencyLabel(habit.frequency),
                                fontSize: 13,
                                textColor:
                                    getColor(context, "black").withAlpha(150),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // ── Today's completion indicator (tappable) ──
                    Align(
                      alignment: AlignmentDirectional.topEnd,
                      child: Tappable(
                        onTap: () async {
                          HapticFeedback.mediumImpact();
                          bool wasCreated = await database.toggleHabitLog(
                            habit.habitPk,
                            DateTime.now(),
                          );
                          openSnackbar(
                            SnackbarMessage(
                              title: wasCreated
                                  ? "habit-completed".tr()
                                  : "habit-uncompleted".tr(),
                              icon: wasCreated
                                  ? Icons.check_circle_rounded
                                  : Icons.radio_button_unchecked_rounded,
                              description: habit.name,
                            ),
                          );
                        },
                        borderRadius: 50,
                        color: Colors.transparent,
                        child: Container(
                          padding: EdgeInsetsDirectional.only(
                              top: 10, end: 10, start: 10, bottom: 10),
                          child: Icon(
                            completedToday
                                ? Icons.check_circle_rounded
                                : Icons.radio_button_unchecked_rounded,
                            size: 28,
                            color: completedToday
                                ? dynamicPastel(
                                    context,
                                    habitColor,
                                    amount: 0.7,
                                    inverse: true,
                                  )
                                : getColor(context, "black").withAlpha(80),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // ── Bottom section: progress bar ──
                Padding(
                  padding: intermediatePadding
                      ? EdgeInsetsDirectional.only(
                          start: 15,
                          end: 15,
                          top: 12,
                          bottom: 12,
                        )
                      : EdgeInsetsDirectional.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      // ── Progress bar ──
                      ClipRRect(
                        borderRadius: BorderRadiusDirectional.circular(50),
                        child: SizedBox(
                          height: 8,
                          child: LinearProgressIndicator(
                            value: completionRate.clamp(0.0, 1.0),
                            backgroundColor: appStateSettings["materialYou"]
                                ? dynamicPastel(
                                    context,
                                    dynamicPastel(context, habitColor,
                                        amount: 0.7, inverse: true),
                                    amountLight: 0.87,
                                    amountDark: 0.75,
                                  )
                                : getColor(context, "lightDarkAccentHeavy"),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              dynamicPastel(
                                context,
                                habitColor,
                                amount: 0.6,
                                inverse: true,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 6),
                      // ── Completion rate text ──
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextFont(
                            text:
                                "${(completionRate * 100).toStringAsFixed(0)}% ${"completion-rate".tr()}",
                            fontSize: 12,
                            textColor:
                                getColor(context, "black").withAlpha(100),
                          ),
                          if (habit.goalAmount != null &&
                              habit.goalUnit != null)
                            TextFont(
                              text:
                                  "${habit.goalAmount!.toStringAsFixed(0)} ${habit.goalUnit!}",
                              fontSize: 12,
                              textColor:
                                  getColor(context, "black").withAlpha(100),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    return Container(
      decoration: BoxDecoration(
        boxShadow: boxShadowCheck(boxShadowGeneral(context)),
      ),
      child: OpenContainerNavigation(
        borderRadius: 20,
        closedColor: backgroundColor,
        button: (openContainer) {
          return Tappable(
            onTap: () {
              openContainer();
            },
            onLongPress: () {
              pushRoute(
                context,
                AddHabitsPage(
                  habit: habit,
                  routesToPopAfterDelete: RoutesToPopAfterDelete.One,
                ),
              );
            },
            borderRadius: 20,
            color: backgroundColor,
            child: content,
          );
        },
        openPage: AddHabitsPage(
          habit: habit,
          routesToPopAfterDelete: RoutesToPopAfterDelete.One,
        ),
      ),
    );
  }
}

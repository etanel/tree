import 'package:tree/database/tables.dart';
import 'package:tree/functions.dart';
import 'package:tree/pages/addHabitPage.dart';
import 'package:tree/struct/databaseGlobal.dart';
import 'package:tree/struct/settings.dart';
import 'package:tree/widgets/animatedExpanded.dart';
import 'package:tree/widgets/habitCard.dart';
import 'package:tree/widgets/navigationSidebar.dart';
import 'package:tree/widgets/noResults.dart';
import 'package:tree/widgets/openBottomSheet.dart';
import 'package:tree/widgets/framework/pageFramework.dart';
import 'package:tree/widgets/openPopup.dart';
import 'package:tree/widgets/tappable.dart';
import 'package:tree/widgets/textWidgets.dart';
import 'package:tree/colors.dart';
import 'package:flutter/material.dart'
    hide SliverReorderableList, ReorderableDelayedDragStartListener;
import 'addButton.dart';

class HabitsListPage extends StatefulWidget {
  const HabitsListPage({required this.enableBackButton, Key? key})
      : super(key: key);
  final bool enableBackButton;

  @override
  State<HabitsListPage> createState() => HabitsListPageState();
}

class HabitsListPageState extends State<HabitsListPage> {
  GlobalKey<PageFrameworkState> pageState = GlobalKey();
  bool _showArchived = false;

  void scrollToTop() {
    pageState.currentState?.scrollToTop();
  }

  @override
  Widget build(BuildContext context) {
    return PageFramework(
      key: pageState,
      title: "Habits",
      backButton: widget.enableBackButton,
      dragDownToDismiss: widget.enableBackButton,
      horizontalPaddingConstrained: enableDoubleColumn(context) == false,
      actions: [
        if (getIsFullScreen(context))
          IconButton(
            padding: EdgeInsetsDirectional.all(15),
            tooltip: "Add Habit",
            onPressed: () {
              pushRoute(
                context,
                AddHabitPage(
                  routesToPopAfterDelete: RoutesToPopAfterDelete.PreventDelete,
                ),
              );
            },
            icon: Icon(
              appStateSettings["outlinedIcons"]
                  ? Icons.add_outlined
                  : Icons.add_rounded,
              color: Theme.of(context).colorScheme.onSecondaryContainer,
            ),
          ),
      ],
      slivers: [
        // ── Active habits ─────────────────────────────────────────────────
        _HabitsList(showArchived: false),

        // ── Archived section header ───────────────────────────────────────
        SliverToBoxAdapter(
          child: StreamBuilder<List<Habit>>(
            stream: database.watchArchivedHabits(),
            builder: (context, snapshot) {
              final archivedHabits = snapshot.data ?? [];
              if (archivedHabits.isEmpty) return SizedBox.shrink();
              return Padding(
                padding: EdgeInsetsDirectional.only(
                  top: 15,
                  start: getHorizontalPaddingConstrained(context) + 20,
                  end: getHorizontalPaddingConstrained(context) + 20,
                ),
                child: Tappable(
                  borderRadius: 15,
                  color: Colors.transparent,
                  onTap: () {
                    setState(() {
                      _showArchived = !_showArchived;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsetsDirectional.symmetric(
                        horizontal: 5, vertical: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFont(
                            text: "Archived",
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            textColor:
                                getColor(context, "black").withOpacity(0.4),
                          ),
                        ),
                        AnimatedRotation(
                          duration: const Duration(milliseconds: 300),
                          turns: _showArchived ? 0.5 : 0,
                          child: Icon(
                            appStateSettings["outlinedIcons"]
                                ? Icons.expand_more_outlined
                                : Icons.expand_more_rounded,
                            color: getColor(context, "black").withOpacity(0.4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // ── Archived habits list ──────────────────────────────────────────
        SliverToBoxAdapter(
          child: AnimatedSizeSwitcher(
            child: _showArchived
                ? _HabitsList(
                    key: const ValueKey("archived"),
                    showArchived: true,
                    isArchivedSection: true,
                  )
                : SizedBox.shrink(key: const ValueKey("hidden")),
          ),
        ),

        // ── Bottom spacing ────────────────────────────────────────────────
        SliverToBoxAdapter(
          child: SizedBox(height: 75),
        ),
      ],
    );
  }
}

// ─── Inner list that streams either active or archived habits ────────────────

class _HabitsList extends StatelessWidget {
  const _HabitsList({
    this.showArchived = false,
    this.isArchivedSection = false,
    super.key,
  });

  final bool showArchived;
  final bool isArchivedSection;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Habit>>(
      stream: showArchived
          ? database.watchArchivedHabits()
          : database.watchAllHabits(),
      builder: (context, snapshot) {
        final habits = snapshot.data ?? [];

        // ── Empty state ─────────────────────────────────────────────────
        if (snapshot.hasData && habits.isEmpty && !isArchivedSection) {
          return Column(
            children: [
              NoResults(
                message: "No habits yet.\nTap + to create your first habit!",
              ),
              Padding(
                padding: EdgeInsetsDirectional.symmetric(
                  horizontal: 13,
                  vertical: 20,
                ),
                child: AddButton(
                  onTap: () {},
                  openPage: AddHabitPage(
                      routesToPopAfterDelete:
                          RoutesToPopAfterDelete.PreventDelete),
                  height: 150,
                ),
              ),
            ],
          );
        }

        if (snapshot.hasData && habits.isEmpty && isArchivedSection) {
          return Padding(
            padding: const EdgeInsetsDirectional.symmetric(
                horizontal: 30, vertical: 10),
            child: TextFont(
              text: "No archived habits.",
              fontSize: 14,
              textColor: getColor(context, "textLight"),
              textAlign: TextAlign.center,
            ),
          );
        }

        // ── Habit cards ─────────────────────────────────────────────────
        return Column(
          children: [
            for (int i = 0; i < habits.length; i++)
              _HabitCardWithLogs(
                habit: habits[i],
                isArchived: isArchivedSection,
              ),
            // Add button at the end (active list only)
            if (!isArchivedSection)
              Padding(
                padding: EdgeInsetsDirectional.only(
                  top: habits.isNotEmpty ? 10 : 0,
                  bottom: 10,
                  start: 13,
                  end: 13,
                ),
                child: AddButton(
                  onTap: () {},
                  openPage: AddHabitPage(
                      routesToPopAfterDelete:
                          RoutesToPopAfterDelete.PreventDelete),
                  height: 80,
                ),
              ),
          ],
        );
      },
    );
  }
}

// ─── Wraps each HabitCard with its own log stream ────────────────────────────

class _HabitCardWithLogs extends StatelessWidget {
  const _HabitCardWithLogs({
    required this.habit,
    this.isArchived = false,
  });

  final Habit habit;
  final bool isArchived;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<HabitLog>>(
      stream: database.watchHabitLogs(habit.habitPk),
      builder: (context, logSnapshot) {
        final logs = logSnapshot.data ?? [];
        return Opacity(
          opacity: isArchived ? 0.55 : 1.0,
          child: HabitCard(
            habit: habit,
            logs: logs,
          ),
        );
      },
    );
  }
}

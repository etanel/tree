import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Dashboard tab options
enum DashboardTab {
  all('All'),
  finance('Finance'),
  projects('Projects'),
  wellness('Wellness');

  const DashboardTab(this.label);
  final String label;
}

/// State for dashboard
class DashboardState {
  const DashboardState({
    this.selectedTab = DashboardTab.all,
    this.overallProgress = 0.68,
    this.level = 5,
    this.levelTitle = 'Sapling',
    this.dailyStreak = 12,
    this.tasksCompleted = 8,
    this.totalTasks = 12,
    this.savingsGoal = 1000,
    this.currentSavings = 450,
    this.activeProjects = 3,
  });

  final DashboardTab selectedTab;
  final double overallProgress;
  final int level;
  final String levelTitle;
  final int dailyStreak;
  final int tasksCompleted;
  final int totalTasks;
  final double savingsGoal;
  final double currentSavings;
  final int activeProjects;

  DashboardState copyWith({
    DashboardTab? selectedTab,
    double? overallProgress,
    int? level,
    String? levelTitle,
    int? dailyStreak,
    int? tasksCompleted,
    int? totalTasks,
    double? savingsGoal,
    double? currentSavings,
    int? activeProjects,
  }) {
    return DashboardState(
      selectedTab: selectedTab ?? this.selectedTab,
      overallProgress: overallProgress ?? this.overallProgress,
      level: level ?? this.level,
      levelTitle: levelTitle ?? this.levelTitle,
      dailyStreak: dailyStreak ?? this.dailyStreak,
      tasksCompleted: tasksCompleted ?? this.tasksCompleted,
      totalTasks: totalTasks ?? this.totalTasks,
      savingsGoal: savingsGoal ?? this.savingsGoal,
      currentSavings: currentSavings ?? this.currentSavings,
      activeProjects: activeProjects ?? this.activeProjects,
    );
  }
}

/// Provider for dashboard state
final dashboardProvider =
    NotifierProvider<DashboardNotifier, DashboardState>(
  DashboardNotifier.new,
);

/// Notifier for dashboard state
class DashboardNotifier extends Notifier<DashboardState> {
  @override
  DashboardState build() {
    return const DashboardState();
  }

  void selectTab(DashboardTab tab) {
    state = state.copyWith(selectedTab: tab);
  }

  void updateProgress(double progress) {
    state = state.copyWith(overallProgress: progress);
  }

  void incrementStreak() {
    state = state.copyWith(dailyStreak: state.dailyStreak + 1);
  }

  void completeTask() {
    if (state.tasksCompleted < state.totalTasks) {
      state = state.copyWith(tasksCompleted: state.tasksCompleted + 1);
    }
  }
}

/// Model for today's items
class TodayItem {
  const TodayItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.category,
    this.isCompleted = false,
    this.time,
  });

  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final int color;
  final DashboardTab category;
  final bool isCompleted;
  final String? time;
}

/// Provider for today's items
final todayItemsProvider = Provider<List<TodayItem>>((ref) {
  return const [
    TodayItem(
      id: '1',
      title: 'Morning meditation',
      subtitle: '15 minutes - Wellness routine',
      icon: Icons.self_improvement_rounded,
      color: 0xFF7CB342,
      category: DashboardTab.wellness,
      isCompleted: true,
      time: '7:00 AM',
    ),
    TodayItem(
      id: '2',
      title: 'Review budget report',
      subtitle: 'Monthly finance check',
      icon: Icons.attach_money_rounded,
      color: 0xFFFFC107,
      category: DashboardTab.finance,
      isCompleted: true,
      time: '9:00 AM',
    ),
    TodayItem(
      id: '3',
      title: 'Tree App milestone',
      subtitle: 'Complete dashboard design',
      icon: Icons.track_changes_rounded,
      color: 0xFF2D5016,
      category: DashboardTab.projects,
      isCompleted: false,
      time: '2:00 PM',
    ),
    TodayItem(
      id: '4',
      title: 'Gym session',
      subtitle: 'Upper body workout',
      icon: Icons.fitness_center_rounded,
      color: 0xFFE53935,
      category: DashboardTab.wellness,
      isCompleted: false,
      time: '6:00 PM',
    ),
    TodayItem(
      id: '5',
      title: 'Transfer to savings',
      subtitle: '\$100 automatic transfer',
      icon: Icons.savings_rounded,
      color: 0xFF1976D2,
      category: DashboardTab.finance,
      isCompleted: false,
      time: '8:00 PM',
    ),
  ];
});

/// Filtered items based on selected tab
final filteredTodayItemsProvider = Provider<List<TodayItem>>((ref) {
  final items = ref.watch(todayItemsProvider);
  final selectedTab = ref.watch(dashboardProvider).selectedTab;

  if (selectedTab == DashboardTab.all) {
    return items;
  }

  return items.where((item) => item.category == selectedTab).toList();
});

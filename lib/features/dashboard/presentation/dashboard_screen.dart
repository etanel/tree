import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_border_radius.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../onboarding/providers/onboarding_provider.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/quick_stats_grid.dart';
import '../widgets/todays_overview.dart';
import '../widgets/tree_hero_section.dart';

/// Main dashboard screen with custom scrolling behavior
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning';
    } else if (hour < 17) {
      return 'Good afternoon';
    } else {
      return 'Good evening';
    }
  }

  String _getGreetingEmoji() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return '🌅';
    } else if (hour < 17) {
      return '☀️';
    } else {
      return '🌙';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dashboardState = ref.watch(dashboardProvider);
    final userName = ref.watch(userNameProvider);

    // Format today's date
    final dateFormat = DateFormat('EEEE, MMMM d');
    final todayDate = dateFormat.format(DateTime.now());

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDark
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: isDark
            ? AppColors.backgroundDark
            : AppColors.backgroundWarmOffWhite,
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Custom App Bar
            SliverToBoxAdapter(
              child: _CustomAppBar(
                greeting: _getGreeting(),
                emoji: _getGreetingEmoji(),
                userName: userName,
                date: todayDate,
              ),
            ),

            // Tree Hero Section
            SliverToBoxAdapter(
              child: TreeHeroSection(
                progress: dashboardState.overallProgress,
                level: dashboardState.level,
                levelTitle: dashboardState.levelTitle,
              ),
            ),

            // Quick Stats
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: QuickStatsGrid(
                  stats: [
                    QuickStats.streak(dashboardState.dailyStreak),
                    QuickStats.tasks(
                      dashboardState.tasksCompleted,
                      dashboardState.totalTasks,
                    ),
                    QuickStats.savings(
                      dashboardState.currentSavings,
                      dashboardState.savingsGoal,
                    ),
                    QuickStats.projects(dashboardState.activeProjects),
                  ],
                ),
              ),
            ),

            // Section spacing
            const SliverToBoxAdapter(
              child: AppSpacing.verticalLg,
            ),

            // Today's Overview
            const SliverToBoxAdapter(
              child: TodaysOverview(),
            ),

            // Bottom safe area
            SliverToBoxAdapter(
              child: SizedBox(
                height: MediaQuery.of(context).padding.bottom + 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomAppBar extends StatelessWidget {
  const _CustomAppBar({
    required this.greeting,
    required this.emoji,
    required this.userName,
    required this.date,
  });

  final String greeting;
  final String emoji;
  final String userName;
  final String date;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final topPadding = MediaQuery.of(context).padding.top;

    return Container(
      padding: EdgeInsets.only(
        top: topPadding + 16,
        left: 20,
        right: 20,
        bottom: 8,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$greeting, $userName $emoji',
                  style: AppTextStyles.heading4(isDark: isDark),
                ),
                AppSpacing.verticalXxs,
                Text(
                  date,
                  style: AppTextStyles.bodyMedium(isDark: isDark).copyWith(
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),

          // Profile avatar
          GestureDetector(
            onTap: () {
              // Navigate to profile
            },
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: AppBorderRadius.radiusFull,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryForestGreen.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                  style: AppTextStyles.heading5(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

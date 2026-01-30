import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_border_radius.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../providers/dashboard_provider.dart';

/// Today's overview section with tab bar and items list
class TodaysOverview extends ConsumerWidget {
  const TodaysOverview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedTab = ref.watch(dashboardProvider).selectedTab;
    final items = ref.watch(filteredTodayItemsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: AppSpacing.paddingHorizontalMd,
          child: Text(
            "Today's Overview",
            style: AppTextStyles.heading5(isDark: isDark),
          ),
        ),

        AppSpacing.verticalMd,

        // Tab bar
        _TabBar(
          selectedTab: selectedTab,
          onTabSelected: (tab) {
            ref.read(dashboardProvider.notifier).selectTab(tab);
          },
        ),

        AppSpacing.verticalMd,

        // Items list
        if (items.isEmpty)
          _EmptyState(selectedTab: selectedTab)
        else
          ...items.map((item) => _TodayItemCard(item: item)),

        AppSpacing.verticalXl,
      ],
    );
  }
}

class _TabBar extends StatelessWidget {
  const _TabBar({
    required this.selectedTab,
    required this.onTabSelected,
  });

  final DashboardTab selectedTab;
  final ValueChanged<DashboardTab> onTabSelected;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: AppSpacing.paddingHorizontalMd,
      child: Row(
        children: DashboardTab.values.map((tab) {
          final isSelected = tab == selectedTab;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => onTabSelected(tab),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (isDark
                          ? AppColors.secondaryLightGreen
                          : AppColors.primaryForestGreen)
                      : (isDark
                          ? AppColors.surfaceDark
                          : Colors.white),
                  borderRadius: AppBorderRadius.radiusFull,
                  border: Border.all(
                    color: isSelected
                        ? Colors.transparent
                        : (isDark
                            ? AppColors.neutral600
                            : AppColors.neutral200),
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.primaryForestGreen.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  tab.label,
                  style: AppTextStyles.labelLarge(isDark: isDark).copyWith(
                    color: isSelected
                        ? Colors.white
                        : (isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _TodayItemCard extends StatelessWidget {
  const _TodayItemCard({required this.item});

  final TodayItem item;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final itemColor = Color(item.color);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: AppBorderRadius.radiusMd,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: AppBorderRadius.radiusMd,
          child: Padding(
            padding: AppSpacing.paddingAllMd,
            child: Row(
              children: [
                // Icon container
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: itemColor.withValues(alpha: 0.15),
                    borderRadius: AppBorderRadius.radiusSm,
                  ),
                  child: Center(
                    child: Text(
                      item.icon,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),

                AppSpacing.horizontalMd,

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: AppTextStyles.bodyMedium(isDark: isDark).copyWith(
                          fontWeight: FontWeight.w600,
                          decoration: item.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                          color: item.isCompleted
                              ? (isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight)
                              : null,
                        ),
                      ),
                      AppSpacing.verticalXxs,
                      Text(
                        item.subtitle,
                        style: AppTextStyles.caption(isDark: isDark),
                      ),
                    ],
                  ),
                ),

                // Time and status
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (item.time != null)
                      Text(
                        item.time!,
                        style: AppTextStyles.caption(isDark: isDark).copyWith(
                          color: itemColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    AppSpacing.verticalXxs,
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: item.isCompleted
                            ? AppColors.success
                            : Colors.transparent,
                        border: Border.all(
                          color: item.isCompleted
                              ? AppColors.success
                              : (isDark
                                  ? AppColors.neutral600
                                  : AppColors.neutral300),
                          width: 2,
                        ),
                        borderRadius: AppBorderRadius.radiusFull,
                      ),
                      child: item.isCompleted
                          ? const Icon(
                              Icons.check,
                              size: 14,
                              color: Colors.white,
                            )
                          : null,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.selectedTab});

  final DashboardTab selectedTab;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: AppSpacing.paddingHorizontalMd,
      padding: AppSpacing.paddingAllXl,
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceDark.withValues(alpha: 0.5)
            : AppColors.neutral100,
        borderRadius: AppBorderRadius.radiusMd,
      ),
      child: Column(
        children: [
          Text(
            '🌿',
            style: const TextStyle(fontSize: 40),
          ),
          AppSpacing.verticalMd,
          Text(
            'No ${selectedTab.label.toLowerCase()} items today',
            style: AppTextStyles.bodyMedium(isDark: isDark),
          ),
          AppSpacing.verticalXs,
          Text(
            'Add some tasks to grow your tree!',
            style: AppTextStyles.caption(isDark: isDark),
          ),
        ],
      ),
    );
  }
}

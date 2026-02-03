import 'package:flutter/material.dart';

import '../../../core/theme/app_border_radius.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

/// Quick stat card data
class QuickStatData {
  const QuickStatData({
    required this.icon,
    required this.label,
    required this.value,
    required this.accentColor,
    this.helper,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color accentColor;
  final String? helper;
  final VoidCallback? onTap;
}

/// Animated quick stats grid
class QuickStatsGrid extends StatefulWidget {
  const QuickStatsGrid({
    super.key,
    required this.stats,
  });

  final List<QuickStatData> stats;

  @override
  State<QuickStatsGrid> createState() => _QuickStatsGridState();
}

class _QuickStatsGridState extends State<QuickStatsGrid>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.stats.length,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 550),
        vsync: this,
      ),
    );

    _animations = _controllers.map((controller) {
      return Tween<double>(begin: 0.92, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeOutBack),
      );
    }).toList();

    _startAnimations();
  }

  void _startAnimations() async {
    for (int i = 0; i < _controllers.length; i++) {
      await Future.delayed(const Duration(milliseconds: 90));
      if (mounted) {
        _controllers[i].forward();
      }
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: AppSpacing.paddingHorizontalMd,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.6,
      ),
      itemCount: widget.stats.length,
      itemBuilder: (context, index) {
        return AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            return Transform.scale(
              scale: _animations[index].value,
              child: Opacity(
                opacity: _animations[index].value,
                child: child,
              ),
            );
          },
          child: _QuickStatCard(data: widget.stats[index]),
        );
      },
    );
  }
}

class _QuickStatCard extends StatelessWidget {
  const _QuickStatCard({required this.data});

  final QuickStatData data;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColors.surfaceDark : Colors.white;
    final borderColor = data.accentColor.withValues(alpha: isDark ? 0.3 : 0.22);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: data.onTap,
        borderRadius: AppBorderRadius.radiusMd,
        child: Container(
          padding: AppSpacing.paddingAllMd,
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: AppBorderRadius.radiusMd,
            border: Border.all(color: borderColor, width: 1.2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.06),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: data.accentColor.withValues(alpha: 0.16),
                      borderRadius: AppBorderRadius.radiusSm,
                    ),
                    child: Icon(
                      data.icon,
                      color: data.accentColor,
                      size: 20,
                    ),
                  ),
                  const Spacer(),
                  if (data.helper != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: data.accentColor.withValues(alpha: 0.12),
                        borderRadius: AppBorderRadius.radiusFull,
                      ),
                      child: Text(
                        data.helper!,
                        style: AppTextStyles.labelSmall(isDark: isDark).copyWith(
                          color: data.accentColor,
                        ),
                      ),
                    ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.value,
                    style: AppTextStyles.heading5(isDark: isDark),
                  ),
                  Text(
                    data.label,
                    style: AppTextStyles.caption(isDark: isDark),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Static factory methods for common stats
class QuickStats {
  static QuickStatData streak(int days, {VoidCallback? onTap}) {
    return QuickStatData(
      icon: Icons.local_fire_department_rounded,
      label: 'Daily Streak',
      value: '$days days',
      helper: 'This week',
      accentColor: const Color(0xFFFF8A50),
      onTap: onTap,
    );
  }

  static QuickStatData tasks(int completed, int total, {VoidCallback? onTap}) {
    return QuickStatData(
      icon: Icons.check_circle_rounded,
      label: 'Tasks Done',
      value: '$completed/$total',
      helper: 'Today',
      accentColor: AppColors.primaryForestGreen,
      onTap: onTap,
    );
  }

  static QuickStatData savings(double current, double goal,
      {VoidCallback? onTap}) {
    return QuickStatData(
      icon: Icons.savings_rounded,
      label: 'Savings Goal',
      value: '\$${current.toInt()}/\$${goal.toInt()}',
      helper: 'Monthly',
      accentColor: const Color(0xFFFFA726),
      onTap: onTap,
    );
  }

  static QuickStatData projects(int count, {VoidCallback? onTap}) {
    return QuickStatData(
      icon: Icons.track_changes_rounded,
      label: 'Active Projects',
      value: '$count',
      helper: 'In flight',
      accentColor: const Color(0xFF5C6BC0),
      onTap: onTap,
    );
  }
}

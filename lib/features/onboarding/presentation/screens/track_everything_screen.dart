import 'package:flutter/material.dart';

import '../../../../core/theme/app_border_radius.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Tracking category data
class TrackingCategory {
  const TrackingCategory({
    required this.icon,
    required this.label,
    required this.detail,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String detail;
  final Color color;
}

/// Screen 2: Track Everything screen with refined category tiles
class TrackEverythingScreen extends StatefulWidget {
  const TrackEverythingScreen({super.key});

  @override
  State<TrackEverythingScreen> createState() => _TrackEverythingScreenState();
}

class _TrackEverythingScreenState extends State<TrackEverythingScreen>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _scaleAnimations;
  late List<Animation<double>> _slideAnimations;

  static const categories = [
    TrackingCategory(
      icon: Icons.account_balance_wallet_rounded,
      label: 'Finance',
      detail: 'Budgets and savings',
      color: AppColors.accentGoldenYellow,
    ),
    TrackingCategory(
      icon: Icons.auto_graph_rounded,
      label: 'Projects',
      detail: 'Progress and milestones',
      color: AppColors.secondaryLightGreen,
    ),
    TrackingCategory(
      icon: Icons.local_florist_rounded,
      label: 'Habits',
      detail: 'Daily consistency',
      color: AppColors.primaryForestGreen,
    ),
    TrackingCategory(
      icon: Icons.health_and_safety_rounded,
      label: 'Wellness',
      detail: 'Mind and body',
      color: AppColors.error,
    ),
    TrackingCategory(
      icon: Icons.alarm_rounded,
      label: 'Routines',
      detail: 'Reminders and plans',
      color: AppColors.info,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      categories.length,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 600),
        vsync: this,
      ),
    );

    _scaleAnimations = _controllers.map((controller) {
      return Tween<double>(begin: 0.9, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeOutBack),
      );
    }).toList();

    _slideAnimations = _controllers.map((controller) {
      return Tween<double>(begin: 18.0, end: 0.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeOutCubic),
      );
    }).toList();

    _startAnimations();
  }

  void _startAnimations() async {
    for (int i = 0; i < _controllers.length; i++) {
      await Future.delayed(const Duration(milliseconds: 120));
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: Padding(
        padding: AppSpacing.screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(flex: 1),
            Text(
              'Track what matters',
              style: AppTextStyles.heading2(isDark: isDark),
            ),
            AppSpacing.verticalSm,
            Text(
              'Keep money, projects, and routines in one calm, connected place.',
              style: AppTextStyles.bodyLarge(isDark: isDark),
            ),
            AppSpacing.verticalXl,
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final tileWidth =
                      (constraints.maxWidth - AppSpacing.md) / 2;
                  return SingleChildScrollView(
                    child: Wrap(
                      spacing: AppSpacing.md,
                      runSpacing: AppSpacing.md,
                      children: List.generate(categories.length, (index) {
                        final category = categories[index];
                        return AnimatedBuilder(
                          animation: _controllers[index],
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(0, _slideAnimations[index].value),
                              child: Transform.scale(
                                scale: _scaleAnimations[index].value,
                                child: child,
                              ),
                            );
                          },
                          child: SizedBox(
                            width: tileWidth,
                            child: _CategoryTile(
                              category: category,
                              isDark: isDark,
                            ),
                          ),
                        );
                      }),
                    ),
                  );
                },
              ),
            ),
            const Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({
    required this.category,
    required this.isDark,
  });

  final TrackingCategory category;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.paddingAllMd,
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: AppBorderRadius.radiusLg,
        border: Border.all(
          color: category.color.withValues(alpha: 0.22),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: category.color.withValues(alpha: 0.18),
              borderRadius: AppBorderRadius.radiusSm,
            ),
            child: Icon(
              category.icon,
              color: category.color,
              size: 24,
            ),
          ),
          AppSpacing.verticalSm,
          Text(
            category.label,
            style: AppTextStyles.heading6(isDark: isDark),
          ),
          AppSpacing.verticalXxs,
          Text(
            category.detail,
            style: AppTextStyles.caption(isDark: isDark),
          ),
        ],
      ),
    );
  }
}

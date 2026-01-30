import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Tracking category data
class TrackingCategory {
  const TrackingCategory({
    required this.emoji,
    required this.label,
    required this.color,
  });

  final String emoji;
  final String label;
  final Color color;
}

/// Screen 2: Track Everything screen with animated icon grid
class TrackEverythingScreen extends StatefulWidget {
  const TrackEverythingScreen({super.key});

  @override
  State<TrackEverythingScreen> createState() => _TrackEverythingScreenState();
}

class _TrackEverythingScreenState extends State<TrackEverythingScreen>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _scaleAnimations;
  late List<Animation<double>> _bounceAnimations;

  static const categories = [
    TrackingCategory(
      emoji: '💰',
      label: 'Finance',
      color: AppColors.accentGoldenYellow,
    ),
    TrackingCategory(
      emoji: '📊',
      label: 'Projects',
      color: AppColors.secondaryLightGreen,
    ),
    TrackingCategory(
      emoji: '🎬',
      label: 'Media',
      color: AppColors.info,
    ),
    TrackingCategory(
      emoji: '💪',
      label: 'Wellness',
      color: AppColors.error,
    ),
    TrackingCategory(
      emoji: '⏰',
      label: 'Reminders',
      color: AppColors.primaryForestGreen,
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
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.elasticOut),
      );
    }).toList();

    _bounceAnimations = _controllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.bounceOut),
      );
    }).toList();

    // Stagger animations
    _startAnimations();
  }

  void _startAnimations() async {
    for (int i = 0; i < _controllers.length; i++) {
      await Future.delayed(const Duration(milliseconds: 100));
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
          children: [
            const Spacer(flex: 1),

            // Title
            Text(
              'Track all aspects\nof your life',
              style: AppTextStyles.heading2(isDark: isDark),
              textAlign: TextAlign.center,
            ),

            AppSpacing.verticalXxl,

            // Icon grid
            Wrap(
              spacing: AppSpacing.lg,
              runSpacing: AppSpacing.lg,
              alignment: WrapAlignment.center,
              children: List.generate(categories.length, (index) {
                final category = categories[index];
                return AnimatedBuilder(
                  animation: _controllers[index],
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimations[index].value,
                      child: Transform.translate(
                        offset: Offset(
                          0,
                          (1 - _bounceAnimations[index].value) * -30,
                        ),
                        child: child,
                      ),
                    );
                  },
                  child: _CategoryTile(category: category),
                );
              }),
            ),

            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({required this.category});

  final TrackingCategory category;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 90,
      padding: AppSpacing.paddingAllMd,
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceDark
            : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: category.color.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: category.color.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            category.emoji,
            style: const TextStyle(fontSize: 32),
          ),
          AppSpacing.verticalXs,
          Text(
            category.label,
            style: AppTextStyles.labelMedium(isDark: isDark),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

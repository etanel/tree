import 'package:flutter/material.dart';

import '../../../../core/theme/app_border_radius.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Screen 3: Visual Progress screen with polished dashboard preview
class VisualProgressScreen extends StatefulWidget {
  const VisualProgressScreen({super.key});

  @override
  State<VisualProgressScreen> createState() => _VisualProgressScreenState();
}

class _VisualProgressScreenState extends State<VisualProgressScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutCubic),
      ),
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
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
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeAnimation.value,
                  child: Transform.translate(
                    offset: Offset(0, _slideAnimation.value),
                    child: child,
                  ),
                );
              },
              child: Column(
                children: [
                  Text(
                    'See your progress\nat a glance',
                    style: AppTextStyles.heading2(isDark: isDark),
                    textAlign: TextAlign.center,
                  ),
                  AppSpacing.verticalMd,
                  Text(
                    'Beautiful snapshots highlight your weekly momentum.',
                    style: AppTextStyles.bodyLarge(isDark: isDark),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            AppSpacing.verticalXl,
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeAnimation.value,
                  child: child,
                );
              },
              child: _InsightCard(
                isDark: isDark,
                progress: _progressAnimation,
              ),
            ),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}

class _InsightCard extends StatelessWidget {
  const _InsightCard({
    required this.isDark,
    required this.progress,
  });

  final bool isDark;
  final Animation<double> progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.paddingAllLg,
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: AppBorderRadius.radiusLg,
        border: Border.all(
          color: isDark ? AppColors.neutral700 : AppColors.neutral200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.08),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primaryForestGreen.withValues(alpha: 0.12),
                  borderRadius: AppBorderRadius.radiusSm,
                ),
                child: const Icon(
                  Icons.insights_rounded,
                  color: AppColors.primaryForestGreen,
                ),
              ),
              AppSpacing.horizontalSm,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Weekly snapshot',
                    style: AppTextStyles.heading6(isDark: isDark),
                  ),
                  Text(
                    'Last 7 days',
                    style: AppTextStyles.caption(isDark: isDark),
                  ),
                ],
              ),
            ],
          ),
          AppSpacing.verticalLg,
          Row(
            children: const [
              Expanded(
                child: _MetricTile(
                  label: 'Consistency',
                  value: '5 of 7',
                ),
              ),
              AppSpacing.horizontalMd,
              Expanded(
                child: _MetricTile(
                  label: 'Focus time',
                  value: '6h 40m',
                ),
              ),
            ],
          ),
          AppSpacing.verticalLg,
          _MiniChart(progress: progress),
          AppSpacing.verticalLg,
          AnimatedBuilder(
            animation: progress,
            builder: (context, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Goal completion',
                    style: AppTextStyles.labelMedium(isDark: isDark),
                  ),
                  AppSpacing.verticalXs,
                  Stack(
                    children: [
                      Container(
                        height: 8,
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.neutral700
                              : AppColors.neutral200,
                          borderRadius: AppBorderRadius.radiusFull,
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: progress.value * 0.72,
                        child: Container(
                          height: 8,
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: AppBorderRadius.radiusFull,
                          ),
                        ),
                      ),
                    ],
                  ),
                  AppSpacing.verticalXxs,
                  Text(
                    '${(progress.value * 72).toInt()}% complete',
                    style: AppTextStyles.caption(isDark: isDark),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: AppSpacing.paddingAllMd,
      decoration: BoxDecoration(
        color:
            isDark ? AppColors.neutral800 : AppColors.backgroundWarmOffWhite,
        borderRadius: AppBorderRadius.radiusMd,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: AppTextStyles.heading5(isDark: isDark),
          ),
          AppSpacing.verticalXxs,
          Text(
            label,
            style: AppTextStyles.caption(isDark: isDark),
          ),
        ],
      ),
    );
  }
}

class _MiniChart extends StatelessWidget {
  const _MiniChart({required this.progress});

  final Animation<double> progress;

  @override
  Widget build(BuildContext context) {
    final barHeights = [0.55, 0.8, 0.6, 0.9, 0.7, 0.85, 0.95];

    return SizedBox(
      height: 90,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(7, (index) {
          return AnimatedBuilder(
            animation: progress,
            builder: (context, child) {
              return Container(
                width: 20,
                height: 90 * barHeights[index] * progress.value,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      AppColors.primaryForestGreen,
                      AppColors.secondaryLightGreen,
                    ],
                  ),
                  borderRadius: AppBorderRadius.radiusTopMd,
                ),
              );
            },
          );
        }),
      ),
    );
  }
}

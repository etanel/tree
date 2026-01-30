import 'package:flutter/material.dart';

import '../../../../core/theme/app_border_radius.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Screen 3: Visual Progress screen with mock dashboard preview
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

    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
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

            // Title and subtitle
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
                    'See your growth\nvisually',
                    style: AppTextStyles.heading2(isDark: isDark),
                    textAlign: TextAlign.center,
                  ),
                  AppSpacing.verticalMd,
                  Text(
                    'Beautiful charts and insights',
                    style: AppTextStyles.bodyLarge(isDark: isDark),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            AppSpacing.verticalXxl,

            // Mock dashboard preview
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeAnimation.value,
                  child: child,
                );
              },
              child: Container(
                padding: AppSpacing.paddingAllLg,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : Colors.white,
                  borderRadius: AppBorderRadius.radiusLg,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryForestGreen.withValues(alpha: 0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Dashboard header
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primaryForestGreen.withValues(alpha: 0.1),
                            borderRadius: AppBorderRadius.radiusSm,
                          ),
                          child: const Icon(
                            Icons.dashboard_rounded,
                            color: AppColors.primaryForestGreen,
                            size: 20,
                          ),
                        ),
                        AppSpacing.horizontalSm,
                        Text(
                          'Your Dashboard',
                          style: AppTextStyles.heading6(isDark: isDark),
                        ),
                      ],
                    ),

                    AppSpacing.verticalLg,

                    // Mock stats row
                    Row(
                      children: [
                        Expanded(
                          child: _MockStatCard(
                            icon: Icons.trending_up,
                            value: '87%',
                            label: 'Progress',
                            color: AppColors.secondaryLightGreen,
                            progress: _progressAnimation,
                          ),
                        ),
                        AppSpacing.horizontalMd,
                        Expanded(
                          child: _MockStatCard(
                            icon: Icons.check_circle,
                            value: '12',
                            label: 'Goals Met',
                            color: AppColors.accentGoldenYellow,
                            progress: _progressAnimation,
                          ),
                        ),
                      ],
                    ),

                    AppSpacing.verticalLg,

                    // Mock chart
                    _MockChart(progress: _progressAnimation),

                    AppSpacing.verticalMd,

                    // Animated progress bar
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Weekly Goal',
                          style: AppTextStyles.labelMedium(isDark: isDark),
                        ),
                        AppSpacing.verticalXs,
                        AnimatedBuilder(
                          animation: _progressAnimation,
                          builder: (context, child) {
                            return Stack(
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
                                  widthFactor: _progressAnimation.value * 0.75,
                                  child: Container(
                                    height: 8,
                                    decoration: BoxDecoration(
                                      gradient: AppColors.primaryGradient,
                                      borderRadius: AppBorderRadius.radiusFull,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        AppSpacing.verticalXxs,
                        AnimatedBuilder(
                          animation: _progressAnimation,
                          builder: (context, child) {
                            return Text(
                              '${(_progressAnimation.value * 75).toInt()}% complete',
                              style: AppTextStyles.caption(isDark: isDark),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}

class _MockStatCard extends StatelessWidget {
  const _MockStatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    required this.progress,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color color;
  final Animation<double> progress;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: progress,
      builder: (context, child) {
        return Opacity(
          opacity: progress.value,
          child: Transform.scale(
            scale: 0.8 + (0.2 * progress.value),
            child: child,
          ),
        );
      },
      child: Container(
        padding: AppSpacing.paddingAllMd,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: AppBorderRadius.radiusMd,
          border: Border.all(
            color: color.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 24),
            AppSpacing.verticalXs,
            Text(
              value,
              style: AppTextStyles.heading4(isDark: isDark),
            ),
            Text(
              label,
              style: AppTextStyles.caption(isDark: isDark),
            ),
          ],
        ),
      ),
    );
  }
}

class _MockChart extends StatelessWidget {
  const _MockChart({required this.progress});

  final Animation<double> progress;

  @override
  Widget build(BuildContext context) {

    final barHeights = [0.6, 0.8, 0.5, 0.9, 0.7, 0.85, 0.95];

    return SizedBox(
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(7, (index) {
          return AnimatedBuilder(
            animation: progress,
            builder: (context, child) {
              return Container(
                width: 24,
                height: 80 * barHeights[index] * progress.value,
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

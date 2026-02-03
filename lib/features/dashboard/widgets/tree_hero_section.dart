import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

/// Animated progress ring widget for tree visualization
class ProgressRing extends StatefulWidget {
  const ProgressRing({
    super.key,
    required this.progress,
    this.size = 200,
    this.strokeWidth = 12,
    this.backgroundColor,
    this.progressColor,
    this.child,
    this.animationDuration = const Duration(milliseconds: 1500),
  });

  final double progress;
  final double size;
  final double strokeWidth;
  final Color? backgroundColor;
  final Color? progressColor;
  final Widget? child;
  final Duration animationDuration;

  @override
  State<ProgressRing> createState() => _ProgressRingState();
}

class _ProgressRingState extends State<ProgressRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: widget.progress).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _controller.forward();
  }

  @override
  void didUpdateWidget(ProgressRing oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _animation = Tween<double>(
        begin: _animation.value,
        end: widget.progress,
      ).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
      );
      _controller
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return CustomPaint(
            painter: _ProgressRingPainter(
              progress: _animation.value,
              strokeWidth: widget.strokeWidth,
              backgroundColor: widget.backgroundColor ??
                  (isDark ? AppColors.neutral700 : AppColors.neutral200),
              progressColor: widget.progressColor ??
                  (isDark
                      ? AppColors.secondaryLightGreen
                      : AppColors.primaryForestGreen),
            ),
            child: Center(child: widget.child),
          );
        },
      ),
    );
  }
}

class _ProgressRingPainter extends CustomPainter {
  _ProgressRingPainter({
    required this.progress,
    required this.strokeWidth,
    required this.backgroundColor,
    required this.progressColor,
  });

  final double progress;
  final double strokeWidth;
  final Color backgroundColor;
  final Color progressColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background ring
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Progress ring
    final progressPaint = Paint()
      ..shader = SweepGradient(
        startAngle: -math.pi / 2,
        endAngle: math.pi * 1.5,
        colors: [
          progressColor,
          progressColor.withValues(alpha: 0.8),
          progressColor,
        ],
        stops: const [0.0, 0.5, 1.0],
        transform: const GradientRotation(-math.pi / 2),
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * math.pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );

    // Glow effect at the end
    if (progress > 0) {
      final endAngle = -math.pi / 2 + sweepAngle;
      final endX = center.dx + radius * math.cos(endAngle);
      final endY = center.dy + radius * math.sin(endAngle);

      final glowPaint = Paint()
        ..color = progressColor.withValues(alpha: 0.5)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

      canvas.drawCircle(Offset(endX, endY), strokeWidth / 2, glowPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _ProgressRingPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

/// Tree hero section widget
class TreeHeroSection extends StatelessWidget {
  const TreeHeroSection({
    super.key,
    required this.progress,
    required this.level,
    required this.levelTitle,
  });

  final double progress;
  final int level;
  final String levelTitle;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: AppSpacing.paddingAllLg,
      child: Column(
        children: [
          Text(
            'Your Tree',
            style: AppTextStyles.heading4(isDark: isDark),
          ),
          AppSpacing.verticalLg,
          ProgressRing(
            progress: progress,
            size: 220,
            strokeWidth: 14,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Tree centerpiece
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        AppColors.secondaryLightGreen.withValues(alpha: 0.3),
                        AppColors.primaryForestGreen.withValues(alpha: 0.1),
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.park_rounded,
                      color: AppColors.primaryForestGreen,
                      size: 54,
                    ),
                  ),
                ),
                AppSpacing.verticalSm,
                Text(
                  '${(progress * 100).toInt()}%',
                  style: AppTextStyles.heading5(isDark: isDark).copyWith(
                    color: isDark
                        ? AppColors.secondaryLightGreen
                        : AppColors.primaryForestGreen,
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.verticalMd,
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryForestGreen.withValues(alpha: 0.1),
                  AppColors.secondaryLightGreen.withValues(alpha: 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: (isDark
                        ? AppColors.secondaryLightGreen
                        : AppColors.primaryForestGreen)
                    .withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.local_florist_rounded,
                  color: AppColors.primaryForestGreen,
                  size: 16,
                ),
                AppSpacing.horizontalXs,
                Text(
                  'Level $level $levelTitle',
                  style: AppTextStyles.labelLarge(isDark: isDark).copyWith(
                    color: isDark
                        ? AppColors.secondaryLightGreen
                        : AppColors.primaryForestGreen,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

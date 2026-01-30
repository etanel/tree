import 'package:flutter/material.dart';

import '../../../core/theme/app_border_radius.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

/// Quick stat card data
class QuickStatData {
  const QuickStatData({
    required this.emoji,
    required this.label,
    required this.value,
    required this.gradient,
    this.subtitle,
    this.onTap,
  });

  final String emoji;
  final String label;
  final String value;
  final LinearGradient gradient;
  final String? subtitle;
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
        duration: const Duration(milliseconds: 600),
        vsync: this,
      ),
    );

    _animations = _controllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeOutBack),
      );
    }).toList();

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
    return GridView.builder(
      padding: AppSpacing.paddingHorizontalMd,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.5,
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


    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: data.onTap,
        borderRadius: AppBorderRadius.radiusMd,
        child: Container(
          padding: AppSpacing.paddingAllMd,
          decoration: BoxDecoration(
            gradient: data.gradient,
            borderRadius: AppBorderRadius.radiusMd,
            boxShadow: [
              BoxShadow(
                color: data.gradient.colors.first.withValues(alpha: 0.4),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    data.emoji,
                    style: const TextStyle(fontSize: 24),
                  ),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Icons.arrow_forward_ios,
                      size: 12,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.value,
                    style: AppTextStyles.heading5(color: Colors.white),
                  ),
                  Text(
                    data.label,
                    style: AppTextStyles.caption(color: Colors.white.withValues(alpha: 0.9)),
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
      emoji: '🔥',
      label: 'Daily Streak',
      value: '$days days',
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFFF6B35), Color(0xFFFF8E53)],
      ),
      onTap: onTap,
    );
  }

  static QuickStatData tasks(int completed, int total, {VoidCallback? onTap}) {
    return QuickStatData(
      emoji: '✅',
      label: 'Tasks Done',
      value: '$completed/$total',
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [AppColors.primaryForestGreen, AppColors.secondaryLightGreen],
      ),
      onTap: onTap,
    );
  }

  static QuickStatData savings(double current, double goal, {VoidCallback? onTap}) {
    return QuickStatData(
      emoji: '💰',
      label: 'Savings Goal',
      value: '\$${current.toInt()}/\$${goal.toInt()}',
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFFFA726), Color(0xFFFFCC02)],
      ),
      onTap: onTap,
    );
  }

  static QuickStatData projects(int count, {VoidCallback? onTap}) {
    return QuickStatData(
      emoji: '📊',
      label: 'Active Projects',
      value: '$count',
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF5C6BC0), Color(0xFF7986CB)],
      ),
      onTap: onTap,
    );
  }
}

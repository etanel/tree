import 'package:flutter/material.dart';


import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

import '../../../../shared/widgets/gradient_background.dart';

/// Screen 1: Welcome screen with Lottie animation placeholder
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.7, curve: Curves.elasticOut),
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
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
    return GradientBackground(
      gradientType: GradientType.secondary,
      child: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            children: [
              const Spacer(flex: 1),

              // Lottie animation placeholder (growing tree)
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: child,
                  );
                },
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Placeholder for Lottie animation
                        Icon(
                          Icons.park,
                          size: 100,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                        AppSpacing.verticalSm,
                        Text(
                          '🌱',
                          style: const TextStyle(fontSize: 40),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              AppSpacing.verticalXxl,

              // Title and subtitle
              AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: child,
                  );
                },
                child: Column(
                  children: [
                    Text(
                      'Welcome to Tree',
                      style: AppTextStyles.heading1(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    AppSpacing.verticalMd,
                    Text(
                      'Your personal growth companion',
                      style: AppTextStyles.bodyLarge(color: Colors.white.withValues(alpha: 0.9)),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}

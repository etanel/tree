import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Type of gradient for the background
enum GradientType {
  /// Primary forest green gradient
  primary,

  /// Secondary light green gradient
  secondary,

  /// Accent golden yellow gradient
  accent,

  /// Nature-inspired multi-color gradient
  nature,

  /// Dark theme gradient
  dark,

  /// Custom gradient (requires [customGradient] parameter)
  custom,
}

/// A widget that provides a gradient background
class GradientBackground extends StatelessWidget {
  const GradientBackground({
    super.key,
    required this.child,
    this.gradientType = GradientType.primary,
    this.customGradient,
    this.opacity = 1.0,
    this.borderRadius,
    this.padding,
    this.width,
    this.height,
  });

  /// Child widget to display on top of the gradient
  final Widget child;

  /// Type of gradient to use
  final GradientType gradientType;

  /// Custom gradient (only used when [gradientType] is [GradientType.custom])
  final Gradient? customGradient;

  /// Opacity of the gradient (0.0 to 1.0)
  final double opacity;

  /// Optional border radius for rounded corners
  final BorderRadius? borderRadius;

  /// Optional padding around the child
  final EdgeInsets? padding;

  /// Optional fixed width
  final double? width;

  /// Optional fixed height
  final double? height;

  @override
  Widget build(BuildContext context) {
    final Gradient gradient = _getGradient();

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: opacity < 1.0
            ? LinearGradient(
                colors: (gradient as LinearGradient)
                    .colors
                    .map((c) => c.withValues(alpha: opacity))
                    .toList(),
                begin: gradient.begin,
                end: gradient.end,
                stops: gradient.stops,
              )
            : gradient,
        borderRadius: borderRadius,
      ),
      padding: padding,
      child: child,
    );
  }

  Gradient _getGradient() {
    switch (gradientType) {
      case GradientType.primary:
        return AppColors.primaryGradient;
      case GradientType.secondary:
        return AppColors.secondaryGradient;
      case GradientType.accent:
        return AppColors.accentGradient;
      case GradientType.nature:
        return AppColors.natureGradient;
      case GradientType.dark:
        return AppColors.darkGradient;
      case GradientType.custom:
        return customGradient ?? AppColors.primaryGradient;
    }
  }
}

/// A scaffold with a gradient background
class GradientScaffold extends StatelessWidget {
  const GradientScaffold({
    super.key,
    required this.body,
    this.gradientType = GradientType.primary,
    this.customGradient,
    this.appBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bottomNavigationBar,
    this.extendBodyBehindAppBar = true,
    this.resizeToAvoidBottomInset = true,
  });

  /// Main body content
  final Widget body;

  /// Type of gradient for the background
  final GradientType gradientType;

  /// Custom gradient (only used when [gradientType] is [GradientType.custom])
  final Gradient? customGradient;

  /// Optional app bar
  final PreferredSizeWidget? appBar;

  /// Optional floating action button
  final Widget? floatingActionButton;

  /// FAB location
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  /// Optional bottom navigation bar
  final Widget? bottomNavigationBar;

  /// Whether to extend body behind app bar
  final bool extendBodyBehindAppBar;

  /// Whether to resize when keyboard appears
  final bool resizeToAvoidBottomInset;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomNavigationBar: bottomNavigationBar,
      body: GradientBackground(
        gradientType: gradientType,
        customGradient: customGradient,
        child: body,
      ),
    );
  }
}

/// A container with animated gradient transitions
class AnimatedGradientBackground extends StatefulWidget {
  const AnimatedGradientBackground({
    super.key,
    required this.child,
    this.gradients = const [
      AppColors.primaryGradient,
      AppColors.secondaryGradient,
      AppColors.natureGradient,
    ],
    this.duration = const Duration(seconds: 3),
    this.borderRadius,
    this.padding,
  });

  /// Child widget
  final Widget child;

  /// List of gradients to animate between
  final List<LinearGradient> gradients;

  /// Duration of each gradient transition
  final Duration duration;

  /// Optional border radius
  final BorderRadius? borderRadius;

  /// Optional padding
  final EdgeInsets? padding;

  @override
  State<AnimatedGradientBackground> createState() =>
      _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState extends State<AnimatedGradientBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller)
      ..addListener(() => setState(() {}))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _currentIndex = (_currentIndex + 1) % widget.gradients.length;
          _controller.reset();
          _controller.forward();
        }
      });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final nextIndex = (_currentIndex + 1) % widget.gradients.length;
    final currentGradient = widget.gradients[_currentIndex];
    final nextGradient = widget.gradients[nextIndex];

    // Interpolate between gradients
    final interpolatedColors = List<Color>.generate(
      currentGradient.colors.length,
      (i) => Color.lerp(
        currentGradient.colors[i],
        nextGradient.colors[i % nextGradient.colors.length],
        _animation.value,
      )!,
    );

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: interpolatedColors,
          begin: currentGradient.begin,
          end: currentGradient.end,
        ),
        borderRadius: widget.borderRadius,
      ),
      padding: widget.padding,
      child: widget.child,
    );
  }
}

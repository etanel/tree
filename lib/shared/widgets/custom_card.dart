import 'package:flutter/material.dart';

import '../../core/theme/app_border_radius.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

/// Elevation levels for CustomCard
enum CardElevation {
  /// No elevation (flat card)
  none,

  /// Low elevation with subtle shadow
  low,

  /// Medium elevation (default)
  medium,

  /// High elevation with prominent shadow
  high,
}

/// A customizable card widget with elevation and rounded corners
class CustomCard extends StatelessWidget {
  const CustomCard({
    super.key,
    required this.child,
    this.elevation = CardElevation.medium,
    this.padding,
    this.margin,
    this.borderRadius,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth,
    this.width,
    this.height,
    this.onTap,
    this.onLongPress,
    this.clipBehavior = Clip.antiAlias,
  });

  /// Card content
  final Widget child;

  /// Elevation level
  final CardElevation elevation;

  /// Internal padding
  final EdgeInsets? padding;

  /// External margin
  final EdgeInsets? margin;

  /// Custom border radius
  final BorderRadius? borderRadius;

  /// Custom background color
  final Color? backgroundColor;

  /// Optional border color
  final Color? borderColor;

  /// Border width (only applies if borderColor is set)
  final double? borderWidth;

  /// Fixed width
  final double? width;

  /// Fixed height
  final double? height;

  /// Tap callback for interactive cards
  final VoidCallback? onTap;

  /// Long press callback
  final VoidCallback? onLongPress;

  /// How to clip the content
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Determine shadow based on elevation level
    final List<BoxShadow> shadows = switch (elevation) {
      CardElevation.none => [],
      CardElevation.low => [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      CardElevation.medium => [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      CardElevation.high => [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.5 : 0.15),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
    };

    // Default colors
    final effectiveBackgroundColor = backgroundColor ??
        (isDark ? AppColors.surfaceDark : Colors.white);

    final effectiveBorderRadius = borderRadius ?? AppBorderRadius.card;

    Widget cardContent = Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: effectiveBorderRadius,
        border: borderColor != null
            ? Border.all(
                color: borderColor!,
                width: borderWidth ?? 1,
              )
            : null,
        boxShadow: shadows,
      ),
      clipBehavior: clipBehavior,
      child: padding != null
          ? Padding(padding: padding!, child: child)
          : Padding(padding: AppSpacing.cardPadding, child: child),
    );

    // Make interactive if callbacks provided
    if (onTap != null || onLongPress != null) {
      return Material(
        color: Colors.transparent,
        borderRadius: effectiveBorderRadius,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: effectiveBorderRadius,
          child: cardContent,
        ),
      );
    }

    return cardContent;
  }
}

/// A variant of CustomCard with a gradient header
class CustomCardWithHeader extends StatelessWidget {
  const CustomCardWithHeader({
    super.key,
    required this.header,
    required this.child,
    this.headerGradient,
    this.headerPadding,
    this.bodyPadding,
    this.elevation = CardElevation.medium,
    this.borderRadius,
  });

  /// Header content (typically text or row with icon)
  final Widget header;

  /// Body content
  final Widget child;

  /// Optional gradient for header background
  final Gradient? headerGradient;

  /// Header section padding
  final EdgeInsets? headerPadding;

  /// Body section padding
  final EdgeInsets? bodyPadding;

  /// Card elevation
  final CardElevation elevation;

  /// Card border radius
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final effectiveRadius = borderRadius ?? AppBorderRadius.card;

    return CustomCard(
      elevation: elevation,
      borderRadius: effectiveRadius,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: headerPadding ?? AppSpacing.cardPadding,
            decoration: BoxDecoration(
              gradient: headerGradient ?? AppColors.primaryGradient,
              borderRadius: BorderRadius.only(
                topLeft: effectiveRadius.topLeft,
                topRight: effectiveRadius.topRight,
              ),
            ),
            child: DefaultTextStyle(
              style: const TextStyle(color: Colors.white),
              child: IconTheme(
                data: const IconThemeData(color: Colors.white),
                child: header,
              ),
            ),
          ),
          Padding(
            padding: bodyPadding ?? AppSpacing.cardPadding,
            child: child,
          ),
        ],
      ),
    );
  }
}

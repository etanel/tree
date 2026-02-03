import 'package:flutter/material.dart';

import '../../core/theme/app_border_radius.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

/// Button variant types
enum CustomButtonVariant {
  /// Primary filled button with main brand color
  primary,

  /// Secondary outlined button
  secondary,

  /// Text-only button with no background
  text,
}

/// Button size options
enum CustomButtonSize {
  /// Small button with compact padding
  small,

  /// Medium button (default)
  medium,

  /// Large button with extra padding
  large,
}

/// A customizable button widget with primary, secondary, and text variants
class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = CustomButtonVariant.primary,
    this.size = CustomButtonSize.medium,
    this.icon,
    this.iconPosition = IconPosition.left,
    this.isLoading = false,
    this.isDisabled = false,
    this.width,
    this.borderRadius,
  });

  /// Button label text
  final String text;

  /// Callback when button is pressed
  final VoidCallback? onPressed;

  /// Button style variant
  final CustomButtonVariant variant;

  /// Button size
  final CustomButtonSize size;

  /// Optional icon widget
  final IconData? icon;

  /// Position of the icon relative to text
  final IconPosition iconPosition;

  /// Whether to show loading indicator
  final bool isLoading;

  /// Whether the button is disabled
  final bool isDisabled;

  /// Optional fixed width
  final double? width;

  /// Custom border radius
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveOnPressed = isDisabled || isLoading ? null : onPressed;

    // Determine padding based on size
    final EdgeInsets padding = switch (size) {
      CustomButtonSize.small =>
        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      CustomButtonSize.medium =>
        const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      CustomButtonSize.large =>
        const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
    };

    // Determine text style based on size
    final TextStyle textStyle = switch (size) {
      CustomButtonSize.small => AppTextStyles.labelMedium(isDark: isDark),
      CustomButtonSize.medium => AppTextStyles.labelLarge(isDark: isDark),
      CustomButtonSize.large => AppTextStyles.bodyMedium(isDark: isDark)
          .copyWith(fontWeight: FontWeight.w600),
    };

    // Determine icon size based on button size
    final double iconSize = switch (size) {
      CustomButtonSize.small => 16,
      CustomButtonSize.medium => 20,
      CustomButtonSize.large => 24,
    };

    Widget buttonChild = _buildButtonContent(textStyle, iconSize);

    switch (variant) {
      case CustomButtonVariant.primary:
        return SizedBox(
          width: width,
          child: ElevatedButton(
            onPressed: effectiveOnPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: isDark
                  ? AppColors.secondaryLightGreen
                  : AppColors.primaryForestGreen,
              foregroundColor: isDark ? Colors.black : Colors.white,
              disabledBackgroundColor: isDark
                  ? AppColors.neutral700
                  : AppColors.neutral300,
              disabledForegroundColor: isDark
                  ? AppColors.neutral500
                  : AppColors.neutral500,
              padding: padding,
              shape: RoundedRectangleBorder(
                borderRadius: borderRadius ?? AppBorderRadius.button,
              ),
              elevation: isDisabled ? 0 : 2,
            ),
            child: buttonChild,
          ),
        );

      case CustomButtonVariant.secondary:
        return SizedBox(
          width: width,
          child: OutlinedButton(
            onPressed: effectiveOnPressed,
            style: OutlinedButton.styleFrom(
              foregroundColor: isDark
                  ? AppColors.secondaryLightGreen
                  : AppColors.primaryForestGreen,
              side: BorderSide(
                color: isDisabled
                    ? AppColors.neutral400
                    : (isDark
                        ? AppColors.secondaryLightGreen
                        : AppColors.primaryForestGreen),
                width: 1.5,
              ),
              padding: padding,
              shape: RoundedRectangleBorder(
                borderRadius: borderRadius ?? AppBorderRadius.button,
              ),
            ),
            child: buttonChild,
          ),
        );

      case CustomButtonVariant.text:
        return SizedBox(
          width: width,
          child: TextButton(
            onPressed: effectiveOnPressed,
            style: TextButton.styleFrom(
              foregroundColor: isDark
                  ? AppColors.secondaryLightGreen
                  : AppColors.primaryForestGreen,
              padding: padding,
              shape: RoundedRectangleBorder(
                borderRadius: borderRadius ?? AppBorderRadius.button,
              ),
            ),
            child: buttonChild,
          ),
        );
    }
  }

  Widget _buildButtonContent(TextStyle textStyle, double iconSize) {
    if (isLoading) {
      return SizedBox(
        height: iconSize,
        width: iconSize,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            variant == CustomButtonVariant.primary
                ? Colors.white
                : AppColors.primaryForestGreen,
          ),
        ),
      );
    }

    if (icon == null) {
      return Text(text, style: textStyle);
    }

    final iconWidget = Icon(icon, size: iconSize);
    final spacing = AppSpacing.horizontalXs;

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: iconPosition == IconPosition.left
          ? [iconWidget, spacing, Text(text, style: textStyle)]
          : [Text(text, style: textStyle), spacing, iconWidget],
    );
  }
}

/// Icon position relative to button text
enum IconPosition {
  left,
  right,
}

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

/// A reusable section header widget with optional subtitle and action
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.action,
    this.actionText,
    this.onActionTap,
    this.icon,
    this.iconColor,
    this.padding,
    this.titleStyle,
    this.subtitleStyle,
    this.showDivider = false,
    this.dividerColor,
  });

  /// Main title text
  final String title;

  /// Optional subtitle text
  final String? subtitle;

  /// Optional action widget (overrides [actionText] and [onActionTap])
  final Widget? action;

  /// Text for the action button
  final String? actionText;

  /// Callback when action is tapped
  final VoidCallback? onActionTap;

  /// Optional leading icon
  final IconData? icon;

  /// Color for the icon
  final Color? iconColor;

  /// Custom padding around the header
  final EdgeInsets? padding;

  /// Custom title text style
  final TextStyle? titleStyle;

  /// Custom subtitle text style
  final TextStyle? subtitleStyle;

  /// Whether to show a divider below the header
  final bool showDivider;

  /// Custom divider color
  final Color? dividerColor;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final effectiveTitleStyle = titleStyle ??
        AppTextStyles.heading5(isDark: isDark);

    final effectiveSubtitleStyle = subtitleStyle ??
        AppTextStyles.bodySmall(isDark: isDark);

    final effectiveIconColor = iconColor ??
        (isDark ? AppColors.secondaryLightGreen : AppColors.primaryForestGreen);

    return Padding(
      padding: padding ?? AppSpacing.paddingVerticalMd,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Leading icon
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 24,
                  color: effectiveIconColor,
                ),
                AppSpacing.horizontalSm,
              ],

              // Title and subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: effectiveTitleStyle,
                    ),
                    if (subtitle != null) ...[
                      AppSpacing.verticalXxs,
                      Text(
                        subtitle!,
                        style: effectiveSubtitleStyle,
                      ),
                    ],
                  ],
                ),
              ),

              // Action button
              if (action != null)
                action!
              else if (actionText != null && onActionTap != null)
                TextButton(
                  onPressed: onActionTap,
                  style: TextButton.styleFrom(
                    foregroundColor: isDark
                        ? AppColors.secondaryLightGreen
                        : AppColors.primaryForestGreen,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  child: Text(
                    actionText!,
                    style: AppTextStyles.labelLarge(isDark: isDark).copyWith(
                      color: isDark
                          ? AppColors.secondaryLightGreen
                          : AppColors.primaryForestGreen,
                    ),
                  ),
                ),
            ],
          ),

          // Optional divider
          if (showDivider) ...[
            AppSpacing.verticalSm,
            Divider(
              color: dividerColor ??
                  (isDark
                      ? AppColors.neutral700
                      : AppColors.neutral300),
              height: 1,
            ),
          ],
        ],
      ),
    );
  }
}

/// A section header with a decorative accent bar
class AccentSectionHeader extends StatelessWidget {
  const AccentSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.accentColor,
    this.accentWidth = 4,
    this.padding,
  });

  /// Main title text
  final String title;

  /// Optional subtitle text
  final String? subtitle;

  /// Color of the accent bar
  final Color? accentColor;

  /// Width of the accent bar
  final double accentWidth;

  /// Custom padding
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final effectiveAccentColor = accentColor ??
        (isDark ? AppColors.secondaryLightGreen : AppColors.primaryForestGreen);

    return Padding(
      padding: padding ?? AppSpacing.paddingVerticalMd,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Accent bar
          Container(
            width: accentWidth,
            height: subtitle != null ? 48 : 28,
            decoration: BoxDecoration(
              color: effectiveAccentColor,
              borderRadius: BorderRadius.circular(accentWidth / 2),
            ),
          ),
          AppSpacing.horizontalSm,

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.heading5(isDark: isDark),
                ),
                if (subtitle != null) ...[
                  AppSpacing.verticalXxs,
                  Text(
                    subtitle!,
                    style: AppTextStyles.bodySmall(isDark: isDark),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A numbered section header for step-by-step content
class NumberedSectionHeader extends StatelessWidget {
  const NumberedSectionHeader({
    super.key,
    required this.number,
    required this.title,
    this.subtitle,
    this.isCompleted = false,
    this.isActive = false,
    this.padding,
  });

  /// Step number
  final int number;

  /// Title text
  final String title;

  /// Optional subtitle
  final String? subtitle;

  /// Whether this step is completed
  final bool isCompleted;

  /// Whether this step is currently active
  final bool isActive;

  /// Custom padding
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color circleColor;
    final Color textColor;
    final IconData? checkIcon;

    if (isCompleted) {
      circleColor = AppColors.success;
      textColor = Colors.white;
      checkIcon = Icons.check;
    } else if (isActive) {
      circleColor = isDark
          ? AppColors.secondaryLightGreen
          : AppColors.primaryForestGreen;
      textColor = Colors.white;
      checkIcon = null;
    } else {
      circleColor = isDark ? AppColors.neutral700 : AppColors.neutral300;
      textColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
      checkIcon = null;
    }

    return Padding(
      padding: padding ?? AppSpacing.paddingVerticalSm,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Number circle
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: circleColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: checkIcon != null
                  ? Icon(checkIcon, size: 18, color: textColor)
                  : Text(
                      '$number',
                      style: AppTextStyles.labelLarge().copyWith(
                        color: textColor,
                      ),
                    ),
            ),
          ),
          AppSpacing.horizontalMd,

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.heading6(isDark: isDark).copyWith(
                    color: isActive || isCompleted
                        ? null
                        : (isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight),
                  ),
                ),
                if (subtitle != null) ...[
                  AppSpacing.verticalXxs,
                  Text(
                    subtitle!,
                    style: AppTextStyles.caption(isDark: isDark),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

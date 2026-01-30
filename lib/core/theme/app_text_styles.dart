import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// App text styles with typography scales
/// Headers: Poppins (heading1-6)
/// Body: Inter (body, caption, label)
class AppTextStyles {
  AppTextStyles._();

  // ============ HEADINGS (Poppins) ============

  /// Heading 1 - Largest heading, used for main page titles
  static TextStyle heading1({Color? color, bool isDark = false}) {
    return GoogleFonts.poppins(
      fontSize: 48,
      fontWeight: FontWeight.w700,
      height: 1.2,
      letterSpacing: -1.5,
      color: color ?? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
    );
  }

  /// Heading 2 - Section titles
  static TextStyle heading2({Color? color, bool isDark = false}) {
    return GoogleFonts.poppins(
      fontSize: 40,
      fontWeight: FontWeight.w700,
      height: 1.25,
      letterSpacing: -0.5,
      color: color ?? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
    );
  }

  /// Heading 3 - Subsection titles
  static TextStyle heading3({Color? color, bool isDark = false}) {
    return GoogleFonts.poppins(
      fontSize: 32,
      fontWeight: FontWeight.w600,
      height: 1.3,
      letterSpacing: 0,
      color: color ?? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
    );
  }

  /// Heading 4 - Card titles, dialog headers
  static TextStyle heading4({Color? color, bool isDark = false}) {
    return GoogleFonts.poppins(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      height: 1.35,
      letterSpacing: 0.25,
      color: color ?? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
    );
  }

  /// Heading 5 - Component titles
  static TextStyle heading5({Color? color, bool isDark = false}) {
    return GoogleFonts.poppins(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      height: 1.4,
      letterSpacing: 0,
      color: color ?? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
    );
  }

  /// Heading 6 - Small headers, list item titles
  static TextStyle heading6({Color? color, bool isDark = false}) {
    return GoogleFonts.poppins(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      height: 1.45,
      letterSpacing: 0.15,
      color: color ?? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
    );
  }

  // ============ BODY TEXT (Inter) ============

  /// Body Large - Primary body text
  static TextStyle bodyLarge({Color? color, bool isDark = false}) {
    return GoogleFonts.inter(
      fontSize: 18,
      fontWeight: FontWeight.w400,
      height: 1.6,
      letterSpacing: 0.5,
      color: color ?? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
    );
  }

  /// Body Medium - Standard body text
  static TextStyle bodyMedium({Color? color, bool isDark = false}) {
    return GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      height: 1.5,
      letterSpacing: 0.25,
      color: color ?? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
    );
  }

  /// Body Small - Secondary body text
  static TextStyle bodySmall({Color? color, bool isDark = false}) {
    return GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.45,
      letterSpacing: 0.25,
      color: color ?? (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
    );
  }

  // ============ CAPTIONS (Inter) ============

  /// Caption - Small text for labels, hints
  static TextStyle caption({Color? color, bool isDark = false}) {
    return GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      height: 1.35,
      letterSpacing: 0.4,
      color: color ?? (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
    );
  }

  /// Caption Bold - Emphasized small text
  static TextStyle captionBold({Color? color, bool isDark = false}) {
    return GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      height: 1.35,
      letterSpacing: 0.4,
      color: color ?? (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
    );
  }

  /// Overline - All caps small text
  static TextStyle overline({Color? color, bool isDark = false}) {
    return GoogleFonts.inter(
      fontSize: 10,
      fontWeight: FontWeight.w500,
      height: 1.5,
      letterSpacing: 1.5,
      color: color ?? (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
    );
  }

  // ============ LABELS (Inter) ============

  /// Label Large - Button text, tabs
  static TextStyle labelLarge({Color? color, bool isDark = false}) {
    return GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      height: 1.4,
      letterSpacing: 0.1,
      color: color ?? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
    );
  }

  /// Label Medium - Form labels
  static TextStyle labelMedium({Color? color, bool isDark = false}) {
    return GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      height: 1.35,
      letterSpacing: 0.5,
      color: color ?? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
    );
  }

  /// Label Small - Chip labels, tags
  static TextStyle labelSmall({Color? color, bool isDark = false}) {
    return GoogleFonts.inter(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      height: 1.3,
      letterSpacing: 0.5,
      color: color ?? (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
    );
  }

  // ============ SPECIAL STYLES ============

  /// Link text style
  static TextStyle link({Color? color, bool isDark = false}) {
    return GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      height: 1.5,
      letterSpacing: 0.25,
      color: color ?? (isDark ? AppColors.secondaryLightGreen : AppColors.primaryForestGreen),
      decoration: TextDecoration.underline,
    );
  }

  /// Quote text style
  static TextStyle quote({Color? color, bool isDark = false}) {
    return GoogleFonts.poppins(
      fontSize: 18,
      fontWeight: FontWeight.w400,
      height: 1.6,
      letterSpacing: 0.5,
      fontStyle: FontStyle.italic,
      color: color ?? (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
    );
  }

  /// Code/Monospace text style
  static TextStyle code({Color? color, bool isDark = false}) {
    return GoogleFonts.firaCode(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.5,
      letterSpacing: 0,
      color: color ?? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
    );
  }
}

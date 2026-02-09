import 'package:flutter/material.dart';

/// App color palette with light and dark mode support
class AppColors {
  AppColors._();

  // Primary colors
  static const Color primaryForestGreen = Color(0xFF2D5016);
  static const Color primaryForestGreenLight = Color(0xFF4A7A2A);
  static const Color primaryForestGreenDark = Color(0xFF1A3009);

  // Secondary colors
  static const Color secondaryLightGreen = Color(0xFF7CB342);
  static const Color secondaryLightGreenLight = Color(0xFFA5D066);
  static const Color secondaryLightGreenDark = Color(0xFF558B2F);

  // Accent colors
  static const Color accentGoldenYellow = Color(0xFFFFC107);
  static const Color accentGoldenYellowLight = Color(0xFFFFD54F);
  static const Color accentGoldenYellowDark = Color(0xFFFFA000);

  // Background colors
  static const Color backgroundWarmOffWhite = Color(0xFFF5F5DC);
  static const Color backgroundLight = Color(0xFFFAFAF5);
  static const Color backgroundDark = Color(0xFF1A1A1A);
  static const Color surfaceDark = Color(0xFF2D2D2D);

  // Text colors
  static const Color textPrimaryLight = Color(0xFF1A1A1A);
  static const Color textSecondaryLight = Color(0xFF5A5A5A);
  static const Color textPrimaryDark = Color(0xFFF5F5F5);
  static const Color textSecondaryDark = Color(0xFFB0B0B0);

  // Error colors
  static const Color error = Color(0xFFD32F2F);
  static const Color errorLight = Color(0xFFEF5350);
  static const Color errorDark = Color(0xFFC62828);

  // Success colors
  static const Color success = Color(0xFF388E3C);
  static const Color successLight = Color(0xFF4CAF50);
  static const Color successDark = Color(0xFF2E7D32);

  // Warning colors
  static const Color warning = Color(0xFFFF9800);
  static const Color warningLight = Color(0xFFFFB74D);
  static const Color warningDark = Color(0xFFF57C00);

  // Info colors
  static const Color info = Color(0xFF2196F3);
  static const Color infoLight = Color(0xFF64B5F6);
  static const Color infoDark = Color(0xFF1976D2);

  // Neutral colors
  static const Color neutral100 = Color(0xFFF5F5F5);
  static const Color neutral200 = Color(0xFFEEEEEE);
  static const Color neutral300 = Color(0xFFE0E0E0);
  static const Color neutral400 = Color(0xFFBDBDBD);
  static const Color neutral500 = Color(0xFF9E9E9E);
  static const Color neutral600 = Color(0xFF757575);
  static const Color neutral700 = Color(0xFF616161);
  static const Color neutral800 = Color(0xFF424242);
  static const Color neutral900 = Color(0xFF212121);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryForestGreen, primaryForestGreenLight],
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondaryLightGreen, secondaryLightGreenLight],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentGoldenYellow, accentGoldenYellowLight],
  );

  static const LinearGradient natureGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [primaryForestGreen, secondaryLightGreen, accentGoldenYellow],
    stops: [0.0, 0.6, 1.0],
  );

  static const LinearGradient darkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [backgroundDark, surfaceDark],
  );

  // Light theme color scheme
  static ColorScheme get lightColorScheme => const ColorScheme(
        brightness: Brightness.light,
        primary: primaryForestGreen,
        onPrimary: Colors.white,
        primaryContainer: primaryForestGreenLight,
        onPrimaryContainer: Colors.white,
        secondary: secondaryLightGreen,
        onSecondary: Colors.white,
        secondaryContainer: secondaryLightGreenLight,
        onSecondaryContainer: textPrimaryLight,
        tertiary: accentGoldenYellow,
        onTertiary: textPrimaryLight,
        tertiaryContainer: accentGoldenYellowLight,
        onTertiaryContainer: textPrimaryLight,
        error: error,
        onError: Colors.white,
        errorContainer: errorLight,
        onErrorContainer: Colors.white,
        surface: backgroundWarmOffWhite,
        onSurface: textPrimaryLight,
        onSurfaceVariant: textSecondaryLight,
        outline: Color(0xFFBDBDBD),
        outlineVariant: Color(0xFFE0E0E0),
        shadow: Colors.black26,
        scrim: Colors.black54,
        inverseSurface: surfaceDark,
        onInverseSurface: textPrimaryDark,
        inversePrimary: secondaryLightGreen,
        surfaceContainerHighest: backgroundLight,
      );

  // Dark theme color scheme
  static ColorScheme get darkColorScheme => const ColorScheme(
        brightness: Brightness.dark,
        primary: secondaryLightGreen,
        onPrimary: Colors.black,
        primaryContainer: primaryForestGreen,
        onPrimaryContainer: Colors.white,
        secondary: secondaryLightGreenLight,
        onSecondary: Colors.black,
        secondaryContainer: secondaryLightGreenDark,
        onSecondaryContainer: Colors.white,
        tertiary: accentGoldenYellow,
        onTertiary: textPrimaryLight,
        tertiaryContainer: accentGoldenYellowDark,
        onTertiaryContainer: Colors.white,
        error: errorLight,
        onError: Colors.black,
        errorContainer: errorDark,
        onErrorContainer: Colors.white,
        surface: backgroundDark,
        onSurface: textPrimaryDark,
        onSurfaceVariant: textSecondaryDark,
        outline: Color(0xFF5A5A5A),
        outlineVariant: Color(0xFF3D3D3D),
        shadow: Colors.black54,
        scrim: Colors.black87,
        inverseSurface: backgroundLight,
        onInverseSurface: textPrimaryLight,
        inversePrimary: primaryForestGreen,
        surfaceContainerHighest: surfaceDark,
      );
}

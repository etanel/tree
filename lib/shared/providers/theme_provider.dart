import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for managing the app's theme mode
final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);

/// State notifier for theme mode management
class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    return ThemeMode.system;
  }

  /// Toggle between light and dark mode
  void toggleTheme() {
    if (state == ThemeMode.light) {
      state = ThemeMode.dark;
    } else {
      state = ThemeMode.light;
    }
  }

  /// Set theme to light mode
  void setLightMode() {
    state = ThemeMode.light;
  }

  /// Set theme to dark mode
  void setDarkMode() {
    state = ThemeMode.dark;
  }

  /// Set theme to system mode
  void setSystemMode() {
    state = ThemeMode.system;
  }

  /// Check if dark mode is currently active
  bool isDarkMode(BuildContext context) {
    if (state == ThemeMode.system) {
      return MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    }
    return state == ThemeMode.dark;
  }
}

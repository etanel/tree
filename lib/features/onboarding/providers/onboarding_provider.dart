import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Storage keys for preferences
class OnboardingStorageKeys {
  static const String isOnboardingComplete = 'onboarding_complete';
  static const String userName = 'user_name';
  static const String focusAreas = 'focus_areas';
}

/// Available focus areas for onboarding selection
enum FocusArea {
  finance('Finance', Icons.attach_money_rounded),
  productivity('Productivity', Icons.auto_graph_rounded),
  health('Health', Icons.fitness_center_rounded),
  learning('Learning', Icons.menu_book_rounded),
  projects('Projects', Icons.emoji_objects_rounded);

  const FocusArea(this.label, this.icon);
  final String label;
  final IconData icon;

  /// Convert to string for storage
  String toStorageString() => name;

  /// Create from storage string
  static FocusArea? fromStorageString(String value) {
    try {
      return FocusArea.values.firstWhere((e) => e.name == value);
    } catch (_) {
      return null;
    }
  }
}

/// State class for onboarding data
class OnboardingState {
  const OnboardingState({
    this.currentPage = 0,
    this.userName = '',
    this.selectedFocusAreas = const {},
    this.isCompleted = false,
    this.isLoading = true,
  });

  /// Current page index (0-3)
  final int currentPage;

  /// User's name entered on screen 4
  final String userName;

  /// Selected focus areas
  final Set<FocusArea> selectedFocusAreas;

  /// Whether onboarding is completed
  final bool isCompleted;

  /// Whether loading state from storage
  final bool isLoading;

  OnboardingState copyWith({
    int? currentPage,
    String? userName,
    Set<FocusArea>? selectedFocusAreas,
    bool? isCompleted,
    bool? isLoading,
  }) {
    return OnboardingState(
      currentPage: currentPage ?? this.currentPage,
      userName: userName ?? this.userName,
      selectedFocusAreas: selectedFocusAreas ?? this.selectedFocusAreas,
      isCompleted: isCompleted ?? this.isCompleted,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// Provider for SharedPreferences instance
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences not initialized');
});

/// Provider for checking if onboarding is complete
final isOnboardingCompleteProvider = FutureProvider<bool>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool(OnboardingStorageKeys.isOnboardingComplete) ?? false;
});

/// Provider for onboarding state management
final onboardingProvider =
    NotifierProvider<OnboardingNotifier, OnboardingState>(
  OnboardingNotifier.new,
);

/// Notifier for managing onboarding state with persistence
class OnboardingNotifier extends Notifier<OnboardingState> {
  @override
  OnboardingState build() {
    _loadFromStorage();
    return const OnboardingState();
  }

  /// Load saved state from shared preferences
  Future<void> _loadFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final isComplete =
          prefs.getBool(OnboardingStorageKeys.isOnboardingComplete) ?? false;
      final savedName = prefs.getString(OnboardingStorageKeys.userName) ?? '';
      final savedAreasJson = prefs.getString(OnboardingStorageKeys.focusAreas);

      Set<FocusArea> savedAreas = {};
      if (savedAreasJson != null) {
        final List<dynamic> areasList = jsonDecode(savedAreasJson);
        savedAreas = areasList
            .map((e) => FocusArea.fromStorageString(e.toString()))
            .whereType<FocusArea>()
            .toSet();
      }

      state = state.copyWith(
        isCompleted: isComplete,
        userName: savedName,
        selectedFocusAreas: savedAreas,
        isLoading: false,
      );
    } catch (e) {
      debugPrint('Error loading onboarding state: $e');
      state = state.copyWith(isLoading: false);
    }
  }

  /// Save state to shared preferences
  Future<void> _saveToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setBool(
        OnboardingStorageKeys.isOnboardingComplete,
        state.isCompleted,
      );
      await prefs.setString(
        OnboardingStorageKeys.userName,
        state.userName,
      );
      await prefs.setString(
        OnboardingStorageKeys.focusAreas,
        jsonEncode(
          state.selectedFocusAreas.map((e) => e.toStorageString()).toList(),
        ),
      );
    } catch (e) {
      debugPrint('Error saving onboarding state: $e');
    }
  }

  /// Update current page
  void setPage(int page) {
    state = state.copyWith(currentPage: page);
  }

  /// Go to next page
  void nextPage() {
    if (state.currentPage < 3) {
      state = state.copyWith(currentPage: state.currentPage + 1);
    }
  }

  /// Go to previous page
  void previousPage() {
    if (state.currentPage > 0) {
      state = state.copyWith(currentPage: state.currentPage - 1);
    }
  }

  /// Update user name
  void setUserName(String name) {
    state = state.copyWith(userName: name);
  }

  /// Toggle focus area selection
  void toggleFocusArea(FocusArea area) {
    final newAreas = Set<FocusArea>.from(state.selectedFocusAreas);
    if (newAreas.contains(area)) {
      newAreas.remove(area);
    } else {
      newAreas.add(area);
    }
    state = state.copyWith(selectedFocusAreas: newAreas);
  }

  /// Check if focus area is selected
  bool isFocusAreaSelected(FocusArea area) {
    return state.selectedFocusAreas.contains(area);
  }

  /// Skip onboarding and go to last page
  void skipOnboarding() {
    state = state.copyWith(currentPage: 3);
  }

  /// Save user data and complete onboarding
  Future<void> saveUserData() async {
    state = state.copyWith(isCompleted: true);
    await _saveToStorage();
  }

  /// Complete onboarding (alias for saveUserData)
  Future<void> completeOnboarding() async {
    await saveUserData();
  }

  /// Reset onboarding (for testing or re-onboarding)
  Future<void> reset() async {
    state = const OnboardingState(isLoading: false);
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(OnboardingStorageKeys.isOnboardingComplete);
    await prefs.remove(OnboardingStorageKeys.userName);
    await prefs.remove(OnboardingStorageKeys.focusAreas);
  }

  /// Check if user can proceed from screen 4
  bool get canComplete {
    return state.userName.trim().isNotEmpty &&
        state.selectedFocusAreas.isNotEmpty;
  }

  /// Get user's display name (or fallback)
  String get displayName {
    return state.userName.trim().isNotEmpty ? state.userName : 'Friend';
  }
}

/// Provider for getting the user's name
final userNameProvider = Provider<String>((ref) {
  final state = ref.watch(onboardingProvider);
  return state.userName.trim().isNotEmpty ? state.userName : 'Friend';
});

/// Provider for getting selected focus areas
final selectedFocusAreasProvider = Provider<Set<FocusArea>>((ref) {
  return ref.watch(onboardingProvider).selectedFocusAreas;
});

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_border_radius.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/custom_button.dart';
import '../providers/onboarding_provider.dart';
import 'screens/personalize_screen.dart';
import 'screens/track_everything_screen.dart';
import 'screens/visual_progress_screen.dart';
import 'screens/welcome_screen.dart';

/// Main onboarding page with PageView for smooth transitions
class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPage(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic,
    );
  }

  void _nextPage() {
    final currentPage = ref.read(onboardingProvider).currentPage;
    if (currentPage < 3) {
      _goToPage(currentPage + 1);
    }
  }

  void _skipToEnd() {
    _goToPage(3);
  }

  Future<void> _completeOnboarding() async {
    final notifier = ref.read(onboardingProvider.notifier);
    if (notifier.canComplete) {
      await notifier.saveUserData();
      if (mounted) {
        context.go('/');
      }
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please enter your name and select at least one focus area',
            style: AppTextStyles.bodyMedium(color: Colors.white),
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: AppBorderRadius.radiusSm,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final onboardingState = ref.watch(onboardingProvider);
    final currentPage = onboardingState.currentPage;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundWarmOffWhite,
      body: Stack(
        children: [
          // PageView with screens
          PageView(
            controller: _pageController,
            onPageChanged: (page) {
              ref.read(onboardingProvider.notifier).setPage(page);
            },
            children: const [
              WelcomeScreen(),
              TrackEverythingScreen(),
              VisualProgressScreen(),
              PersonalizeScreen(),
            ],
          ),

          // Skip button (screens 0-2)
          if (currentPage < 3)
            Positioned(
              top: MediaQuery.of(context).padding.top + 8,
              right: 16,
              child: TextButton(
                onPressed: _skipToEnd,
                style: TextButton.styleFrom(
                  foregroundColor: currentPage == 0
                      ? Colors.white
                      : (isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.primaryForestGreen),
                ),
                child: Text(
                  'Skip',
                  style: AppTextStyles.labelLarge(
                    color: currentPage == 0
                        ? Colors.white
                        : (isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.primaryForestGreen),
                  ),
                ),
              ),
            ),

          // Bottom section with page indicator and button
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.only(
                left: AppSpacing.lg,
                right: AppSpacing.lg,
                top: AppSpacing.lg,
                bottom: MediaQuery.of(context).padding.bottom + AppSpacing.lg,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    (isDark
                            ? AppColors.backgroundDark
                            : AppColors.backgroundWarmOffWhite)
                        .withValues(alpha: 0.0),
                    isDark
                        ? AppColors.backgroundDark
                        : AppColors.backgroundWarmOffWhite,
                  ],
                  stops: const [0.0, 0.3],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Page indicator dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(4, (index) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: currentPage == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: currentPage == index
                              ? (isDark
                                  ? AppColors.secondaryLightGreen
                                  : AppColors.primaryForestGreen)
                              : (isDark
                                  ? AppColors.neutral600
                                  : AppColors.neutral300),
                          borderRadius: AppBorderRadius.radiusFull,
                        ),
                      );
                    }),
                  ),

                  AppSpacing.verticalLg,

                  // Action button
                  CustomButton(
                    text: currentPage == 0
                        ? 'Get Started'
                        : currentPage == 3
                            ? "Let's Grow!"
                            : 'Next',
                    onPressed: currentPage == 3 ? _completeOnboarding : _nextPage,
                    variant: CustomButtonVariant.primary,
                    size: CustomButtonSize.large,
                    width: double.infinity,
                    icon: currentPage == 3 ? Icons.park : Icons.arrow_forward,
                    iconPosition: IconPosition.right,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

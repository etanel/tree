import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_border_radius.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../providers/onboarding_provider.dart';

/// Screen 4: Personalize screen with name input and focus area selection
class PersonalizeScreen extends ConsumerStatefulWidget {
  const PersonalizeScreen({super.key});

  @override
  ConsumerState<PersonalizeScreen> createState() => _PersonalizeScreenState();
}

class _PersonalizeScreenState extends ConsumerState<PersonalizeScreen>
    with SingleTickerProviderStateMixin {
  late TextEditingController _nameController;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late List<Animation<double>> _chipAnimations;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: ref.read(onboardingProvider).userName,
    );
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );

    _chipAnimations = List.generate(FocusArea.values.length, (index) {
      final start = 0.2 + (index * 0.1);
      final end = start + 0.3;
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            start.clamp(0.0, 1.0),
            end.clamp(0.0, 1.0),
            curve: Curves.easeOutBack,
          ),
        ),
      );
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final onboardingState = ref.watch(onboardingProvider);
    final onboardingNotifier = ref.read(onboardingProvider.notifier);

    return SafeArea(
      child: Padding(
        padding: AppSpacing.screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(flex: 1),
            AnimatedBuilder(
              animation: _fadeAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeAnimation.value,
                  child: child,
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tell us about you',
                    style: AppTextStyles.heading3(isDark: isDark),
                  ),
                  AppSpacing.verticalXs,
                  Text(
                    'This helps tailor your dashboard and insights.',
                    style: AppTextStyles.bodySmall(isDark: isDark),
                  ),
                  AppSpacing.verticalLg,
                  Text(
                    'Your name',
                    style: AppTextStyles.labelMedium(isDark: isDark),
                  ),
                  AppSpacing.verticalXs,
                  _CustomTextField(
                    controller: _nameController,
                    hintText: 'Enter your name',
                    prefixIcon: Icons.person_outline,
                    onChanged: onboardingNotifier.setUserName,
                  ),
                ],
              ),
            ),
            AppSpacing.verticalXl,
            AnimatedBuilder(
              animation: _fadeAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeAnimation.value,
                  child: child,
                );
              },
              child: Text(
                'Choose your focus areas',
                style: AppTextStyles.heading4(isDark: isDark),
              ),
            ),
            AppSpacing.verticalSm,
            Expanded(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: List.generate(FocusArea.values.length, (index) {
                    final area = FocusArea.values[index];
                    final isSelected =
                        onboardingState.selectedFocusAreas.contains(area);

                    return AnimatedBuilder(
                      animation: _chipAnimations[index],
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _chipAnimations[index].value,
                          child: child,
                        );
                      },
                      child: _FocusAreaChip(
                        area: area,
                        isSelected: isSelected,
                        onTap: () => onboardingNotifier.toggleFocusArea(area),
                      ),
                    );
                  }),
                ),
              ),
            ),
            AppSpacing.verticalSm,
            Text(
              'You can change this later in settings.',
              style: AppTextStyles.caption(isDark: isDark),
            ),
            const Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}

class _CustomTextField extends StatelessWidget {
  const _CustomTextField({
    required this.controller,
    required this.hintText,
    this.prefixIcon,
    this.onChanged,
  });

  final TextEditingController controller;
  final String hintText;
  final IconData? prefixIcon;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: AppBorderRadius.radiusMd,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        textInputAction: TextInputAction.done,
        textCapitalization: TextCapitalization.words,
        style: AppTextStyles.bodyLarge(isDark: isDark),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: AppTextStyles.bodyLarge(
            color: isDark ? AppColors.neutral500 : AppColors.neutral400,
          ),
          prefixIcon: prefixIcon != null
              ? Icon(
                  prefixIcon,
                  color: AppColors.primaryForestGreen,
                )
              : null,
          filled: true,
          fillColor: Colors.transparent,
          border: OutlineInputBorder(
            borderRadius: AppBorderRadius.radiusMd,
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: AppBorderRadius.radiusMd,
            borderSide: BorderSide(
              color: isDark ? AppColors.neutral700 : AppColors.neutral200,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppBorderRadius.radiusMd,
            borderSide: const BorderSide(
              color: AppColors.primaryForestGreen,
              width: 2,
            ),
          ),
          contentPadding: AppSpacing.inputPadding,
        ),
      ),
    );
  }
}

class _FocusAreaChip extends StatelessWidget {
  const _FocusAreaChip({
    required this.area,
    required this.isSelected,
    required this.onTap,
  });

  final FocusArea area;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark
                  ? AppColors.secondaryLightGreen
                  : AppColors.primaryForestGreen)
              : (isDark ? AppColors.surfaceDark : Colors.white),
          borderRadius: AppBorderRadius.radiusFull,
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : (isDark ? AppColors.neutral600 : AppColors.neutral300),
            width: 1.2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primaryForestGreen.withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              area.icon,
              size: 18,
              color: isSelected
                  ? Colors.white
                  : (isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight),
            ),
            AppSpacing.horizontalXs,
            Text(
              area.label,
              style: AppTextStyles.labelLarge(isDark: isDark).copyWith(
                color: isSelected
                    ? Colors.white
                    : (isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

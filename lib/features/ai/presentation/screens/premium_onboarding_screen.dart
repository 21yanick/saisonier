import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:saisonier/core/theme/app_theme.dart';
import 'package:saisonier/features/ai/presentation/controllers/premium_onboarding_controller.dart';
import 'package:saisonier/features/ai/presentation/widgets/onboarding_steps/welcome_step.dart';
import 'package:saisonier/features/ai/presentation/widgets/onboarding_steps/cuisine_step.dart';
import 'package:saisonier/features/ai/presentation/widgets/onboarding_steps/lifestyle_step.dart';
import 'package:saisonier/features/ai/presentation/widgets/onboarding_steps/goals_step.dart';
import 'package:saisonier/features/ai/presentation/widgets/onboarding_steps/complete_step.dart';

class PremiumOnboardingScreen extends ConsumerStatefulWidget {
  const PremiumOnboardingScreen({super.key});

  @override
  ConsumerState<PremiumOnboardingScreen> createState() =>
      _PremiumOnboardingScreenState();
}

class _PremiumOnboardingScreenState
    extends ConsumerState<PremiumOnboardingScreen> {
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
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onNext() {
    final controller = ref.read(premiumOnboardingControllerProvider.notifier);
    controller.nextStep();
    // Nach nextStep() ist currentStep bereits erhöht - direkt verwenden
    final newStep = ref.read(premiumOnboardingControllerProvider).currentStep;
    _goToPage(newStep);
  }

  void _onPrevious() {
    final controller = ref.read(premiumOnboardingControllerProvider.notifier);
    controller.previousStep();
    // Nach previousStep() ist currentStep bereits verringert - direkt verwenden
    final newStep = ref.read(premiumOnboardingControllerProvider).currentStep;
    _goToPage(newStep);
  }

  Future<void> _onComplete() async {
    final controller = ref.read(premiumOnboardingControllerProvider.notifier);
    final success = await controller.completeOnboarding();

    if (success && mounted) {
      context.go('/');
    }
  }

  Future<void> _onSkip() async {
    final controller = ref.read(premiumOnboardingControllerProvider.notifier);
    final success = await controller.skipOnboarding();

    if (success && mounted) {
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(premiumOnboardingControllerProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Progress indicator
            _buildProgressIndicator(state.currentStep),

            // Page content
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  WelcomeStep(
                    onGetStarted: _onNext,
                    onSkip: _onSkip,
                  ),
                  CuisineStep(
                    onNext: _onNext,
                    onBack: _onPrevious,
                  ),
                  LifestyleStep(
                    onNext: _onNext,
                    onBack: _onPrevious,
                  ),
                  GoalsStep(
                    onNext: _onNext,
                    onBack: _onPrevious,
                    onSkip: _onNext, // Skip goes to next (complete) step
                  ),
                  CompleteStep(
                    onComplete: _onComplete,
                    onBack: _onPrevious,
                    isLoading: state.isLoading,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(int currentStep) {
    // Don't show progress on welcome screen (step 0)
    if (currentStep == 0) return const SizedBox.shrink();

    // 4 Segmente für Steps 1-4 (Cuisine, Lifestyle, Goals, Complete)
    // Segment i ist aktiv wenn currentStep > i
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: List.generate(4, (index) {
          // Segment 0 aktiv bei Step >= 1, Segment 1 bei >= 2, etc.
          final isActive = currentStep > index;
          return Expanded(
            child: Container(
              height: 4,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: isActive ? AppColors.primaryGreen : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }
}

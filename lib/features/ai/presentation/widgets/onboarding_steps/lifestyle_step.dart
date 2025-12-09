import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saisonier/core/theme/app_theme.dart';
import 'package:saisonier/features/ai/domain/enums/ai_enums.dart';
import 'package:saisonier/features/ai/presentation/controllers/premium_onboarding_controller.dart';

class LifestyleStep extends ConsumerWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const LifestyleStep({
    super.key,
    required this.onNext,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(premiumOnboardingControllerProvider);
    final controller = ref.read(premiumOnboardingControllerProvider.notifier);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back button
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),

          const SizedBox(height: 16),

          // Title
          Text(
            'Wie kochst du am liebsten?',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),

          const SizedBox(height: 32),

          // Budget level
          Text(
            'Budget',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 12),
          ...BudgetLevel.values.map((level) {
            final isSelected = state.budgetLevel == level;
            return _RadioOption(
              label: level.label,
              description: _getBudgetDescription(level),
              isSelected: isSelected,
              onTap: () => controller.setBudgetLevel(level),
            );
          }),

          const SizedBox(height: 32),

          // Meal prep style
          Text(
            'Kochstil',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 12),
          ...MealPrepStyle.values.map((style) {
            final isSelected = state.mealPrepStyle == style;
            return _RadioOption(
              label: style.label,
              description: _getMealPrepDescription(style),
              isSelected: isSelected,
              onTap: () => controller.setMealPrepStyle(style),
            );
          }),

          const SizedBox(height: 32),

          // Cooking days per week
          Text(
            'Wie oft pro Woche?',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: state.cookingDaysPerWeek > 1
                    ? () => controller
                        .setCookingDaysPerWeek(state.cookingDaysPerWeek - 1)
                    : null,
                icon: const Icon(Icons.remove_circle_outline),
                iconSize: 32,
                color: AppColors.primaryGreen,
              ),
              const SizedBox(width: 16),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${state.cookingDaysPerWeek} Tage',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryGreen,
                      ),
                ),
              ),
              const SizedBox(width: 16),
              IconButton(
                onPressed: state.cookingDaysPerWeek < 7
                    ? () => controller
                        .setCookingDaysPerWeek(state.cookingDaysPerWeek + 1)
                    : null,
                icon: const Icon(Icons.add_circle_outline),
                iconSize: 32,
                color: AppColors.primaryGreen,
              ),
            ],
          ),

          const SizedBox(height: 48),

          // Next button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Weiter',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getBudgetDescription(BudgetLevel level) {
    switch (level) {
      case BudgetLevel.budget:
        return 'Einfache Zutaten, günstige Rezepte';
      case BudgetLevel.normal:
        return 'Gute Zutaten, faire Preise';
      case BudgetLevel.premium:
        return 'Hochwertige Zutaten, Spezialitäten ok';
    }
  }

  String _getMealPrepDescription(MealPrepStyle style) {
    switch (style) {
      case MealPrepStyle.daily:
        return 'Jeden Tag frisch kochen';
      case MealPrepStyle.mealPrep:
        return 'Am Wochenende vorkochen';
      case MealPrepStyle.mixed:
        return 'Mix aus beidem';
    }
  }
}

class _RadioOption extends StatelessWidget {
  final String label;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  const _RadioOption({
    required this.label,
    required this.description,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryGreen.withValues(alpha: 0.1)
              : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primaryGreen : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? AppColors.primaryGreen : Colors.grey.shade400,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? AppColors.primaryGreen
                          : Colors.grey.shade800,
                    ),
                  ),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

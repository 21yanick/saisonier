import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saisonier/features/auth/presentation/controllers/auth_controller.dart';
import 'package:saisonier/features/ai/data/repositories/ai_profile_repository.dart';
import 'package:saisonier/features/ai/domain/enums/ai_enums.dart';
import 'package:saisonier/features/ai/domain/models/ai_profile.dart';
import 'package:saisonier/features/ai/domain/models/ai_learning_context.dart';
import 'package:saisonier/features/ai/presentation/controllers/ai_profile_controller.dart';

part 'premium_onboarding_controller.g.dart';

/// State for the premium onboarding wizard.
class OnboardingState {
  final int currentStep;
  final bool isLoading;

  // Step 2: Küche & Geschmack
  final List<Cuisine> cuisinePreferences;
  final List<FlavorProfile> flavorProfile;
  final List<String> likes;
  final List<Protein> proteinPreferences;

  // Step 3: Budget & Stil
  final BudgetLevel budgetLevel;
  final MealPrepStyle mealPrepStyle;
  final int cookingDaysPerWeek;

  // Step 4: Ziele (optional)
  final List<HealthGoal> healthGoals;
  final NutritionFocus nutritionFocus;
  final List<KitchenEquipment> equipment;

  const OnboardingState({
    this.currentStep = 0,
    this.isLoading = false,
    this.cuisinePreferences = const [],
    this.flavorProfile = const [],
    this.likes = const [],
    this.proteinPreferences = const [],
    this.budgetLevel = BudgetLevel.normal,
    this.mealPrepStyle = MealPrepStyle.mixed,
    this.cookingDaysPerWeek = 4,
    this.healthGoals = const [],
    this.nutritionFocus = NutritionFocus.balanced,
    this.equipment = const [],
  });

  OnboardingState copyWith({
    int? currentStep,
    bool? isLoading,
    List<Cuisine>? cuisinePreferences,
    List<FlavorProfile>? flavorProfile,
    List<String>? likes,
    List<Protein>? proteinPreferences,
    BudgetLevel? budgetLevel,
    MealPrepStyle? mealPrepStyle,
    int? cookingDaysPerWeek,
    List<HealthGoal>? healthGoals,
    NutritionFocus? nutritionFocus,
    List<KitchenEquipment>? equipment,
  }) {
    return OnboardingState(
      currentStep: currentStep ?? this.currentStep,
      isLoading: isLoading ?? this.isLoading,
      cuisinePreferences: cuisinePreferences ?? this.cuisinePreferences,
      flavorProfile: flavorProfile ?? this.flavorProfile,
      likes: likes ?? this.likes,
      proteinPreferences: proteinPreferences ?? this.proteinPreferences,
      budgetLevel: budgetLevel ?? this.budgetLevel,
      mealPrepStyle: mealPrepStyle ?? this.mealPrepStyle,
      cookingDaysPerWeek: cookingDaysPerWeek ?? this.cookingDaysPerWeek,
      healthGoals: healthGoals ?? this.healthGoals,
      nutritionFocus: nutritionFocus ?? this.nutritionFocus,
      equipment: equipment ?? this.equipment,
    );
  }
}

@riverpod
class PremiumOnboardingController extends _$PremiumOnboardingController {
  @override
  OnboardingState build() {
    // Load existing AI profile data if available (for re-editing)
    final existingProfile = ref.read(aIProfileControllerProvider).valueOrNull;

    if (existingProfile != null) {
      return OnboardingState(
        cuisinePreferences: existingProfile.cuisinePreferences,
        flavorProfile: existingProfile.flavorProfile,
        likes: existingProfile.likes,
        proteinPreferences: existingProfile.proteinPreferences,
        budgetLevel: existingProfile.budgetLevel,
        mealPrepStyle: existingProfile.mealPrepStyle,
        cookingDaysPerWeek: existingProfile.cookingDaysPerWeek,
        healthGoals: existingProfile.healthGoals,
        nutritionFocus: existingProfile.nutritionFocus,
        equipment: existingProfile.equipment,
      );
    }

    return const OnboardingState();
  }

  void nextStep() {
    if (state.currentStep < 4) {
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  void previousStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  void goToStep(int step) {
    state = state.copyWith(currentStep: step);
  }

  // Step 2: Küche & Geschmack
  void toggleCuisine(Cuisine cuisine) {
    final current = List<Cuisine>.from(state.cuisinePreferences);
    if (current.contains(cuisine)) {
      current.remove(cuisine);
    } else {
      current.add(cuisine);
    }
    state = state.copyWith(cuisinePreferences: current);
  }

  void toggleFlavor(FlavorProfile flavor) {
    final current = List<FlavorProfile>.from(state.flavorProfile);
    if (current.contains(flavor)) {
      current.remove(flavor);
    } else {
      current.add(flavor);
    }
    state = state.copyWith(flavorProfile: current);
  }

  void setLikes(List<String> likes) {
    state = state.copyWith(likes: likes);
  }

  void toggleProtein(Protein protein) {
    final current = List<Protein>.from(state.proteinPreferences);
    if (current.contains(protein)) {
      current.remove(protein);
    } else {
      current.add(protein);
    }
    state = state.copyWith(proteinPreferences: current);
  }

  // Step 3: Budget & Stil
  void setBudgetLevel(BudgetLevel level) {
    state = state.copyWith(budgetLevel: level);
  }

  void setMealPrepStyle(MealPrepStyle style) {
    state = state.copyWith(mealPrepStyle: style);
  }

  void setCookingDaysPerWeek(int days) {
    state = state.copyWith(cookingDaysPerWeek: days);
  }

  // Step 4: Ziele
  void toggleHealthGoal(HealthGoal goal) {
    final current = List<HealthGoal>.from(state.healthGoals);
    if (current.contains(goal)) {
      current.remove(goal);
    } else {
      current.add(goal);
    }
    state = state.copyWith(healthGoals: current);
  }

  void setNutritionFocus(NutritionFocus focus) {
    state = state.copyWith(nutritionFocus: focus);
  }

  void toggleEquipment(KitchenEquipment item) {
    final current = List<KitchenEquipment>.from(state.equipment);
    if (current.contains(item)) {
      current.remove(item);
    } else {
      current.add(item);
    }
    state = state.copyWith(equipment: current);
  }

  /// Complete the onboarding and save the AI profile.
  Future<bool> completeOnboarding() async {
    final user = ref.read(currentUserProvider).value;
    if (user == null) return false;

    state = state.copyWith(isLoading: true);

    try {
      final profile = AIProfile(
        id: '', // Will be assigned by PocketBase
        userId: user.id,
        cuisinePreferences: state.cuisinePreferences,
        flavorProfile: state.flavorProfile,
        likes: state.likes,
        proteinPreferences: state.proteinPreferences,
        budgetLevel: state.budgetLevel,
        mealPrepStyle: state.mealPrepStyle,
        cookingDaysPerWeek: state.cookingDaysPerWeek,
        healthGoals: state.healthGoals,
        nutritionFocus: state.nutritionFocus,
        equipment: state.equipment,
        learningContext: const AILearningContext(),
        onboardingCompleted: true,
      );

      await ref
          .read(aiProfileRepositoryProvider)
          .createOrUpdateProfile(user.id, profile);

      // Invalidate the AI profile controller to reload fresh data
      ref.invalidate(aIProfileControllerProvider);

      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      debugPrint('Error completing AI onboarding: $e');
      state = state.copyWith(isLoading: false);
      return false;
    }
  }

  /// Skip onboarding (creates empty profile with onboarding_completed = false).
  Future<bool> skipOnboarding() async {
    final user = ref.read(currentUserProvider).value;
    if (user == null) return false;

    state = state.copyWith(isLoading: true);

    try {
      final profile = AIProfile(
        id: '',
        userId: user.id,
        onboardingCompleted: false,
      );

      await ref
          .read(aiProfileRepositoryProvider)
          .createOrUpdateProfile(user.id, profile);

      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false);
      return false;
    }
  }
}

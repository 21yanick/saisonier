import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saisonier/core/theme/app_theme.dart';
import 'package:saisonier/features/ai/presentation/controllers/premium_onboarding_controller.dart';
import 'package:saisonier/features/profile/presentation/state/user_profile_controller.dart';

class CompleteStep extends ConsumerWidget {
  final VoidCallback onComplete;
  final VoidCallback onBack;
  final bool isLoading;

  const CompleteStep({
    super.key,
    required this.onComplete,
    required this.onBack,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aiState = ref.watch(premiumOnboardingControllerProvider);
    final userProfile = ref.watch(userProfileControllerProvider).valueOrNull;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Back button
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),

          const SizedBox(height: 32),

          // Chef emoji
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                '🧑‍🍳',
                style: TextStyle(fontSize: 56),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Title
          Text(
            'Perfekt! Ich kenne dich jetzt:',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 32),

          // Summary card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // === HAUSHALT ===
                if (userProfile != null) ...[
                  const _SectionHeader(title: 'Haushalt'),
                  const SizedBox(height: 8),
                  _SummaryRow(
                    icon: '👥',
                    label:
                        '${userProfile.householdSize} Person${userProfile.householdSize > 1 ? 'en' : ''}${userProfile.childrenCount > 0 ? ', ${userProfile.childrenCount} Kind${userProfile.childrenCount > 1 ? 'er' : ''}' : ''}',
                  ),
                  if (userProfile.diet.name != 'omnivore')
                    _SummaryRow(
                      icon: '🥬',
                      label: userProfile.diet.label,
                    ),
                  if (userProfile.allergens.isNotEmpty)
                    _SummaryRow(
                      icon: '🚫',
                      label:
                          'Keine ${userProfile.allergens.map((a) => a.label).join(", ")}',
                    ),
                  if (userProfile.dislikes.isNotEmpty)
                    _SummaryRow(
                      icon: '👎',
                      label: 'Mag nicht: ${userProfile.dislikes.join(", ")}',
                    ),
                  const _Divider(),
                ],

                // === GESCHMACK ===
                const _SectionHeader(title: 'Geschmack'),
                const SizedBox(height: 8),
                if (aiState.cuisinePreferences.isNotEmpty)
                  _SummaryRow(
                    icon: '🍽️',
                    label: aiState.cuisinePreferences
                        .map((c) => c.label)
                        .join(', '),
                  ),
                if (aiState.flavorProfile.isNotEmpty)
                  _SummaryRow(
                    icon: '😋',
                    label:
                        aiState.flavorProfile.map((f) => f.label).join(', '),
                  ),
                if (aiState.proteinPreferences.isNotEmpty)
                  _SummaryRow(
                    icon: '🥩',
                    label: aiState.proteinPreferences
                        .map((p) => p.label)
                        .join(', '),
                  ),
                if (aiState.likes.isNotEmpty)
                  _SummaryRow(
                    icon: '❤️',
                    label: 'Mag besonders: ${aiState.likes.join(", ")}',
                  ),
                const _Divider(),

                // === LIFESTYLE ===
                const _SectionHeader(title: 'Lifestyle'),
                const SizedBox(height: 8),
                _SummaryRow(
                  icon: '💰',
                  label: 'Budget: ${aiState.budgetLevel.label}',
                ),
                _SummaryRow(
                  icon: '📅',
                  label: '${aiState.cookingDaysPerWeek}x pro Woche kochen',
                ),
                _SummaryRow(
                  icon: '🍱',
                  label: aiState.mealPrepStyle.label,
                ),

                // === ZIELE ===
                if (aiState.healthGoals.isNotEmpty ||
                    aiState.nutritionFocus.name != 'balanced') ...[
                  const _Divider(),
                  const _SectionHeader(title: 'Ziele'),
                  const SizedBox(height: 8),
                  if (aiState.healthGoals.isNotEmpty)
                    _SummaryRow(
                      icon: '🎯',
                      label: aiState.healthGoals
                          .where((g) => g.name != 'none')
                          .map((g) => g.label)
                          .join(', '),
                    ),
                  _SummaryRow(
                    icon: '🥗',
                    label: 'Fokus: ${aiState.nutritionFocus.label}',
                  ),
                ],

                // === KÜCHE ===
                if (aiState.equipment.isNotEmpty) ...[
                  const _Divider(),
                  const _SectionHeader(title: 'Küche'),
                  const SizedBox(height: 8),
                  _SummaryRow(
                    icon: '🔧',
                    label:
                        aiState.equipment.map((e) => e.label).join(', '),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Ready message
          Text(
            'Ich bin bereit!',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryGreen,
                ),
          ),

          const SizedBox(height: 48),

          // Complete button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isLoading ? null : onComplete,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'Rezept erstellen',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title.toUpperCase(),
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: Colors.grey.shade500,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Divider(
        color: Colors.grey.shade200,
        height: 1,
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String icon;
  final String label;

  const _SummaryRow({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            icon,
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

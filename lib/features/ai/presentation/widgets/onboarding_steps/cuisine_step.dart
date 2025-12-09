import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saisonier/core/theme/app_theme.dart';
import 'package:saisonier/features/ai/domain/enums/ai_enums.dart';
import 'package:saisonier/features/ai/presentation/controllers/premium_onboarding_controller.dart';

class CuisineStep extends ConsumerStatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const CuisineStep({
    super.key,
    required this.onNext,
    required this.onBack,
  });

  @override
  ConsumerState<CuisineStep> createState() => _CuisineStepState();
}

class _CuisineStepState extends ConsumerState<CuisineStep> {
  final _likesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialisiere mit existierendem State (falls User zurücknavigiert)
    final existingLikes =
        ref.read(premiumOnboardingControllerProvider).likes;
    if (existingLikes.isNotEmpty) {
      _likesController.text = existingLikes.join(', ');
    }
  }

  @override
  void dispose() {
    _likesController.dispose();
    super.dispose();
  }

  void _updateLikes(String text) {
    final likes = text
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    ref.read(premiumOnboardingControllerProvider.notifier).setLikes(likes);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(premiumOnboardingControllerProvider);
    final controller = ref.read(premiumOnboardingControllerProvider.notifier);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back button
          IconButton(
            onPressed: widget.onBack,
            icon: const Icon(Icons.arrow_back),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),

          const SizedBox(height: 16),

          // Title
          Text(
            'Was isst du am liebsten?',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),

          const SizedBox(height: 8),

          Text(
            'Mehrfachauswahl möglich',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade600,
                ),
          ),

          const SizedBox(height: 24),

          // Cuisine preferences
          Text(
            'Küchen',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: Cuisine.values.map((cuisine) {
              final isSelected = state.cuisinePreferences.contains(cuisine);
              return _SelectableChip(
                label: cuisine.label,
                isSelected: isSelected,
                onTap: () => controller.toggleCuisine(cuisine),
              );
            }).toList(),
          ),

          const SizedBox(height: 32),

          // Flavor profile
          Text(
            'Geschmacksprofil',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: FlavorProfile.values.map((flavor) {
              final isSelected = state.flavorProfile.contains(flavor);
              return _SelectableChip(
                label: flavor.label,
                isSelected: isSelected,
                onTap: () => controller.toggleFlavor(flavor),
              );
            }).toList(),
          ),

          const SizedBox(height: 32),

          // Protein preferences
          Text(
            'Proteinquellen',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: Protein.values.map((protein) {
              final isSelected = state.proteinPreferences.contains(protein);
              return _SelectableChip(
                label: protein.label,
                isSelected: isSelected,
                onTap: () => controller.toggleProtein(protein),
              );
            }).toList(),
          ),

          const SizedBox(height: 32),

          // Likes (free text)
          Text(
            'Was magst du besonders?',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Optional - z.B. Pasta, Risotto, Currys',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade600,
                ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _likesController,
            onChanged: _updateLikes,
            decoration: InputDecoration(
              hintText: 'Kommagetrennt eingeben...',
              hintStyle: TextStyle(color: Colors.grey.shade400),
              filled: true,
              fillColor: Colors.grey.shade50,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primaryGreen),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),

          const SizedBox(height: 48),

          // Next button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: widget.onNext,
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
}

class _SelectableChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SelectableChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryGreen : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primaryGreen : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey.shade700,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

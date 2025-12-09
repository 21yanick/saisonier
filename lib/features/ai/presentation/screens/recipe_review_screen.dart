import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:saisonier/core/theme/app_theme.dart';
import 'package:saisonier/features/ai/domain/models/generated_recipe.dart';
import 'package:saisonier/features/ai/presentation/controllers/ai_profile_controller.dart';
import 'package:saisonier/features/auth/presentation/controllers/auth_controller.dart';
import 'package:saisonier/features/seasonality/data/repositories/recipe_repository.dart';
import 'package:saisonier/features/seasonality/data/repositories/vegetable_repository.dart';

/// Screen to review and save/reject an AI-generated recipe.
class RecipeReviewScreen extends ConsumerStatefulWidget {
  final GeneratedRecipe generatedRecipe;
  final VoidCallback? onRegenerate;

  const RecipeReviewScreen({
    super.key,
    required this.generatedRecipe,
    this.onRegenerate,
  });

  @override
  ConsumerState<RecipeReviewScreen> createState() => _RecipeReviewScreenState();
}

class _RecipeReviewScreenState extends ConsumerState<RecipeReviewScreen> {
  late TextEditingController _titleController;
  late int _servings;
  late int _originalServings;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.generatedRecipe.title);
    _servings = widget.generatedRecipe.servings;
    _originalServings = widget.generatedRecipe.servings;
  }

  /// Scale an ingredient amount based on servings ratio
  String _scaleAmount(String originalAmount) {
    if (_servings == _originalServings) return originalAmount;

    // Try to parse as number
    final numericAmount = double.tryParse(originalAmount.replaceAll(',', '.'));
    if (numericAmount == null) return originalAmount;

    final scaled = numericAmount * _servings / _originalServings;

    // Format nicely
    if (scaled == scaled.roundToDouble()) {
      return scaled.round().toString();
    }
    return scaled.toStringAsFixed(1).replaceAll('.0', '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _saveRecipe() async {
    final user = ref.read(currentUserProvider).value;
    if (user == null) return;

    setState(() {
      _isSaving = true;
    });

    try {
      // Convert GeneratedIngredient to Map<String, dynamic> with scaled amounts
      final ingredientMaps = widget.generatedRecipe.ingredients
          .map((i) => {
                'item': i.item,
                'amount': _scaleAmount(i.amount),
                'unit': i.unit,
                if (i.note != null) 'note': i.note,
              })
          .toList();

      // Map mainVegetable name to vegetableId for linking
      String? vegetableId;
      if (widget.generatedRecipe.mainVegetable != null) {
        vegetableId = await ref
            .read(vegetableRepositoryProvider)
            .findIdByName(widget.generatedRecipe.mainVegetable!);
      }

      await ref.read(recipeRepositoryProvider).createUserRecipe(
            userId: user.id,
            title: _titleController.text,
            description: widget.generatedRecipe.description,
            prepTimeMin: widget.generatedRecipe.prepTimeMin,
            cookTimeMin: widget.generatedRecipe.cookTimeMin,
            servings: _servings,
            difficulty: widget.generatedRecipe.difficulty,
            category: widget.generatedRecipe.category,
            ingredients: ingredientMaps,
            steps: widget.generatedRecipe.steps,
            tags: widget.generatedRecipe.tags,
            isVegetarian: widget.generatedRecipe.isVegetarian,
            isVegan: widget.generatedRecipe.isVegan,
            vegetableId: vegetableId,
          );

      // Update learning context
      if (widget.generatedRecipe.mainVegetable != null) {
        await ref
            .read(aIProfileControllerProvider.notifier)
            .addAcceptedSuggestion(widget.generatedRecipe.mainVegetable!);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Rezept gespeichert!'),
            backgroundColor: AppColors.primaryGreen,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fehler: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Future<void> _rejectAndRegenerate() async {
    // Track rejection for learning
    if (widget.generatedRecipe.mainVegetable != null) {
      await ref
          .read(aIProfileControllerProvider.notifier)
          .addRejectedSuggestion(widget.generatedRecipe.mainVegetable!);
    }

    if (mounted) {
      Navigator.pop(context);
      widget.onRegenerate?.call();
    }
  }

  void _discard() {
    // Track rejection for learning
    if (widget.generatedRecipe.mainVegetable != null) {
      ref
          .read(aIProfileControllerProvider.notifier)
          .addRejectedSuggestion(widget.generatedRecipe.mainVegetable!);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final recipe = widget.generatedRecipe;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rezept Review'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: _discard,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // AI badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.auto_awesome,
                    size: 16,
                    color: AppColors.primaryGreen,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'AI-generiert',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.primaryGreen,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Editable title (multi-line)
            TextField(
              controller: _titleController,
              maxLines: null,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Rezeptname',
              ),
            ),

            const SizedBox(height: 8),

            // Description
            Text(
              recipe.description,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey.shade600,
                  ),
            ),

            const SizedBox(height: 16),

            // Meta info (Zeit aufgeteilt wie in RecipeDetailScreen)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                // Vorbereitungszeit
                if (recipe.prepTimeMin > 0)
                  _MetaChip(
                    icon: Icons.content_cut,
                    label: 'Vorb: ${recipe.prepTimeMin} Min',
                  ),

                // Kochzeit
                if (recipe.cookTimeMin > 0)
                  _MetaChip(
                    icon: Icons.local_fire_department_outlined,
                    label: 'Kochen: ${recipe.cookTimeMin} Min',
                  ),

                // Gesamtzeit (nur wenn beide > 0)
                if (recipe.prepTimeMin > 0 && recipe.cookTimeMin > 0)
                  _MetaChip(
                    icon: Icons.timer_outlined,
                    label: 'Gesamt: ${recipe.prepTimeMin + recipe.cookTimeMin} Min',
                  ),

                // Fallback: Nur Gesamtzeit wenn nur eines > 0
                if ((recipe.prepTimeMin == 0) != (recipe.cookTimeMin == 0))
                  _MetaChip(
                    icon: Icons.timer_outlined,
                    label: '${recipe.prepTimeMin + recipe.cookTimeMin} Min',
                  ),

                // Schwierigkeit
                _MetaChip(
                  icon: Icons.signal_cellular_alt,
                  label: _getDifficultyLabel(recipe.difficulty),
                ),

                // Vegetarisch/Vegan
                if (recipe.isVegan)
                  const _MetaChip(icon: Icons.eco, label: 'Vegan')
                else if (recipe.isVegetarian)
                  const _MetaChip(icon: Icons.eco, label: 'Vegi'),
              ],
            ),

            const SizedBox(height: 16),

            // Servings editor
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Portionen',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: _servings > 1
                            ? () => setState(() => _servings--)
                            : null,
                        icon: const Icon(Icons.remove_circle_outline),
                        color: AppColors.primaryGreen,
                      ),
                      Text(
                        '$_servings',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      IconButton(
                        onPressed: () => setState(() => _servings++),
                        icon: const Icon(Icons.add_circle_outline),
                        color: AppColors.primaryGreen,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Ingredients
            Text(
              'Zutaten',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            ...recipe.ingredients.map((ing) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '•',
                        style: TextStyle(
                          color: AppColors.primaryGreen,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${_scaleAmount(ing.amount)} ${ing.unit} ${ing.item}${ing.note != null ? ' (${ing.note})' : ''}',
                        ),
                      ),
                    ],
                  ),
                )),

            const SizedBox(height: 24),

            // Steps
            Text(
              'Zubereitung',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            ...recipe.steps.asMap().entries.map((entry) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                          color: AppColors.primaryGreen,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${entry.key + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(entry.value),
                      ),
                    ],
                  ),
                )),

            // Tip
            if (recipe.tip != null) ...[
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber.shade200),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('💡', style: TextStyle(fontSize: 20)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        recipe.tip!,
                        style: TextStyle(color: Colors.amber.shade900),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 100), // Space for bottom buttons
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Discard button
              OutlinedButton(
                onPressed: _discard,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
                child: const Text('Verwerfen'),
              ),

              const SizedBox(width: 8),

              // Regenerate button
              if (widget.onRegenerate != null)
                OutlinedButton(
                  onPressed: _rejectAndRegenerate,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: const BorderSide(color: AppColors.primaryGreen),
                    foregroundColor: AppColors.primaryGreen,
                  ),
                  child: const Text('Nochmal'),
                ),

              const Spacer(),

              // Save button
              ElevatedButton(
                onPressed: _isSaving ? null : _saveRecipe,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Speichern',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getDifficultyLabel(String difficulty) {
    switch (difficulty) {
      case 'easy':
        return 'Einfach';
      case 'medium':
        return 'Mittel';
      case 'hard':
        return 'Anspruchsvoll';
      default:
        return difficulty;
    }
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MetaChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.grey.shade700),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}

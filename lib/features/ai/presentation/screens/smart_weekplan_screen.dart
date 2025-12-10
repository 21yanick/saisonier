import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:saisonier/core/config/app_config.dart';
import 'package:saisonier/core/theme/app_theme.dart';
import 'package:saisonier/features/ai/domain/models/smart_weekplan_response.dart';
import 'package:saisonier/features/ai/presentation/widgets/meal_refine_sheet.dart';
import 'package:saisonier/features/weekplan/data/repositories/weekplan_repository.dart';
import 'package:saisonier/features/weekplan/domain/enums.dart';
import 'package:saisonier/core/network/pocketbase_provider.dart';
import 'package:saisonier/features/profile/presentation/state/user_profile_controller.dart';

/// Screen showing the AI-generated smart weekplan for review.
class SmartWeekplanScreen extends ConsumerStatefulWidget {
  final SmartWeekplanResponse response;
  final VoidCallback onRegenerate;

  const SmartWeekplanScreen({
    super.key,
    required this.response,
    required this.onRegenerate,
  });

  @override
  ConsumerState<SmartWeekplanScreen> createState() =>
      _SmartWeekplanScreenState();
}

class _SmartWeekplanScreenState extends ConsumerState<SmartWeekplanScreen> {
  late SmartWeekplanResponse _response;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _response = widget.response;
  }

  void _updateMeal(String date, String slot, PlannedMealSlot newMeal, Map<String, dynamic>? recipeData) {
    setState(() {
      // Update the weekplan
      final updatedWeekplan = _response.weekplan.map((day) {
        if (day.date == date) {
          final updatedMeals = Map<String, PlannedMealSlot>.from(day.meals);
          updatedMeals[slot] = newMeal;
          return day.copyWith(meals: updatedMeals);
        }
        return day;
      }).toList();

      // Also add the new recipe to the recipes map if provided
      final updatedRecipes = Map<String, dynamic>.from(_response.recipes);
      if (newMeal.recipeId != null && recipeData != null) {
        updatedRecipes[newMeal.recipeId!] = recipeData;
      }

      _response = _response.copyWith(
        weekplan: updatedWeekplan,
        recipes: updatedRecipes,
      );
    });
  }

  Future<void> _savePlan() async {
    setState(() => _isSaving = true);

    try {
      final pb = ref.read(pocketbaseProvider);
      final userId = pb.authStore.model?.id as String?;
      if (userId == null) throw Exception('Not logged in');

      final repo = ref.read(weekplanRepositoryProvider);

      // Get household size for servings (default 2 if not set)
      final userProfile = ref.read(userProfileControllerProvider).valueOrNull;
      final servings = userProfile?.householdSize ?? 2;

      for (final day in _response.weekplan) {
        final date = DateTime.parse(day.date);

        for (final entry in day.meals.entries) {
          final slot = MealSlot.values.firstWhere(
            (s) => s.name == entry.key,
            orElse: () => MealSlot.dinner,
          );
          final meal = entry.value;

          if (meal.recipeId != null) {
            await repo.addRecipeToSlot(
              userId: userId,
              date: date,
              slot: slot,
              recipeId: meal.recipeId!,
              servings: servings,
            );
          }
        }
      }

      if (mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Wochenplan gespeichert!'),
            backgroundColor: AppTheme.primaryGreen,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fehler: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _showRefineSheet(PlannedDay day, String slot, PlannedMealSlot meal) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => MealRefineSheet(
        currentPlan: _response.weekplan,
        day: day.date,
        slot: slot,
        currentMeal: meal,
        dayContext: day.dayContext,
        recipes: _response.recipes,
        onMealSelected: (newMeal, recipeData) {
          _updateMeal(day.date, slot, newMeal, recipeData);
          Navigator.of(context).pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.cream,
      appBar: AppBar(
        backgroundColor: AppTheme.cream,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Dein Wochenplan'),
        actions: [
          TextButton.icon(
            onPressed: widget.onRegenerate,
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('Neu'),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                // Context analysis card
                if (_response.contextAnalysis.displaySummary != null)
                  _buildContextCard(),
                const SizedBox(height: 16),

                // Days
                ..._response.weekplan.map((day) => _buildDayCard(day)),

                // Strategy insights
                if (_response.strategy.insights.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _buildStrategyCard(),
                ],

                const SizedBox(height: 100),
              ],
            ),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildContextCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.primaryGreen.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('🧠', style: TextStyle(fontSize: 18)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ich hab verstanden:',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                ),
                const SizedBox(height: 4),
                Text(
                  _response.contextAnalysis.displaySummary!,
                  style: const TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayCard(PlannedDay day) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Day header
          Row(
            children: [
              Text(
                _getDayLabel(day.dayName).toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  letterSpacing: 1,
                ),
              ),
              if (day.dayContext != null) ...[
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: _getContextColor(day.dayContext!),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    _getContextLabel(day.dayContext!),
                    style: const TextStyle(fontSize: 11, color: Colors.white),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),

          // Meals - sorted by slot order: breakfast → lunch → dinner
          ...['breakfast', 'lunch', 'dinner']
              .where((slot) => day.meals.containsKey(slot))
              .map((slot) => _buildMealCard(day, slot, day.meals[slot]!)),
        ],
      ),
    );
  }

  Widget _buildMealCard(PlannedDay day, String slot, PlannedMealSlot meal) {
    final recipe = meal.recipeId != null
        ? _response.recipes[meal.recipeId] as Map<String, dynamic>?
        : null;

    final title = recipe?['title'] ?? 'Unbekanntes Rezept';
    final prepTime = recipe?['prep_time_min'] ?? 0;
    final cookTime = recipe?['cook_time_min'] ?? 0;
    final totalTime = prepTime + cookTime;
    final image = recipe?['image'] as String?;
    final recipeId = meal.recipeId;

    String? imageUrl;
    if (image != null && image.isNotEmpty && recipeId != null) {
      imageUrl = '${AppConfig.pocketBaseUrl}/api/files/recipes/$recipeId/$image';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Slot label with icon
          Row(
            children: [
              Icon(
                _getSlotIcon(slot),
                size: 14,
                color: Colors.grey.shade600,
              ),
              const SizedBox(width: 4),
              Text(
                _getSlotLabel(slot),
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Recipe info
          Row(
            children: [
              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 60,
                  height: 60,
                  child: imageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => Container(
                            color: Colors.grey.shade200,
                          ),
                          errorWidget: (_, __, ___) => Container(
                            color: Colors.grey.shade200,
                            child: const Icon(Icons.restaurant, size: 24),
                          ),
                        )
                      : Container(
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.restaurant, size: 24),
                        ),
                ),
              ),
              const SizedBox(width: 12),

              // Title and time
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.schedule,
                            size: 14, color: Colors.grey.shade600),
                        const SizedBox(width: 4),
                        Text(
                          '$totalTime min',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Refine button
              IconButton(
                icon: const Icon(Icons.chat_bubble_outline, size: 20),
                color: AppTheme.primaryGreen,
                onPressed: () => _showRefineSheet(day, slot, meal),
                tooltip: 'Anpassen',
              ),
            ],
          ),

          // Reasoning
          if (meal.reasoning.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('💭', style: TextStyle(fontSize: 12)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      meal.reasoning,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStrategyCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text('💡', style: TextStyle(fontSize: 16)),
              SizedBox(width: 8),
              Text(
                'Meine Strategie',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...(_response.strategy.insights).map(
            (insight) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('✓ ', style: TextStyle(color: Colors.green)),
                  Expanded(child: Text(insight, style: const TextStyle(fontSize: 13))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _savePlan,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryGreen,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        )
                      : const Text(
                          'Plan übernehmen',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getContextColor(String context) {
    switch (context) {
      case 'busy':
        return Colors.orange;
      case 'guests':
        return Colors.purple;
      case 'relaxed':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _getContextLabel(String context) {
    switch (context) {
      case 'busy':
        return 'Wenig Zeit';
      case 'guests':
        return 'Gäste';
      case 'relaxed':
        return 'Entspannt';
      default:
        return context;
    }
  }

  String _getSlotLabel(String slot) {
    switch (slot) {
      case 'breakfast':
        return 'Frühstück';
      case 'lunch':
        return 'Mittagessen';
      case 'dinner':
        return 'Abendessen';
      default:
        return slot;
    }
  }

  IconData _getSlotIcon(String slot) {
    switch (slot) {
      case 'breakfast':
        return Icons.wb_twilight_outlined;
      case 'lunch':
        return Icons.light_mode_outlined;
      case 'dinner':
        return Icons.dark_mode_outlined;
      default:
        return Icons.restaurant;
    }
  }

  String _getDayLabel(String dayName) {
    switch (dayName.toLowerCase()) {
      case 'monday':
        return 'Montag';
      case 'tuesday':
        return 'Dienstag';
      case 'wednesday':
        return 'Mittwoch';
      case 'thursday':
        return 'Donnerstag';
      case 'friday':
        return 'Freitag';
      case 'saturday':
        return 'Samstag';
      case 'sunday':
        return 'Sonntag';
      default:
        return dayName;
    }
  }
}

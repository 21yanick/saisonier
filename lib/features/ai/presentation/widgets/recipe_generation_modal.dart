import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saisonier/core/theme/app_theme.dart';
import 'package:saisonier/core/database/app_database.dart' hide AIProfile;
import 'package:saisonier/features/ai/domain/enums/ai_enums.dart';
import 'package:saisonier/features/ai/domain/models/ai_profile.dart';
import 'package:saisonier/features/ai/domain/models/generated_recipe.dart';
import 'package:saisonier/features/ai/data/repositories/ai_service.dart';
import 'package:saisonier/features/ai/presentation/controllers/ai_profile_controller.dart';
import 'package:saisonier/features/seasonality/data/repositories/vegetable_repository.dart';

/// Modal for generating AI recipes.
/// Features: Inspiration chips, free-form input, seasonal vegetables,
/// category/style selection, and override options.
class RecipeGenerationModal extends ConsumerStatefulWidget {
  final Function(GeneratedRecipe recipe) onRecipeGenerated;

  const RecipeGenerationModal({
    super.key,
    required this.onRecipeGenerated,
  });

  @override
  ConsumerState<RecipeGenerationModal> createState() =>
      _RecipeGenerationModalState();
}

class _RecipeGenerationModalState extends ConsumerState<RecipeGenerationModal> {
  final TextEditingController _freeFormController = TextEditingController();
  final TextEditingController _ingredientsController = TextEditingController();

  // Selections
  final Set<String> _selectedVegetables = {};
  RecipeStyle _selectedStyle = RecipeStyle.comfort;
  RecipeCategory _selectedCategory = RecipeCategory.main;
  RecipeInspiration? _selectedInspiration;

  // Overrides (for this recipe only)
  bool _forceVegetarian = false;
  bool _forceVegan = false;
  bool _forceQuick = false; // Max 30 min

  // Expanded options
  bool _showAdvancedOptions = false;
  Cuisine? _cuisineOverride;
  Protein? _proteinOverride;
  NutritionFocus? _nutritionOverride;

  // State
  bool _isGenerating = false;
  String? _errorMessage;

  @override
  void dispose() {
    _freeFormController.dispose();
    _ingredientsController.dispose();
    super.dispose();
  }

  void _onInspirationTap(RecipeInspiration inspiration) {
    setState(() {
      if (_selectedInspiration == inspiration) {
        // Deselect
        _selectedInspiration = null;
        _resetInspirationEffects();
      } else {
        _selectedInspiration = inspiration;
        _applyInspirationEffects(inspiration);
      }
    });
  }

  void _applyInspirationEffects(RecipeInspiration inspiration) {
    switch (inspiration) {
      case RecipeInspiration.surprise:
        // Random vegetables will be selected by AI
        _selectedVegetables.clear();
        _freeFormController.text = '';
        break;
      case RecipeInspiration.quick:
        _forceQuick = true;
        _selectedStyle = RecipeStyle.quick;
        break;
      case RecipeInspiration.onePot:
        _selectedStyle = RecipeStyle.onePot;
        break;
      case RecipeInspiration.kidFriendly:
        // Will be passed to AI prompt
        break;
      case RecipeInspiration.forGuests:
        _selectedStyle = RecipeStyle.festive;
        break;
    }
  }

  void _resetInspirationEffects() {
    _forceQuick = false;
    _selectedStyle = RecipeStyle.comfort;
  }

  Future<void> _generateRecipe() async {
    setState(() {
      _isGenerating = true;
      _errorMessage = null;
    });

    try {
      final recipe = await ref.read(aiServiceProvider).generateRecipe(
            seasonalVegetables: _selectedVegetables.toList(),
            style: _selectedStyle,
            category: _selectedCategory,
            freeFormRequest: _freeFormController.text.isEmpty
                ? null
                : _freeFormController.text,
            additionalIngredients: _ingredientsController.text.isEmpty
                ? null
                : _ingredientsController.text,
            inspiration: _selectedInspiration,
            forceVegetarian: _forceVegetarian,
            forceVegan: _forceVegan,
            forceQuick: _forceQuick,
            cuisineOverride: _cuisineOverride,
            proteinOverride: _proteinOverride,
            nutritionOverride: _nutritionOverride,
          );

      if (mounted) {
        Navigator.pop(context);
        widget.onRecipeGenerated(recipe);
      }
    } catch (e) {
      setState(() {
        _errorMessage = e is AIServiceException
            ? e.message
            : 'Rezept konnte nicht generiert werden. Bitte versuche es erneut.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isGenerating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // Prevent dismiss while generating
      canPop: !_isGenerating,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _isGenerating) {
          // Show warning if user tries to dismiss while generating
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Bitte warte, das Rezept wird generiert...'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      },
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        // CRITICAL: Prevent sheet from closing when dragged to min extent
        shouldCloseOnMinExtent: false,
        // Snap to defined sizes for better UX
        snap: true,
        snapSizes: const [0.5, 0.9],
        builder: (context, scrollController) {
          return Column(
            children: [
              // Header
              _buildHeader(context),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Inspiration chips
                      _buildInspirationSection(),

                      const SizedBox(height: 20),
                      _buildDivider(),
                      const SizedBox(height: 20),

                      // Free-form input (prominent)
                      _buildFreeFormSection(),

                      const SizedBox(height: 20),

                      // Seasonal vegetables (optional, horizontal scroll)
                      _buildSeasonalVegetablesSection(),

                      const SizedBox(height: 20),

                      // Additional ingredients
                      _buildIngredientsSection(),

                      const SizedBox(height: 20),
                      _buildDivider(),
                      const SizedBox(height: 20),

                      // Category & Style
                      _buildCategoryStyleSection(),

                      const SizedBox(height: 16),

                      // Quick toggles
                      _buildQuickToggles(),

                      const SizedBox(height: 16),

                      // Advanced options (expandable)
                      _buildAdvancedOptions(),

                      // Error message
                      if (_errorMessage != null) ...[
                        const SizedBox(height: 16),
                        _buildErrorMessage(),
                      ],

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),

              // Generate button
              _buildGenerateButton(),
            ],
          );
        },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 12, 0),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.auto_awesome,
                      color: AppColors.primaryGreen,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Rezept-Ideen',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              IconButton(
                onPressed: _isGenerating
                    ? null  // Disabled during generation
                    : () => Navigator.pop(context),
                icon: Icon(
                  Icons.close,
                  color: _isGenerating ? Colors.grey.shade300 : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildInspirationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Inspiration',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: RecipeInspiration.values.map((inspiration) {
            final isSelected = _selectedInspiration == inspiration;
            return _InspirationChip(
              emoji: inspiration.emoji,
              label: inspiration.label,
              isSelected: isSelected,
              onTap: () => _onInspirationTap(inspiration),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildFreeFormSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel('Was schwebt dir vor?', optional: true),
        const SizedBox(height: 8),
        TextField(
          controller: _freeFormController,
          maxLines: 2,
          decoration: InputDecoration(
            hintText: 'z.B. "Ein cremiges Gratin mit Lauch"',
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
            contentPadding: const EdgeInsets.all(14),
          ),
        ),
      ],
    );
  }

  Widget _buildSeasonalVegetablesSection() {
    final currentMonth = DateTime.now().month;
    final monthNames = [
      '',
      'Januar',
      'Februar',
      'März',
      'April',
      'Mai',
      'Juni',
      'Juli',
      'August',
      'September',
      'Oktober',
      'November',
      'Dezember'
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildSectionLabel('Saisonal im ${monthNames[currentMonth]}',
                optional: true),
            const SizedBox(width: 8),
            Text(
              '(tippen zum wählen)',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade500,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 40,
          child: StreamBuilder<List<Vegetable>>(
            stream: ref
                .watch(vegetableRepositoryProvider)
                .watchSeasonal(currentMonth),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              }

              final vegetables = snapshot.data!;

              return ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: vegetables.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final veg = vegetables[index];
                  final isSelected = _selectedVegetables.contains(veg.name);
                  return _VegetableChip(
                    name: veg.name,
                    isSelected: isSelected,
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          _selectedVegetables.remove(veg.name);
                        } else {
                          _selectedVegetables.add(veg.name);
                        }
                        // Clear inspiration if manually selecting
                        if (_selectedInspiration == RecipeInspiration.surprise) {
                          _selectedInspiration = null;
                        }
                      });
                    },
                  );
                },
              );
            },
          ),
        ),
        if (_selectedVegetables.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              'Keine Auswahl? AI wählt passend zur Saison.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade500,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildIngredientsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel('Zutaten die du verwenden willst', optional: true),
        const SizedBox(height: 8),
        TextField(
          controller: _ingredientsController,
          decoration: InputDecoration(
            hintText: 'z.B. Kartoffeln, Rahm, Speck',
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
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryStyleSection() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionLabel('Kategorie'),
              const SizedBox(height: 8),
              _buildDropdown<RecipeCategory>(
                value: _selectedCategory,
                items: RecipeCategory.values,
                labelBuilder: (cat) => cat.label,
                onChanged: (cat) {
                  if (cat != null) setState(() => _selectedCategory = cat);
                },
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionLabel('Stil'),
              const SizedBox(height: 8),
              _buildDropdown<RecipeStyle>(
                value: _selectedStyle,
                items: RecipeStyle.values,
                labelBuilder: (style) => '${style.emoji} ${style.label}',
                onChanged: (style) {
                  if (style != null) {
                    setState(() {
                      _selectedStyle = style;
                      // Clear inspiration if manually changing style
                      _selectedInspiration = null;
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickToggles() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Für dieses Rezept:',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _ToggleChip(
              label: 'Vegetarisch',
              isSelected: _forceVegetarian,
              onTap: () => setState(() {
                _forceVegetarian = !_forceVegetarian;
                if (_forceVegetarian) _forceVegan = false;
              }),
            ),
            _ToggleChip(
              label: 'Vegan',
              isSelected: _forceVegan,
              onTap: () => setState(() {
                _forceVegan = !_forceVegan;
                if (_forceVegan) _forceVegetarian = false;
              }),
            ),
            _ToggleChip(
              label: 'Max 30 Min',
              isSelected: _forceQuick,
              onTap: () => setState(() => _forceQuick = !_forceQuick),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAdvancedOptions() {
    final aiProfile = ref.watch(aIProfileControllerProvider).valueOrNull;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => setState(() => _showAdvancedOptions = !_showAdvancedOptions),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Icon(
                  _showAdvancedOptions
                      ? Icons.expand_less
                      : Icons.expand_more,
                  color: Colors.grey.shade600,
                  size: 20,
                ),
                const SizedBox(width: 4),
                Text(
                  'Erweiterte Optionen',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade600,
                  ),
                ),
                if (_hasOverrides()) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'Aktiv',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.primaryGreen,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        if (_showAdvancedOptions) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Info text - different based on profile state
                Row(
                  children: [
                    Icon(
                      aiProfile != null ? Icons.info_outline : Icons.lightbulb_outline,
                      size: 16,
                      color: aiProfile != null ? Colors.grey.shade500 : Colors.orange.shade600,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        aiProfile != null
                            ? 'Überschreibe dein Profil für dieses Rezept'
                            : 'Wähle Präferenzen für dieses Rezept (oder konfiguriere dein AI-Profil in den Einstellungen)',
                        style: TextStyle(
                          fontSize: 12,
                          color: aiProfile != null ? Colors.grey.shade600 : Colors.orange.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Cuisine override
                _buildOverrideSection<Cuisine>(
                  label: 'Küche',
                  profileValue: _formatProfileListOrHint(
                    aiProfile?.cuisinePreferences.map((c) => c.label).toList(),
                    aiProfile,
                  ),
                  currentOverride: _cuisineOverride,
                  items: Cuisine.values,
                  labelBuilder: (c) => c.label,
                  onChanged: (c) => setState(() => _cuisineOverride = c),
                ),

                const SizedBox(height: 12),

                // Protein override
                _buildOverrideSection<Protein>(
                  label: 'Protein',
                  profileValue: _formatProfileListOrHint(
                    aiProfile?.proteinPreferences.map((p) => p.label).toList(),
                    aiProfile,
                  ),
                  currentOverride: _proteinOverride,
                  items: Protein.values,
                  labelBuilder: (p) => p.label,
                  onChanged: (p) => setState(() => _proteinOverride = p),
                ),

                const SizedBox(height: 12),

                // Nutrition override
                _buildOverrideSection<NutritionFocus>(
                  label: 'Fokus',
                  profileValue: aiProfile?.nutritionFocus.label,
                  currentOverride: _nutritionOverride,
                  items: NutritionFocus.values,
                  labelBuilder: (n) => n.label,
                  onChanged: (n) => setState(() => _nutritionOverride = n),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildOverrideSection<T>({
    required String label,
    required String? profileValue,
    required T? currentOverride,
    required List<T> items,
    required String Function(T) labelBuilder,
    required void Function(T?) onChanged,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 60,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade700,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: currentOverride != null
                    ? AppColors.primaryGreen
                    : Colors.grey.shade300,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<T?>(
                value: currentOverride,
                isExpanded: true,
                hint: Text(
                  profileValue != null ? 'Profil: $profileValue' : 'Wählen...',
                  style: TextStyle(
                    fontSize: 13,
                    color: profileValue != null
                        ? Colors.grey.shade600
                        : Colors.grey.shade400,
                  ),
                ),
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black87,
                ),
                items: [
                  DropdownMenuItem<T?>(
                    value: null,
                    child: Text(
                      profileValue != null ? 'Profil: $profileValue' : 'Keine Präferenz',
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                  ),
                  ...items.map((item) => DropdownMenuItem<T>(
                        value: item,
                        child: Text(labelBuilder(item)),
                      )),
                ],
                onChanged: onChanged,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorMessage() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade700),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _errorMessage!,
              style: TextStyle(color: Colors.red.shade700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenerateButton() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isGenerating ? null : _generateRecipe,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              disabledBackgroundColor: AppColors.primaryGreen.withValues(alpha: 0.6),
            ),
            child: _isGenerating
                ? const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      ),
                      SizedBox(width: 12),
                      Text('Generiere Rezept...'),
                    ],
                  )
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.auto_awesome, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Rezept generieren',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  // Helper widgets
  Widget _buildSectionLabel(String text, {bool optional = false}) {
    return Row(
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        if (optional) ...[
          const SizedBox(width: 4),
          Text(
            '(optional)',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDropdown<T>({
    required T value,
    required List<T> items,
    required String Function(T) labelBuilder,
    required void Function(T?) onChanged,
  }) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
          ),
          items: items
              .map((item) => DropdownMenuItem<T>(
                    value: item,
                    child: Text(labelBuilder(item)),
                  ))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(color: Colors.grey.shade200, height: 1);
  }

  bool _hasOverrides() {
    return _cuisineOverride != null ||
        _proteinOverride != null ||
        _nutritionOverride != null;
  }

  /// Formats a list of profile values into a readable string.
  /// Shows different hints based on whether AI profile exists.
  String? _formatProfileListOrHint(List<String>? items, AIProfile? profile) {
    // Profile exists and has values
    if (items != null && items.isNotEmpty) {
      if (items.length <= 3) {
        return items.join(', ');
      }
      return '${items.length} ausgewählt';
    }
    // Profile exists but list is empty - user hasn't configured this
    if (profile != null) {
      return null; // Will show "Standard" in dropdown
    }
    // No profile at all
    return null;
  }
}

// ============================================================================
// Sub-widgets
// ============================================================================

class _InspirationChip extends StatelessWidget {
  final String emoji;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _InspirationChip({
    required this.emoji,
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryGreen
              : AppColors.primaryGreen.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryGreen
                : AppColors.primaryGreen.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.primaryGreen,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VegetableChip extends StatelessWidget {
  final String name;
  final bool isSelected;
  final VoidCallback onTap;

  const _VegetableChip({
    required this.name,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryGreen : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primaryGreen : Colors.grey.shade300,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              name,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey.shade700,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 13,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 4),
              const Icon(Icons.check, size: 14, color: Colors.white),
            ],
          ],
        ),
      ),
    );
  }
}

class _ToggleChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ToggleChip({
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
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryGreen.withValues(alpha: 0.1)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primaryGreen : Colors.grey.shade300,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? Icons.check_box : Icons.check_box_outline_blank,
              size: 18,
              color: isSelected ? AppColors.primaryGreen : Colors.grey.shade500,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color:
                    isSelected ? AppColors.primaryGreen : Colors.grey.shade700,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shows the recipe generation modal.
void showRecipeGenerationModal(
  BuildContext context, {
  required Function(GeneratedRecipe recipe) onRecipeGenerated,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    // Disable drag-to-dismiss - user must use X button
    // This prevents accidental dismiss during recipe generation
    enableDrag: false,
    isDismissible: false,
    builder: (context) => RecipeGenerationModal(
      onRecipeGenerated: onRecipeGenerated,
    ),
  );
}

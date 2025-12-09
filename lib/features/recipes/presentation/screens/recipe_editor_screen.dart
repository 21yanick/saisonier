import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saisonier/core/database/app_database.dart';
import 'package:saisonier/features/auth/presentation/controllers/auth_controller.dart';
import 'package:saisonier/features/seasonality/data/repositories/recipe_repository.dart';
import 'package:saisonier/features/seasonality/data/repositories/vegetable_repository.dart';
import 'package:saisonier/features/seasonality/domain/enums/recipe_enums.dart';
import 'package:saisonier/features/seasonality/presentation/screens/main_screen.dart';
import 'package:saisonier/features/seasonality/domain/models/ingredient.dart';

class RecipeEditorScreen extends ConsumerStatefulWidget {
  final String? recipeId;

  const RecipeEditorScreen({super.key, this.recipeId});

  @override
  ConsumerState<RecipeEditorScreen> createState() => _RecipeEditorScreenState();
}

class _RecipeEditorScreenState extends ConsumerState<RecipeEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _prepTimeController = TextEditingController(text: '15');
  final _cookTimeController = TextEditingController(text: '30');
  final _servingsController = TextEditingController(text: '4');

  RecipeDifficulty _difficulty = RecipeDifficulty.easy;
  RecipeCategory? _category;
  String? _vegetableId;
  bool _isVegetarian = false;
  bool _isVegan = false;
  List<String> _selectedTags = [];

  File? _imageFile;
  bool _isLoading = false;
  bool _isInitialized = false;

  final List<IngredientEntry> _ingredients = [];
  final List<TextEditingController> _stepControllers = [];

  bool get isEditing => widget.recipeId != null;

  @override
  void initState() {
    super.initState();
    _addIngredient();
    _addStep();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _prepTimeController.dispose();
    _cookTimeController.dispose();
    _servingsController.dispose();
    for (final ing in _ingredients) {
      ing.dispose();
    }
    for (final ctrl in _stepControllers) {
      ctrl.dispose();
    }
    super.dispose();
  }

  Future<void> _loadExistingRecipe() async {
    if (!isEditing || _isInitialized) return;
    _isInitialized = true;

    final recipe = await ref.read(recipeRepositoryProvider).getRecipe(widget.recipeId!);
    if (recipe == null || !mounted) return;

    _titleController.text = recipe.title;
    _descriptionController.text = recipe.description;
    _prepTimeController.text = recipe.prepTimeMin.toString();
    _cookTimeController.text = recipe.cookTimeMin.toString();
    _servingsController.text = recipe.servings.toString();

    if (recipe.difficulty != null) {
      _difficulty = RecipeDifficulty.values.firstWhere(
        (d) => d.name == recipe.difficulty,
        orElse: () => RecipeDifficulty.easy,
      );
    }

    _category = RecipeCategory.fromValue(recipe.category);
    // PocketBase returns "" instead of null for empty relations
    _vegetableId = (recipe.vegetableId?.isEmpty ?? true) ? null : recipe.vegetableId;
    _isVegetarian = recipe.isVegetarian;
    _isVegan = recipe.isVegan;

    // Load tags
    try {
      final tagList = jsonDecode(recipe.tags) as List;
      _selectedTags = tagList.map((e) => e.toString()).toList();
    } catch (_) {
      _selectedTags = [];
    }

    // Load ingredients
    _ingredients.clear();
    try {
      final ingList = jsonDecode(recipe.ingredients) as List;
      for (final ing in ingList) {
        final entry = IngredientEntry();
        entry.itemController.text = (ing['item'] ?? ing['name'] ?? '') as String;
        final amount = ing['amount'];
        entry.amountController.text = amount != null ? amount.toString() : '';
        entry.unit = ing['unit'] as String?;
        entry.noteController.text = (ing['note'] ?? '') as String;
        _ingredients.add(entry);
      }
    } catch (_) {}
    if (_ingredients.isEmpty) _addIngredient();

    // Load steps
    for (final ctrl in _stepControllers) {
      ctrl.dispose();
    }
    _stepControllers.clear();
    try {
      final stepList = jsonDecode(recipe.steps) as List;
      for (final step in stepList) {
        _stepControllers.add(TextEditingController(text: step.toString()));
      }
    } catch (_) {}
    if (_stepControllers.isEmpty) _addStep();

    setState(() {});
  }

  void _addIngredient() {
    setState(() => _ingredients.add(IngredientEntry()));
  }

  void _removeIngredient(int index) {
    if (_ingredients.length > 1) {
      setState(() {
        _ingredients[index].dispose();
        _ingredients.removeAt(index);
      });
    }
  }

  void _addStep() {
    setState(() => _stepControllers.add(TextEditingController()));
  }

  void _removeStep(int index) {
    if (_stepControllers.length > 1) {
      setState(() {
        _stepControllers[index].dispose();
        _stepControllers.removeAt(index);
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1200,
      maxHeight: 1200,
      imageQuality: 85,
    );
    if (picked != null) {
      setState(() => _imageFile = File(picked.path));
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final user = ref.read(currentUserProvider).valueOrNull;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bitte zuerst anmelden')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Build ingredients list with proper format
      final ingredients = _ingredients
          .where((ing) => ing.itemController.text.trim().isNotEmpty)
          .map((ing) {
            final amountText = ing.amountController.text.trim();
            final amount = double.tryParse(amountText);
            return {
              'item': ing.itemController.text.trim(),
              'amount': amount,
              'unit': ing.unit,
              'note': ing.noteController.text.trim().isEmpty
                  ? null
                  : ing.noteController.text.trim(),
            };
          })
          .toList();

      final steps = _stepControllers
          .map((c) => c.text.trim())
          .where((s) => s.isNotEmpty)
          .toList();

      final repo = ref.read(recipeRepositoryProvider);

      if (isEditing) {
        await repo.updateUserRecipe(
          recipeId: widget.recipeId!,
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          ingredients: ingredients,
          steps: steps,
          prepTimeMin: int.tryParse(_prepTimeController.text) ?? 0,
          cookTimeMin: int.tryParse(_cookTimeController.text) ?? 30,
          servings: int.tryParse(_servingsController.text) ?? 4,
          difficulty: _difficulty.name,
          category: _category?.value,
          vegetableId: _vegetableId,
          isVegetarian: _isVegetarian,
          isVegan: _isVegan,
          tags: _selectedTags.isNotEmpty ? _selectedTags : null,
          imageFile: _imageFile,
        );
      } else {
        await repo.createUserRecipe(
          userId: user.id,
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          ingredients: ingredients,
          steps: steps,
          prepTimeMin: int.tryParse(_prepTimeController.text) ?? 0,
          cookTimeMin: int.tryParse(_cookTimeController.text) ?? 30,
          servings: int.tryParse(_servingsController.text) ?? 4,
          difficulty: _difficulty.name,
          category: _category?.value,
          vegetableId: _vegetableId,
          isVegetarian: _isVegetarian,
          isVegan: _isVegan,
          tags: _selectedTags.isNotEmpty ? _selectedTags : null,
          imageFile: _imageFile,
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(isEditing ? 'Rezept aktualisiert' : 'Rezept erstellt')),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _confirmDelete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rezept löschen?'),
        content: const Text('Diese Aktion kann nicht rückgängig gemacht werden.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Löschen'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      setState(() => _isLoading = true);
      try {
        await ref.read(recipeRepositoryProvider).deleteUserRecipe(widget.recipeId!);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Rezept gelöscht')),
          );
          // Navigate back to MyRecipesScreen (PageView index 2)
          ref.read(mainPageIndexProvider.notifier).state = 2;
          context.go('/');
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Fehler: $e'), backgroundColor: Colors.red),
          );
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isEditing && !_isInitialized) {
      _loadExistingRecipe();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Rezept bearbeiten' : 'Neues Rezept'),
        actions: [
          if (isEditing)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: _isLoading ? null : _confirmDelete,
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // === Bild ===
                  _buildImagePicker(),
                  const SizedBox(height: 24),

                  // === Titel ===
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Titel *',
                      hintText: 'z.B. Omas Apfelkuchen',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Titel erforderlich' : null,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  const SizedBox(height: 16),

                  // === Beschreibung ===
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Beschreibung',
                      hintText: 'Kurze Beschreibung des Rezepts...',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  const SizedBox(height: 16),

                  // === Zeiten (getrennt) ===
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _prepTimeController,
                          decoration: const InputDecoration(
                            labelText: 'Vorbereitung (Min)',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _cookTimeController,
                          decoration: const InputDecoration(
                            labelText: 'Kochzeit (Min)',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // === Portionen + Schwierigkeit ===
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _servingsController,
                          decoration: const InputDecoration(
                            labelText: 'Portionen',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<RecipeDifficulty>(
                          initialValue: _difficulty,
                          decoration: const InputDecoration(
                            labelText: 'Schwierigkeit',
                            border: OutlineInputBorder(),
                          ),
                          items: RecipeDifficulty.values
                              .map((d) => DropdownMenuItem(value: d, child: Text(d.label)))
                              .toList(),
                          onChanged: (v) =>
                              setState(() => _difficulty = v ?? RecipeDifficulty.easy),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // === Kategorie ===
                  InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Kategorie',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<RecipeCategory?>(
                        value: _category,
                        isExpanded: true,
                        isDense: true,
                        items: [
                          const DropdownMenuItem(value: null, child: Text('Keine Kategorie')),
                          ...RecipeCategory.values
                              .map((c) => DropdownMenuItem(value: c, child: Text(c.label))),
                        ],
                        onChanged: (v) => setState(() => _category = v),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // === Saisonales Gemüse (suchbar) ===
                  _VegetableSelector(
                    selectedId: _vegetableId,
                    onChanged: (id) => setState(() => _vegetableId = id),
                  ),
                  const SizedBox(height: 20),

                  // === Ernährung ===
                  const Text(
                    'Ernährung',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      FilterChip(
                        label: const Text('Vegetarisch'),
                        selected: _isVegetarian,
                        onSelected: (v) => setState(() {
                          _isVegetarian = v;
                          if (!v) _isVegan = false;
                        }),
                      ),
                      FilterChip(
                        label: const Text('Vegan'),
                        selected: _isVegan,
                        onSelected: (v) => setState(() {
                          _isVegan = v;
                          if (v) _isVegetarian = true;
                        }),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // === Tags ===
                  const Text(
                    'Tags',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: availableTags.map((tag) {
                      final isSelected = _selectedTags.contains(tag);
                      return FilterChip(
                        label: Text(tag),
                        selected: isSelected,
                        onSelected: (v) => setState(() {
                          if (v) {
                            _selectedTags.add(tag);
                          } else {
                            _selectedTags.remove(tag);
                          }
                        }),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // === Zutaten ===
                  _buildSectionHeader('Zutaten', onAdd: _addIngredient),
                  const SizedBox(height: 8),
                  ..._ingredients.asMap().entries.map((e) => _buildIngredientRow(e.key)),
                  const SizedBox(height: 24),

                  // === Zubereitung ===
                  _buildSectionHeader('Zubereitung', onAdd: _addStep),
                  const SizedBox(height: 8),
                  ..._stepControllers.asMap().entries.map((e) => _buildStepRow(e.key)),
                  const SizedBox(height: 100), // Space for sticky button
                ],
              ),
            ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: FilledButton.icon(
            onPressed: _isLoading ? null : _save,
            icon: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.save),
            label: Text(isEditing ? 'Speichern' : 'Rezept erstellen'),
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          image: _imageFile != null
              ? DecorationImage(image: FileImage(_imageFile!), fit: BoxFit.cover)
              : null,
        ),
        child: _imageFile == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_a_photo, size: 48, color: Colors.grey[500]),
                  const SizedBox(height: 8),
                  Text('Foto hinzufügen', style: TextStyle(color: Colors.grey[600])),
                ],
              )
            : Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: CircleAvatar(
                    backgroundColor: Colors.black54,
                    child: IconButton(
                      icon: const Icon(Icons.edit, color: Colors.white),
                      onPressed: _pickImage,
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, {required VoidCallback onAdd}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: onAdd),
      ],
    );
  }

  Widget _buildIngredientRow(int index) {
    final entry = _ingredients[index];
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          Row(
            children: [
              // Menge - fixe Breite (Zahlen sind kurz)
              SizedBox(
                width: 56,
                child: TextField(
                  controller: entry.amountController,
                  decoration: const InputDecoration(
                    hintText: 'Menge',
                    isDense: true,
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              const SizedBox(width: 6),
              // Einheit - flexible mit Minimum
              Flexible(
                flex: 2,
                child: DropdownButtonFormField<String?>(
                  initialValue: entry.unit,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  ),
                  items: [
                    const DropdownMenuItem(value: null, child: Text('-')),
                    ...availableUnits.map(
                      (u) => DropdownMenuItem(value: u, child: Text(u)),
                    ),
                    // Falls gespeicherte Einheit nicht in Liste, dynamisch hinzufügen
                    if (entry.unit != null && !availableUnits.contains(entry.unit))
                      DropdownMenuItem(value: entry.unit, child: Text(entry.unit!)),
                  ],
                  onChanged: (v) => setState(() => entry.unit = v),
                ),
              ),
              const SizedBox(width: 6),
              // Zutat - nimmt restlichen Platz
              Expanded(
                flex: 4,
                child: TextField(
                  controller: entry.itemController,
                  decoration: const InputDecoration(
                    hintText: 'Zutat *',
                    isDense: true,
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                  ),
                  textCapitalization: TextCapitalization.sentences,
                ),
              ),
              // Remove Button
              SizedBox(
                width: 40,
                child: IconButton(
                  icon: const Icon(Icons.remove_circle_outline, color: Colors.red, size: 20),
                  onPressed: () => _removeIngredient(index),
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Notiz (optional) - volle Breite mit Einrückung
          Padding(
            padding: const EdgeInsets.only(right: 40), // Gleiche Breite wie Remove-Button
            child: TextField(
              controller: entry.noteController,
              decoration: InputDecoration(
                hintText: 'Notiz (optional, z.B. "fein gehackt")',
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 12),
                isDense: true,
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              ),
              style: const TextStyle(fontSize: 13),
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepRow(int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            margin: const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _stepControllers[index],
              decoration: const InputDecoration(
                hintText: 'Schritt beschreiben...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              minLines: 1,
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
            onPressed: () => _removeStep(index),
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }
}

/// Helper class for ingredient entry with 4 fields
class IngredientEntry {
  final TextEditingController itemController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  String? unit;

  void dispose() {
    itemController.dispose();
    amountController.dispose();
    noteController.dispose();
  }
}

/// Searchable vegetable selector widget
class _VegetableSelector extends ConsumerWidget {
  final String? selectedId;
  final ValueChanged<String?> onChanged;

  const _VegetableSelector({
    required this.selectedId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<List<Vegetable>>(
      stream: ref.watch(vegetableRepositoryProvider).watchAll(),
      builder: (context, snapshot) {
        final vegetables = snapshot.data ?? [];

        // Normalize empty string to null (PocketBase quirk)
        final normalizedId = (selectedId?.isEmpty ?? true) ? null : selectedId;

        // Find selected vegetable name
        final selectedVeg = normalizedId != null
            ? vegetables.where((v) => v.id == normalizedId).firstOrNull
            : null;

        return InkWell(
          onTap: () => _showSearchModal(context, vegetables),
          borderRadius: BorderRadius.circular(4),
          child: InputDecorator(
            decoration: const InputDecoration(
              labelText: 'Saisonales Gemüse (optional)',
              helperText: 'Verknüpft das Rezept mit diesem Gemüse',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selectedVeg?.name ?? 'Nicht verknüpft',
                    style: TextStyle(
                      color: selectedVeg != null ? null : Colors.grey[600],
                    ),
                  ),
                ),
                Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSearchModal(BuildContext context, List<Vegetable> vegetables) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => _VegetableSearchModal(
        vegetables: vegetables,
        selectedId: selectedId,
        onSelected: (id) {
          onChanged(id);
          Navigator.pop(context);
        },
      ),
    );
  }
}

/// Modal with search field and vegetable list
class _VegetableSearchModal extends StatefulWidget {
  final List<Vegetable> vegetables;
  final String? selectedId;
  final ValueChanged<String?> onSelected;

  const _VegetableSearchModal({
    required this.vegetables,
    required this.selectedId,
    required this.onSelected,
  });

  @override
  State<_VegetableSearchModal> createState() => _VegetableSearchModalState();
}

class _VegetableSearchModalState extends State<_VegetableSearchModal> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Vegetable> get _filteredVegetables {
    if (_searchQuery.isEmpty) return widget.vegetables;
    final query = _searchQuery.toLowerCase();
    return widget.vegetables
        .where((v) => v.name.toLowerCase().contains(query))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            // Handle
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Gemüse auswählen',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  if (widget.selectedId != null)
                    TextButton(
                      onPressed: () => widget.onSelected(null),
                      child: const Text('Entfernen'),
                    ),
                ],
              ),
            ),

            // Search field
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Suchen...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                onChanged: (value) => setState(() => _searchQuery = value),
              ),
            ),

            // List
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: _filteredVegetables.length,
                itemBuilder: (context, index) {
                  final veg = _filteredVegetables[index];
                  final isSelected = veg.id == widget.selectedId;

                  return ListTile(
                    title: Text(veg.name),
                    trailing: isSelected
                        ? Icon(Icons.check, color: Theme.of(context).primaryColor)
                        : null,
                    selected: isSelected,
                    onTap: () => widget.onSelected(veg.id),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

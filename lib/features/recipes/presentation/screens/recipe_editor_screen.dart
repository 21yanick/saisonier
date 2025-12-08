import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saisonier/features/auth/presentation/controllers/auth_controller.dart';
import 'package:saisonier/features/seasonality/data/repositories/recipe_repository.dart';
import 'package:saisonier/features/seasonality/domain/enums/recipe_enums.dart';

class RecipeEditorScreen extends ConsumerStatefulWidget {
  final String? recipeId;

  const RecipeEditorScreen({super.key, this.recipeId});

  @override
  ConsumerState<RecipeEditorScreen> createState() => _RecipeEditorScreenState();
}

class _RecipeEditorScreenState extends ConsumerState<RecipeEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _timeController = TextEditingController(text: '30');
  final _servingsController = TextEditingController(text: '4');

  RecipeDifficulty _difficulty = RecipeDifficulty.easy;
  File? _imageFile;
  bool _isLoading = false;
  bool _isInitialized = false;

  // Dynamic lists
  final List<IngredientEntry> _ingredients = [];
  final List<TextEditingController> _stepControllers = [];

  bool get isEditing => widget.recipeId != null;

  @override
  void initState() {
    super.initState();
    // Add initial empty entries
    _addIngredient();
    _addStep();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _timeController.dispose();
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
    _timeController.text = (recipe.prepTimeMin + recipe.cookTimeMin).toString();
    _servingsController.text = recipe.servings.toString();

    if (recipe.difficulty != null) {
      _difficulty = RecipeDifficulty.values.firstWhere(
        (d) => d.name == recipe.difficulty,
        orElse: () => RecipeDifficulty.easy,
      );
    }

    // Load ingredients
    _ingredients.clear();
    try {
      final ingList = jsonDecode(recipe.ingredients) as List;
      for (final ing in ingList) {
        final entry = IngredientEntry();
        entry.itemController.text = (ing['item'] ?? ing['name'] ?? '') as String;
        entry.amountController.text = (ing['amount'] ?? '') as String;
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
    setState(() {
      _ingredients.add(IngredientEntry());
    });
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
    setState(() {
      _stepControllers.add(TextEditingController());
    });
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
      setState(() {
        _imageFile = File(picked.path);
      });
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
      // Build ingredients list
      final ingredients = _ingredients
          .where((ing) => ing.itemController.text.trim().isNotEmpty)
          .map((ing) => {
                'item': ing.itemController.text.trim(),
                'amount': ing.amountController.text.trim(),
              })
          .toList();

      // Build steps list
      final steps = _stepControllers
          .map((c) => c.text.trim())
          .where((s) => s.isNotEmpty)
          .toList();

      final repo = ref.read(recipeRepositoryProvider);

      if (isEditing) {
        await repo.updateUserRecipe(
          recipeId: widget.recipeId!,
          title: _titleController.text.trim(),
          ingredients: ingredients,
          steps: steps,
          cookTimeMin: int.tryParse(_timeController.text) ?? 30,
          servings: int.tryParse(_servingsController.text) ?? 4,
          difficulty: _difficulty.name,
          imageFile: _imageFile,
        );
      } else {
        await repo.createUserRecipe(
          userId: user.id,
          title: _titleController.text.trim(),
          ingredients: ingredients,
          steps: steps,
          cookTimeMin: int.tryParse(_timeController.text) ?? 30,
          servings: int.tryParse(_servingsController.text) ?? 4,
          difficulty: _difficulty.name,
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
          context.go('/my-recipes');
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
    // Load existing recipe if editing
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
                  // Image picker
                  _buildImagePicker(),
                  const SizedBox(height: 24),

                  // Title
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Titel *',
                      hintText: 'z.B. Omas Apfelkuchen',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Titel erforderlich' : null,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  const SizedBox(height: 16),

                  // Time, Servings, Difficulty
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _timeController,
                          decoration: const InputDecoration(
                            labelText: 'Zeit (Min)',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        ),
                      ),
                      const SizedBox(width: 12),
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
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Difficulty
                  DropdownButtonFormField<RecipeDifficulty>(
                    initialValue: _difficulty,
                    decoration: const InputDecoration(
                      labelText: 'Schwierigkeit',
                      border: OutlineInputBorder(),
                    ),
                    items: RecipeDifficulty.values
                        .map((d) => DropdownMenuItem(value: d, child: Text(d.label)))
                        .toList(),
                    onChanged: (v) => setState(() => _difficulty = v ?? RecipeDifficulty.easy),
                  ),
                  const SizedBox(height: 24),

                  // Ingredients
                  _buildSectionHeader('Zutaten', onAdd: _addIngredient),
                  const SizedBox(height: 8),
                  ..._ingredients.asMap().entries.map((e) => _buildIngredientRow(e.key)),
                  const SizedBox(height: 24),

                  // Steps
                  _buildSectionHeader('Zubereitung', onAdd: _addStep),
                  const SizedBox(height: 8),
                  ..._stepControllers.asMap().entries.map((e) => _buildStepRow(e.key)),
                  const SizedBox(height: 32),

                  // Save button
                  FilledButton.icon(
                    onPressed: _isLoading ? null : _save,
                    icon: const Icon(Icons.save),
                    label: Text(isEditing ? 'Speichern' : 'Rezept erstellen'),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                  ),
                  const SizedBox(height: 60),
                ],
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
              ? DecorationImage(
                  image: FileImage(_imageFile!),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: _imageFile == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_a_photo, size: 48, color: Colors.grey[500]),
                  const SizedBox(height: 8),
                  Text(
                    'Foto hinzufügen',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
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
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: const Icon(Icons.add_circle_outline),
          onPressed: onAdd,
        ),
      ],
    );
  }

  Widget _buildIngredientRow(int index) {
    final entry = _ingredients[index];
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: TextField(
              controller: entry.amountController,
              decoration: const InputDecoration(
                hintText: 'Menge',
                isDense: true,
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: entry.itemController,
              decoration: const InputDecoration(
                hintText: 'Zutat',
                isDense: true,
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
            onPressed: () => _removeIngredient(index),
            visualDensity: VisualDensity.compact,
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

/// Helper class for ingredient entry
class IngredientEntry {
  final TextEditingController itemController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  void dispose() {
    itemController.dispose();
    amountController.dispose();
  }
}

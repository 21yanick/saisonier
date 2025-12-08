import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saisonier/core/theme/app_theme.dart';
import 'package:saisonier/features/profile/domain/enums/profile_enums.dart';
import 'package:saisonier/features/profile/domain/models/user_profile.dart';
import 'package:saisonier/features/profile/presentation/state/user_profile_controller.dart';

/// BottomSheet zum Bearbeiten der Ernährungspräferenzen (inkl. Dislikes)
class NutritionEditSheet extends ConsumerStatefulWidget {
  final UserProfile profile;

  const NutritionEditSheet({super.key, required this.profile});

  static Future<void> show(BuildContext context, UserProfile profile) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => NutritionEditSheet(profile: profile),
    );
  }

  @override
  ConsumerState<NutritionEditSheet> createState() => _NutritionEditSheetState();
}

class _NutritionEditSheetState extends ConsumerState<NutritionEditSheet> {
  late DietType _diet;
  late List<Allergen> _allergens;
  late List<String> _dislikes;
  final TextEditingController _dislikeController = TextEditingController();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _diet = widget.profile.diet;
    _allergens = List<Allergen>.from(widget.profile.allergens);
    _dislikes = List<String>.from(widget.profile.dislikes);
  }

  @override
  void dispose() {
    _dislikeController.dispose();
    super.dispose();
  }

  void _addDislike() {
    final text = _dislikeController.text.trim();
    if (text.isNotEmpty && !_dislikes.contains(text)) {
      setState(() {
        _dislikes.add(text);
        _dislikeController.clear();
      });
    }
  }

  void _removeDislike(String item) {
    setState(() {
      _dislikes.remove(item);
    });
  }

  Future<void> _save() async {
    setState(() => _saving = true);

    final updatedProfile = widget.profile.copyWith(
      diet: _diet,
      allergens: _allergens,
      dislikes: _dislikes,
    );

    await ref
        .read(userProfileControllerProvider.notifier)
        .updateProfile(updatedProfile);

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar & Title (fixed)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Icon(Icons.restaurant, color: AppTheme.primaryGreen),
                      const SizedBox(width: 12),
                      Text(
                        'Ernährung',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Scrollable content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Diet type
                    Text(
                      'Ernährungsweise',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: DietType.values.map((d) {
                        final selected = _diet == d;
                        return ChoiceChip(
                          label: Text(d.label),
                          selected: selected,
                          selectedColor: AppTheme.primaryGreen.withValues(alpha: 0.2),
                          checkmarkColor: AppTheme.primaryGreen,
                          onSelected: (s) {
                            if (s) setState(() => _diet = d);
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),

                    // Allergens
                    Text(
                      'Allergien / Unverträglichkeiten',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: Allergen.values.map((a) {
                        final selected = _allergens.contains(a);
                        return FilterChip(
                          label: Text(a.label),
                          selected: selected,
                          selectedColor: AppTheme.primaryGreen.withValues(alpha: 0.2),
                          checkmarkColor: AppTheme.primaryGreen,
                          onSelected: (s) {
                            setState(() {
                              if (s) {
                                _allergens.add(a);
                              } else {
                                _allergens.remove(a);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),

                    // Dislikes
                    Text(
                      'Das mag ich nicht',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Diese Zutaten werden im Feed ausgeblendet',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Input field for new dislike
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _dislikeController,
                            decoration: InputDecoration(
                              hintText: 'z.B. Rosenkohl',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                            textInputAction: TextInputAction.done,
                            onSubmitted: (_) => _addDislike(),
                          ),
                        ),
                        const SizedBox(width: 12),
                        IconButton.filled(
                          onPressed: _addDislike,
                          icon: const Icon(Icons.add),
                          style: IconButton.styleFrom(
                            backgroundColor: AppTheme.primaryGreen,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Dislikes chips
                    if (_dislikes.isNotEmpty)
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _dislikes.map((item) {
                          return Chip(
                            label: Text(item),
                            deleteIcon: const Icon(Icons.close, size: 18),
                            onDeleted: () => _removeDislike(item),
                            backgroundColor: Colors.red.withValues(alpha: 0.1),
                            deleteIconColor: Colors.red[700],
                            labelStyle: TextStyle(color: Colors.red[700]),
                          );
                        }).toList(),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline, color: Colors.grey[500], size: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Noch keine Zutaten hinzugefügt',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Save button (fixed at bottom)
            Padding(
              padding: EdgeInsets.fromLTRB(
                24,
                16,
                24,
                MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saving ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _saving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Speichern', style: TextStyle(fontSize: 16)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

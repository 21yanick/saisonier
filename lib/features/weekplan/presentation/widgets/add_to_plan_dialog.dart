import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../domain/date_utils.dart';
import '../../domain/enums.dart';
import '../state/weekplan_controller.dart';

/// Dialog to add a recipe to the week plan
class AddToPlanDialog extends ConsumerStatefulWidget {
  final String recipeId;
  final String recipeTitle;
  final int defaultServings;

  const AddToPlanDialog({
    super.key,
    required this.recipeId,
    required this.recipeTitle,
    required this.defaultServings,
  });

  @override
  ConsumerState<AddToPlanDialog> createState() => _AddToPlanDialogState();
}

class _AddToPlanDialogState extends ConsumerState<AddToPlanDialog> {
  late DateTime _selectedDate;
  MealSlot _selectedSlot = MealSlot.dinner;
  late int _servings;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _servings = widget.defaultServings;
  }

  List<DateTime> _getNextSevenDays() {
    final today = DateTime.now();
    return List.generate(7, (i) => today.add(Duration(days: i)));
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider).valueOrNull;

    return AlertDialog(
      title: const Text('Zum Plan hinzufügen'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recipe name
            Text(
              widget.recipeTitle,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),

            // Date selection
            const Text('Tag', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _getNextSevenDays().map((date) {
                final isSelected = date.day == _selectedDate.day &&
                    date.month == _selectedDate.month &&
                    date.year == _selectedDate.year;
                return ChoiceChip(
                  label: Text(WeekplanDateUtils.formatRelative(date)),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) setState(() => _selectedDate = date);
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            // Slot selection
            const Text('Mahlzeit', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: MealSlot.values.map((slot) {
                return ChoiceChip(
                  label: Text(slot.displayName),
                  selected: _selectedSlot == slot,
                  onSelected: (selected) {
                    if (selected) setState(() => _selectedSlot = slot);
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            // Servings
            Row(
              children: [
                const Text('Portionen:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: _servings > 1
                      ? () => setState(() => _servings--)
                      : null,
                ),
                Text(
                  '$_servings',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () => setState(() => _servings++),
                ),
              ],
            ),

            if (user == null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.orange[700], size: 20),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Melde dich an, um deinen Wochenplan zu speichern.',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Abbrechen'),
        ),
        FilledButton(
          onPressed: user == null || _isLoading ? null : _addToPlan,
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Hinzufügen'),
        ),
      ],
    );
  }

  Future<void> _addToPlan() async {
    setState(() => _isLoading = true);

    final success =
        await ref.read(weekplanControllerProvider.notifier).addRecipeToSlot(
              date: _selectedDate,
              slot: _selectedSlot,
              recipeId: widget.recipeId,
              servings: _servings,
            );

    if (mounted) {
      Navigator.pop(context, success);
    }
  }
}

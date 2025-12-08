import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saisonier/features/weekplan/presentation/state/weekplan_controller.dart';
import 'package:saisonier/features/weekplan/domain/date_utils.dart';

class GenerateDialog extends ConsumerStatefulWidget {
  const GenerateDialog({super.key});

  @override
  ConsumerState<GenerateDialog> createState() => _GenerateDialogState();
}

class _GenerateDialogState extends ConsumerState<GenerateDialog> {
  bool _replace = true;

  @override
  Widget build(BuildContext context) {
    final weekStart = ref.watch(selectedWeekStartProvider);
    final mealsAsync = ref.watch(weekPlannedMealsProvider);

    return AlertDialog(
      title: const Text('Einkaufsliste generieren'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Aus Wochenplan:',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 4),
          mealsAsync.when(
            data: (meals) {
              final recipeCount = meals.where((m) => m.recipeId != null).length;
              return Text(
                '${WeekplanDateUtils.formatWeekRange(weekStart)} ($recipeCount Rezepte)',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              );
            },
            loading: () => const Text('Lade...'),
            error: (_, __) => const Text('Fehler'),
          ),
          const SizedBox(height: 24),
          Text(
            'Bestehende Liste:',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          RadioGroup<bool>(
            groupValue: _replace,
            onChanged: (v) => setState(() => _replace = v!),
            child: const Column(
              children: [
                RadioListTile<bool>(
                  value: true,
                  title: Text('Ersetzen'),
                  subtitle: Text('Liste leeren und neu generieren'),
                  contentPadding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                ),
                RadioListTile<bool>(
                  value: false,
                  title: Text('Ergänzen'),
                  subtitle: Text('Zu bestehenden Items hinzufügen'),
                  contentPadding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Abbrechen'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(_replace),
          child: const Text('Generieren'),
        ),
      ],
    );
  }
}

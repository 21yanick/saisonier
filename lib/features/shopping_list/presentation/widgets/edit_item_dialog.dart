import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/database/app_database.dart';

/// Dialog for editing a shopping list item.
/// Returns the edited values as a record, or null if cancelled.
class EditItemDialog extends StatefulWidget {
  final ShoppingItem item;

  const EditItemDialog({super.key, required this.item});

  @override
  State<EditItemDialog> createState() => _EditItemDialogState();
}

class _EditItemDialogState extends State<EditItemDialog> {
  late final TextEditingController _itemController;
  late final TextEditingController _amountController;
  late final TextEditingController _unitController;
  late final TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _itemController = TextEditingController(text: widget.item.item);
    _amountController = TextEditingController(
      text: widget.item.amount != null && widget.item.amount! > 0
          ? _formatAmount(widget.item.amount!)
          : '',
    );
    _unitController = TextEditingController(text: widget.item.unit ?? '');
    _noteController = TextEditingController(text: widget.item.note ?? '');
  }

  @override
  void dispose() {
    _itemController.dispose();
    _amountController.dispose();
    _unitController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  String _formatAmount(double amount) {
    return amount == amount.roundToDouble()
        ? amount.toInt().toString()
        : amount.toString();
  }

  void _save() {
    final itemName = _itemController.text.trim();
    if (itemName.isEmpty) return;

    final amountText = _amountController.text.trim();
    final amount = amountText.isNotEmpty ? double.tryParse(amountText) : null;
    final unit = _unitController.text.trim();
    final note = _noteController.text.trim();

    Navigator.of(context).pop((
      item: itemName,
      amount: amount,
      unit: unit.isNotEmpty ? unit : null,
      note: note.isNotEmpty ? note : null,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Eintrag bearbeiten'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _itemController,
              decoration: const InputDecoration(
                labelText: 'Artikel',
                hintText: 'z.B. Tomaten',
              ),
              textCapitalization: TextCapitalization.sentences,
              autofocus: true,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _amountController,
                    decoration: const InputDecoration(
                      labelText: 'Menge',
                      hintText: 'z.B. 500',
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[\d.,]')),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _unitController,
                    decoration: const InputDecoration(
                      labelText: 'Einheit',
                      hintText: 'z.B. g',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(
                labelText: 'Notiz',
                hintText: 'z.B. Bio',
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Abbrechen'),
        ),
        FilledButton(
          onPressed: _save,
          child: const Text('Speichern'),
        ),
      ],
    );
  }
}

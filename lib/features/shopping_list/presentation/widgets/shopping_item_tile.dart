import 'package:flutter/material.dart';
import 'package:saisonier/core/database/app_database.dart';

class ShoppingItemTile extends StatelessWidget {
  final ShoppingItem item;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final VoidCallback? onEdit;

  const ShoppingItemTile({
    super.key,
    required this.item,
    required this.onToggle,
    required this.onDelete,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => onDelete(),
      child: ListTile(
        leading: Checkbox(
          value: item.isChecked,
          onChanged: (_) => onToggle(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        title: Text(
          _formatItem(),
          style: TextStyle(
            decoration: item.isChecked ? TextDecoration.lineThrough : null,
            color: item.isChecked ? Colors.grey : null,
          ),
        ),
        subtitle: item.note != null && item.note!.isNotEmpty
            ? Text(
                item.note!,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  decoration: item.isChecked ? TextDecoration.lineThrough : null,
                ),
              )
            : null,
        trailing: onEdit != null
            ? IconButton(
                icon: Icon(Icons.edit_outlined, color: Colors.grey[400], size: 20),
                onPressed: onEdit,
              )
            : null,
        onTap: onToggle,
        onLongPress: onEdit,
      ),
    );
  }

  String _formatItem() {
    final parts = <String>[];
    final amount = item.amount;

    // Only show amount if present and > 0 (0 means "nach Geschmack")
    if (amount != null && amount > 0) {
      final amountStr = amount == amount.roundToDouble()
          ? amount.toInt().toString()
          : amount.toStringAsFixed(1);
      parts.add(amountStr);

      // Only show unit if we have an amount
      final unit = item.unit;
      if (unit != null && unit.isNotEmpty) {
        parts.add(unit);
      }
    }

    parts.add(item.item);

    return parts.join(' ');
  }
}

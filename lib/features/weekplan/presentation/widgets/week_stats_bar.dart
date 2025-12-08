import 'package:flutter/material.dart';

import '../../../../core/database/app_database.dart';

/// Shows week statistics: progress bar and meal counts
class WeekStatsBar extends StatelessWidget {
  final List<PlannedMeal> meals;

  const WeekStatsBar({super.key, required this.meals});

  @override
  Widget build(BuildContext context) {
    // 7 days × 3 slots = 21 possible meals
    const totalSlots = 21;
    final filledSlots = meals.length;
    final progress = filledSlots / totalSlots;

    // Count recipes vs custom entries
    final recipeCount = meals.where((m) =>
        m.recipeId != null && m.recipeId!.isNotEmpty).length;
    final customCount = meals.where((m) =>
        m.recipeId == null || m.recipeId!.isEmpty).length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'Diese Woche',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 10),
          // Progress bar
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '$filledSlots/$totalSlots',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Counts
          Row(
            children: [
              _StatChip(
                icon: Icons.restaurant_menu,
                label: '$recipeCount Rezepte',
              ),
              const SizedBox(width: 12),
              _StatChip(
                icon: Icons.edit_note,
                label: '$customCount Eigene',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _StatChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}

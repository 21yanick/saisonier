import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saisonier/core/theme/app_theme.dart';
import 'package:saisonier/features/profile/domain/enums/profile_enums.dart';
import 'package:saisonier/features/profile/domain/models/user_profile.dart';
import 'package:saisonier/features/profile/presentation/state/user_profile_controller.dart';

/// BottomSheet zum Bearbeiten der Koch-Einstellungen
class CookingEditSheet extends ConsumerStatefulWidget {
  final UserProfile profile;

  const CookingEditSheet({super.key, required this.profile});

  static Future<void> show(BuildContext context, UserProfile profile) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CookingEditSheet(profile: profile),
    );
  }

  @override
  ConsumerState<CookingEditSheet> createState() => _CookingEditSheetState();
}

class _CookingEditSheetState extends ConsumerState<CookingEditSheet> {
  late CookingSkill _skill;
  late int _maxTime;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _skill = widget.profile.skill;
    _maxTime = widget.profile.maxCookingTimeMin;
  }

  Future<void> _save() async {
    setState(() => _saving = true);

    final updatedProfile = widget.profile.copyWith(
      skill: _skill,
      maxCookingTimeMin: _maxTime,
    );

    await ref
        .read(userProfileControllerProvider.notifier)
        .updateProfile(updatedProfile);

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  String _getTimeLabel(int minutes) {
    if (minutes >= 60) {
      final hours = minutes ~/ 60;
      final mins = minutes % 60;
      if (mins == 0) {
        return '$hours ${hours == 1 ? "Stunde" : "Stunden"}';
      }
      return '$hours:${mins.toString().padLeft(2, '0')} Std';
    }
    return '$minutes Min';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
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

              // Title
              Row(
                children: [
                  const Icon(Icons.timer, color: AppTheme.primaryGreen),
                  const SizedBox(width: 12),
                  Text(
                    'Koch-Skills',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Skill level
              Text(
                'Koch-Erfahrung',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),

              // Skill cards
              Row(
                children: CookingSkill.values.map((skill) {
                  final isSelected = _skill == skill;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _skill = skill),
                      child: Container(
                        margin: EdgeInsets.only(
                          right: skill != CookingSkill.values.last ? 8 : 0,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppTheme.primaryGreen.withValues(alpha: 0.1)
                              : Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? AppTheme.primaryGreen
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              _getSkillIcon(skill),
                              color: isSelected
                                  ? AppTheme.primaryGreen
                                  : Colors.grey[600],
                              size: 28,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              skill.label,
                              style: TextStyle(
                                color: isSelected
                                    ? AppTheme.primaryGreen
                                    : Colors.grey[700],
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                fontSize: 13,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),

              // Max cooking time
              Text(
                'Maximale Kochzeit am Abend',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  _getTimeLabel(_maxTime),
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppTheme.primaryGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Slider(
                value: _maxTime.toDouble(),
                min: 10,
                max: 120,
                divisions: 11,
                activeColor: AppTheme.primaryGreen,
                onChanged: (v) => setState(() => _maxTime = v.toInt()),
              ),

              // Time quick select
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [15, 30, 45, 60, 90].map((mins) {
                  final isSelected = _maxTime == mins;
                  return GestureDetector(
                    onTap: () => setState(() => _maxTime = mins),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.primaryGreen
                            : Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${mins}m',
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey[700],
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),

              // Save button
              SizedBox(
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
            ],
          ),
        ),
      ),
    );
  }

  IconData _getSkillIcon(CookingSkill skill) {
    switch (skill) {
      case CookingSkill.beginner:
        return Icons.egg_outlined;
      case CookingSkill.intermediate:
        return Icons.soup_kitchen_outlined;
      case CookingSkill.advanced:
        return Icons.restaurant_outlined;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saisonier/core/theme/app_theme.dart';
import 'package:saisonier/features/profile/domain/models/user_profile.dart';
import 'package:saisonier/features/profile/presentation/state/user_profile_controller.dart';

/// BottomSheet zum Bearbeiten der Haushaltsdaten
class HouseholdEditSheet extends ConsumerStatefulWidget {
  final UserProfile profile;

  const HouseholdEditSheet({super.key, required this.profile});

  static Future<void> show(BuildContext context, UserProfile profile) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => HouseholdEditSheet(profile: profile),
    );
  }

  @override
  ConsumerState<HouseholdEditSheet> createState() => _HouseholdEditSheetState();
}

class _HouseholdEditSheetState extends ConsumerState<HouseholdEditSheet> {
  late int _householdSize;
  late int _childrenCount;
  late List<int> _childrenAges;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _householdSize = widget.profile.householdSize;
    _childrenCount = widget.profile.childrenCount;
    _childrenAges = List<int>.from(widget.profile.childrenAges ?? []);

    // Ensure list has correct length
    while (_childrenAges.length < _childrenCount) {
      _childrenAges.add(5);
    }
    if (_childrenAges.length > _childrenCount) {
      _childrenAges = _childrenAges.sublist(0, _childrenCount);
    }
  }

  Future<void> _save() async {
    setState(() => _saving = true);

    final updatedProfile = widget.profile.copyWith(
      householdSize: _householdSize,
      childrenCount: _childrenCount,
      childrenAges: _childrenAges,
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
                  const Icon(Icons.house, color: AppTheme.primaryGreen),
                  const SizedBox(width: 12),
                  Text(
                    'Haushalt',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Household size
              Text(
                'Haushaltsgrösse: $_householdSize ${_householdSize == 1 ? "Person" : "Personen"}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Slider(
                value: _householdSize.toDouble(),
                min: 1,
                max: 10,
                divisions: 9,
                activeColor: AppTheme.primaryGreen,
                label: '$_householdSize',
                onChanged: (v) => setState(() => _householdSize = v.toInt()),
              ),
              const SizedBox(height: 16),

              // Children count
              Text(
                'Kinder im Haushalt: $_childrenCount',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Slider(
                value: _childrenCount.toDouble(),
                min: 0,
                max: 8,
                divisions: 8,
                activeColor: AppTheme.primaryGreen,
                label: '$_childrenCount',
                onChanged: (v) {
                  setState(() {
                    _childrenCount = v.toInt();
                    // Adjust ages list
                    while (_childrenAges.length < _childrenCount) {
                      _childrenAges.add(5);
                    }
                    if (_childrenAges.length > _childrenCount) {
                      _childrenAges = _childrenAges.sublist(0, _childrenCount);
                    }
                  });
                },
              ),

              // Children ages
              if (_childrenCount > 0) ...[
                const SizedBox(height: 16),
                Text(
                  'Alter der Kinder:',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: List.generate(_childrenCount, (index) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<int>(
                          value: _childrenAges[index],
                          items: List.generate(
                            19,
                            (age) => DropdownMenuItem(
                              value: age,
                              child: Text('$age Jahre'),
                            ),
                          ),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() => _childrenAges[index] = val);
                            }
                          },
                        ),
                      ),
                    );
                  }),
                ),
              ],
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
}

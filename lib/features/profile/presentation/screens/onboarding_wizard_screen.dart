import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saisonier/core/theme/app_theme.dart';
import 'package:saisonier/features/auth/presentation/controllers/auth_controller.dart';
import 'package:saisonier/features/profile/domain/enums/profile_enums.dart';
import 'package:saisonier/features/profile/domain/models/user_profile.dart';
import 'package:saisonier/features/profile/presentation/state/user_profile_controller.dart';

class OnboardingWizardScreen extends ConsumerStatefulWidget {
  const OnboardingWizardScreen({super.key});

  @override
  ConsumerState<OnboardingWizardScreen> createState() =>
      _OnboardingWizardScreenState();
}

class _OnboardingWizardScreenState
    extends ConsumerState<OnboardingWizardScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _initialized = false;

  // Form State
  int _householdSize = 1;
  int _childrenCount = 0;
  List<int> _childrenAges = [];
  List<Allergen> _allergens = [];
  List<String> _dislikes = []; // Preserve existing dislikes

  DietType _diet = DietType.omnivore;
  CookingSkill _skill = CookingSkill.beginner;
  int _timeMin = 30;

  @override
  void initState() {
    super.initState();
    // Load existing profile data after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadExistingProfile();
    });
  }

  void _loadExistingProfile() {
    if (_initialized) return;

    final profileAsync = ref.read(userProfileControllerProvider);
    final profile = profileAsync.valueOrNull;

    if (profile != null) {
      setState(() {
        _householdSize = profile.householdSize;
        _childrenCount = profile.childrenCount;
        _childrenAges = List<int>.from(profile.childrenAges ?? []);
        _allergens = List<Allergen>.from(profile.allergens);
        _dislikes = List<String>.from(profile.dislikes);
        _diet = profile.diet;
        _skill = profile.skill;
        _timeMin = profile.maxCookingTimeMin;
        _initialized = true;
      });
    }
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finish();
    }
  }

  Future<void> _finish() async {
    final userState = ref.read(currentUserProvider);
    final user = userState.value;
    if (user == null) return;

    // Get existing profile to preserve fields not shown in wizard (e.g., dislikes, bring)
    final existingProfile = ref.read(userProfileControllerProvider).valueOrNull;

    final profile = UserProfile(
      userId: user.id,
      householdSize: _householdSize,
      childrenCount: _childrenCount,
      childrenAges: _childrenAges,
      allergens: _allergens,
      dislikes: _dislikes, // Preserve dislikes
      diet: _diet,
      skill: _skill,
      maxCookingTimeMin: _timeMin,
      // Preserve Bring connection
      bringEmail: existingProfile?.bringEmail,
      bringListUuid: existingProfile?.bringListUuid,
    );

    await ref
        .read(userProfileControllerProvider.notifier)
        .updateProfile(profile);

    if (mounted) {
      context.go('/profile'); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dein Profil'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: (_currentPage + 1) / 3,
            backgroundColor: AppTheme.cream,
            valueColor: const AlwaysStoppedAnimation(AppTheme.primaryGreen),
          ),
        ),
      ),

      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (p) => setState(() => _currentPage = p),
        children: [
          _buildStep1Household(),
          _buildStep2Nutrition(),
          _buildStep3Cooking(),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (_currentPage > 0)
              TextButton(
                onPressed: () {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                child: const Text('Zurück'),
              )
            else
              const SizedBox.shrink(),
            ElevatedButton(
              onPressed: _nextPage,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryGreen,
                foregroundColor: Colors.white,
              ),
              child: Text(_currentPage == 2 ? 'Fertig' : 'Weiter'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep1Household() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Wie kochst du?',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 32),
          Text('Haushaltsgrösse: $_householdSize Personen'),
          Slider(
            value: _householdSize.toDouble(),
            min: 1,
            max: 10,
            divisions: 9,
            activeColor: AppTheme.primaryGreen,
            onChanged: (v) => setState(() => _householdSize = v.toInt()),
          ),
          const SizedBox(height: 32),
          const SizedBox(height: 32),
          Text('Kinder im Haushalt: $_childrenCount'),
          Slider(
            value: _childrenCount.toDouble(),
            min: 0,
            max: 8,
            divisions: 8,
             activeColor: AppTheme.primaryGreen,
            onChanged: (v) {
              setState(() {
                _childrenCount = v.toInt();
                // Adjust ages list size
                if (_childrenAges.length < _childrenCount) {
                  _childrenAges.addAll(
                    List.generate(_childrenCount - _childrenAges.length, (_) => 5),
                  );
                } else if (_childrenAges.length > _childrenCount) {
                  _childrenAges.length = _childrenCount;
                }
              });
            },
          ),
          if (_childrenCount > 0) ...[
            const SizedBox(height: 16),
            const Text('Alter der Kinder:'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(_childrenCount, (index) {
                return DropdownButton<int>(
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
                      setState(() {
                        _childrenAges[index] = val;
                      });
                    }
                  },
                );
              }),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStep2Nutrition() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ernährung',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 32),
            const Text('Ernährungsweise'),
            Wrap(
              spacing: 8,
              children: DietType.values.map((d) {
                final selected = _diet == d;
                return ChoiceChip(
                  label: Text(d.label),
                  selected: selected,
                  selectedColor: AppTheme.primaryGreen.withValues(alpha: 0.2),
                  onSelected: (s) {
                    if (s) setState(() => _diet = d);
                  },
                );

              }).toList(),
            ),
            const SizedBox(height: 32),
            const Text('Allergien / Unverträglichkeiten'),
            Wrap(
              spacing: 8,
              children: Allergen.values.map((a) {
                final selected = _allergens.contains(a);
                return FilterChip(
                  label: Text(a.label),
                  selected: selected,
                  selectedColor: AppTheme.primaryGreen.withValues(alpha: 0.2),
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
          ],
        ),
      ),
    );
  }

  Widget _buildStep3Cooking() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Deine Skills',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 32),
          const Text('Koch-Erfahrung'),
          const SizedBox(height: 16),
          SegmentedButton<CookingSkill>(
            segments: CookingSkill.values
                .map((s) => ButtonSegment(value: s, label: Text(s.label)))
                .toList(),
            selected: {_skill},
            onSelectionChanged: (s) => setState(() => _skill = s.first),
            style: ButtonStyle(
                backgroundColor: WidgetStateColor.resolveWith((states) =>
                    states.contains(WidgetState.selected)
                        ? AppTheme.primaryGreen.withValues(alpha: 0.2)
                        : Colors.transparent)),
          ),

          const SizedBox(height: 32),
          Text('Max. Zeit am Abend: $_timeMin Min.'),
          Slider(
            value: _timeMin.toDouble(),
            min: 10,
            max: 120,
            divisions: 11,
            activeColor: AppTheme.primaryGreen,
            label: '$_timeMin Min',
            onChanged: (v) => setState(() => _timeMin = v.toInt()),
          ),
        ],
      ),
    );
  }
}

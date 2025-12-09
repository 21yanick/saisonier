import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saisonier/core/theme/app_theme.dart';
import 'package:saisonier/features/profile/presentation/state/user_profile_controller.dart';
import 'package:saisonier/features/auth/presentation/controllers/auth_controller.dart';
import 'package:saisonier/features/auth/presentation/widgets/auth_form.dart';
import 'package:saisonier/features/shopping_list/presentation/state/shopping_list_controller.dart';
import 'package:saisonier/features/profile/presentation/widgets/bring_auth_dialog.dart';
import 'package:saisonier/features/profile/presentation/widgets/household_edit_sheet.dart';
import 'package:saisonier/features/profile/presentation/widgets/nutrition_edit_sheet.dart';
import 'package:saisonier/features/profile/presentation/widgets/cooking_edit_sheet.dart';
import 'package:saisonier/features/ai/presentation/controllers/ai_profile_controller.dart';

class ProfileSettingsScreen extends ConsumerWidget {
  const ProfileSettingsScreen({super.key});

  Widget _buildPremiumSection(BuildContext context, bool isPremium, bool needsOnboarding) {
    if (isPremium) {
      return ListTile(
        title: const Text('Saisonier Premium'),
        subtitle: Text(
          needsOnboarding ? 'Setup abschliessen' : 'Aktiv - AI Features freigeschaltet',
        ),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryGreen.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.auto_awesome, color: AppColors.primaryGreen),
        ),
        trailing: needsOnboarding
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Setup',
                  style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              )
            : const Icon(Icons.chevron_right),
        onTap: () => context.push('/premium-onboarding'),
      );
    }

    // Not Premium - show upgrade option
    return ListTile(
      title: const Text('Saisonier Premium'),
      subtitle: const Text('AI Rezepte, Wochenplaner & mehr'),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(Icons.lock_outline, color: Colors.grey.shade600),
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.primaryGreen,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          'Upgrade',
          style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ),
      onTap: () {
        // Show paywall or go to subscription
        _showPremiumPaywall(context);
      },
    );
  }

  void _showPremiumPaywall(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.auto_awesome, size: 40, color: AppColors.primaryGreen),
            ),
            const SizedBox(height: 24),
            Text(
              'Saisonier Premium',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              'Schalte AI-Features frei und lass dir personalisierte Rezepte generieren.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),
            _buildFeatureItem(Icons.auto_awesome, 'AI Rezept-Generator'),
            _buildFeatureItem(Icons.calendar_month, 'AI Wochenplaner'),
            _buildFeatureItem(Icons.psychology, 'Lernt deine Vorlieben'),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // TODO: Implement subscription flow
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Subscription kommt bald!')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Premium testen - CHF 5.90/Monat'),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primaryGreen),
          const SizedBox(width: 12),
          Text(text),
        ],
      ),
    );
  }

  String _buildNutritionSubtitle(profile) {
    final parts = <String>[];
    parts.add(profile.diet.label);

    if (profile.allergens.isNotEmpty) {
      parts.add('${profile.allergens.length} Allergien');
    }

    if (profile.dislikes.isNotEmpty) {
      parts.add('${profile.dislikes.length} Dislikes');
    }

    if (profile.allergens.isEmpty && profile.dislikes.isEmpty) {
      parts.add('Keine Einschränkungen');
    }

    return parts.join(' • ');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);
    final profileAsync = ref.watch(userProfileControllerProvider);
    final bringConnectedAsync = ref.watch(shoppingListControllerProvider);
    final isPremiumUser = ref.watch(isPremiumProvider);
    final needsOnboarding = ref.watch(needsOnboardingProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil & Einstellungen'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: userAsync.when(
        data: (user) {
          if (user == null) {
            return const AuthForm();
          }
          // User is logged in, show profile settings
          return profileAsync.when(
            data: (profile) {
              if (profile == null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Kein Profil gefunden.'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => context.push('/profile/setup'),
                        child: const Text('Profil erstellen'),
                      ),
                      const SizedBox(height: 32),
                      TextButton.icon(
                         onPressed: () {
                           ref.read(authControllerProvider.notifier).logout();
                         },
                         icon: const Icon(Icons.logout, color: Colors.red),
                         label: const Text('Abmelden', style: TextStyle(color: Colors.red)),
                      )
                    ],
                  ),
                );
              }
              return ListView(
                children: [
                  ListTile(
                    title: const Text('Haushalt'),
                    subtitle: Text(
                        '${profile.householdSize} ${profile.householdSize == 1 ? "Person" : "Personen"}${profile.childrenCount > 0 ? ", ${profile.childrenCount} Kinder" : ""}'),
                    leading: const Icon(Icons.house),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => HouseholdEditSheet.show(context, profile),
                  ),
                  ListTile(
                    title: const Text('Ernährung'),
                    subtitle: Text(_buildNutritionSubtitle(profile)),
                    leading: const Icon(Icons.restaurant),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => NutritionEditSheet.show(context, profile),
                  ),
                  ListTile(
                    title: const Text('Koch-Skills'),
                    subtitle:
                        Text('${profile.skill.label} • Max. ${profile.maxCookingTimeMin} Min'),
                    leading: const Icon(Icons.timer),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => CookingEditSheet.show(context, profile),
                  ),
                  const Divider(),
                  // Premium Section
                  _buildPremiumSection(context, isPremiumUser, needsOnboarding),
                  const Divider(),
                  bringConnectedAsync.when(
                    data: (isConnected) => ListTile(
                      title: const Text('Bring! Einkaufsliste'),
                      subtitle: Text(isConnected ? 'Verbunden' : 'Nicht verbunden'),
                      leading: Icon(
                        Icons.shopping_cart, 
                        color: isConnected ? Colors.green : null
                      ),
                      trailing: isConnected 
                        ? IconButton(
                            icon: const Icon(Icons.link_off),
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Trennen?'),
                                  content: const Text('Möchtest du die Verbindung zu Bring! trennen?'),
                                  actions: [
                                    TextButton(onPressed: () => context.pop(false), child: const Text('Abbrechen')),
                                    TextButton(onPressed: () => context.pop(true), child: const Text('Trennen')),
                                  ],
                                ),
                              );
                              if (confirm == true) {
                                ref.read(shoppingListControllerProvider.notifier).logout();
                              }
                            },
                          )
                        : null,
                      onTap: isConnected ? null : () {
                        showDialog(
                          context: context,
                          builder: (context) => const BringAuthDialog(),
                        );
                      },
                    ),
                    loading: () => const ListTile(
                      title: Text('Bring! Einkaufsliste'),
                      leading: Icon(Icons.shopping_cart),
                      trailing: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                    ),
                    error: (err, stack) => ListTile(
                      title: const Text('Fehler bei Bring! Integration'),
                      subtitle: Text(err.toString(), style: const TextStyle(color: Colors.red)),
                      leading: const Icon(Icons.error, color: Colors.red),
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text('Abmelden'),
                    leading: const Icon(Icons.logout, color: Colors.red),
                    onTap: () {
                      ref.read(authControllerProvider.notifier).logout();
                      context.go('/profile'); 
                    },
                  ),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Fehler: $err')),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Fehler: $err')),
      ),
    );
  }
}

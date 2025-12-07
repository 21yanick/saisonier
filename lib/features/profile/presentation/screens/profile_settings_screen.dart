import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saisonier/features/profile/presentation/state/user_profile_controller.dart';
import 'package:saisonier/features/auth/presentation/controllers/auth_controller.dart';
import 'package:saisonier/features/auth/presentation/widgets/auth_form.dart';
import 'package:saisonier/features/shopping_list/presentation/state/shopping_list_controller.dart';
import 'package:saisonier/features/profile/presentation/widgets/bring_auth_dialog.dart';

class ProfileSettingsScreen extends ConsumerWidget {
  const ProfileSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);
    final profileAsync = ref.watch(userProfileControllerProvider);
    final bringConnectedAsync = ref.watch(shoppingListControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil & Einstellungen'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.go('/feed'),
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
                        '${profile.householdSize} Personen, ${profile.childrenCount} Kinder'),
                    leading: const Icon(Icons.house),
                    onTap: () => context.push('/profile/setup'),
                  ),
                  ListTile(
                    title: const Text('Ernährung'),
                    subtitle: Text(
                        '${profile.diet.label} • ${profile.allergens.isEmpty ? "Keine Allergien" : "${profile.allergens.length} Allergien"}'),
                    leading: const Icon(Icons.restaurant),
                    onTap: () => context.push('/profile/setup'),
                  ),
                  ListTile(
                    title: const Text('Koch-Skills'),
                    subtitle:
                        Text('${profile.skill.label} • Max. ${profile.maxCookingTimeMin} Min'),
                    leading: const Icon(Icons.timer),
                    onTap: () => context.push('/profile/setup'),
                  ),
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saisonier/features/profile/presentation/state/user_profile_controller.dart';
import 'package:saisonier/features/auth/presentation/controllers/auth_controller.dart';
import 'package:saisonier/features/auth/presentation/widgets/auth_form.dart';

class ProfileSettingsScreen extends ConsumerWidget {
  const ProfileSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);
    final profileAsync = ref.watch(userProfileControllerProvider);

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

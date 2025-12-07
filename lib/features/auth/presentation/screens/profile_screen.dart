import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
import 'package:saisonier/features/auth/presentation/controllers/auth_controller.dart';
import 'package:pocketbase/pocketbase.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      if (_isLogin) {
        await ref.read(authControllerProvider.notifier).login(email, password);
      } else {
        await ref.read(authControllerProvider.notifier).register(email, password);
      }

      // Check for errors
      final state = ref.read(authControllerProvider);
      if (state.hasError && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.error.toString()),
            backgroundColor: Colors.red,
          ),
        );
      } else if (!state.isLoading && mounted) {
        // Success message if needed, or rely on UI update
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(currentUserProvider);
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: userAsync.when(
        data: (user) {
          if (user != null) {
            return _buildProfileView(user, authState.isLoading);
          }
          return _buildAuthForm(authState.isLoading);
        },
        error: (err, stack) => Center(child: Text('Error: $err')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _buildProfileView(RecordModel user, bool isLoading) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundColor: Color(0xFFA6C48A), // Saisonier Green
            child: Icon(Icons.person, size: 50, color: Colors.white),
          ),
          const SizedBox(height: 24),
          Text(
            'Hallo!',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            user.data['email'] ?? '',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 48),
          if (isLoading)
            const CircularProgressIndicator()
          else
            ElevatedButton.icon(
              onPressed: () {
                ref.read(authControllerProvider.notifier).logout();
              },
              icon: const Icon(Icons.logout),
              label: const Text('Abmelden'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.red,
                backgroundColor: Colors.red.withValues(alpha: 0.1),
                elevation: 0,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAuthForm(bool isLoading) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              _isLogin ? 'Willkommen zurück' : 'Account erstellen',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Synchronsiere deine Favoriten über alle Geräte.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 32),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email_outlined),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty || !value.contains('@')) {
                  return 'Bitte gültige Email eingeben';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Passwort',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock_outline),
              ),
              obscureText: true,
              validator: (value) {
                if (value == null || value.length < 8) {
                  return 'Mindestens 8 Zeichen';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFA6C48A), // Saisonier Green
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  _isLogin ? 'Anmelden' : 'Registrieren',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                setState(() {
                  _isLogin = !_isLogin;
                });
              },
              child: Text(
                _isLogin
                    ? 'Noch keinen Account? Jetzt registrieren'
                    : 'Bereits einen Account? Anmelden',
                style: const TextStyle(color: Colors.black87),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

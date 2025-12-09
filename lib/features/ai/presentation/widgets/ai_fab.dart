import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saisonier/core/theme/app_theme.dart';
import 'package:saisonier/features/ai/presentation/controllers/ai_profile_controller.dart';

/// AI Floating Action Button that appears on screens with AI features.
/// Shows locked state for non-Premium users, opens context-specific modals.
class AIFab extends ConsumerWidget {
  final VoidCallback onPressed;
  final VoidCallback? onLockedPressed;
  final bool isLoading;
  final String? label;

  const AIFab({
    super.key,
    required this.onPressed,
    this.onLockedPressed,
    this.isLoading = false,
    this.label,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPremiumUser = ref.watch(isPremiumProvider);

    if (!isPremiumUser) {
      return _LockedFab(
        onPressed: onLockedPressed ?? () => _showPaywall(context),
        label: label,
      );
    }

    return _UnlockedFab(
      onPressed: isLoading ? null : onPressed,
      isLoading: isLoading,
      label: label,
    );
  }

  void _showPaywall(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _PaywallSheet(),
    );
  }
}

class _UnlockedFab extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;
  final String? label;

  const _UnlockedFab({
    required this.onPressed,
    required this.isLoading,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    if (label != null) {
      return FloatingActionButton.extended(
        onPressed: onPressed,
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        icon: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Icon(Icons.auto_awesome),
        label: Text(label!),
      );
    }

    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: AppColors.primaryGreen,
      foregroundColor: Colors.white,
      child: isLoading
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : const Icon(Icons.auto_awesome),
    );
  }
}

class _LockedFab extends StatelessWidget {
  final VoidCallback onPressed;
  final String? label;

  const _LockedFab({
    required this.onPressed,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    if (label != null) {
      return FloatingActionButton.extended(
        onPressed: onPressed,
        backgroundColor: Colors.grey.shade400,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.lock_outline),
        label: Text(label!),
      );
    }

    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: Colors.grey.shade400,
      foregroundColor: Colors.white,
      child: const Icon(Icons.lock_outline),
    );
  }
}

class _PaywallSheet extends StatelessWidget {
  const _PaywallSheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          const SizedBox(height: 24),

          // Icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_awesome,
              size: 40,
              color: AppColors.primaryGreen,
            ),
          ),

          const SizedBox(height: 24),

          // Title
          Text(
            'AI Features freischalten',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),

          const SizedBox(height: 12),

          // Description
          Text(
            'Mit Saisonier Premium erhältst du deinen persönlichen AI Chef, der Wochenpläne erstellt und Rezepte generiert - basierend auf deinen Vorlieben und saisonalem Gemüse.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade600,
                ),
          ),

          const SizedBox(height: 32),

          // Features list
          const _FeatureRow(
            icon: Icons.calendar_month,
            text: 'AI Wochenplaner',
          ),
          const _FeatureRow(
            icon: Icons.restaurant_menu,
            text: 'AI Rezept-Generator',
          ),
          const _FeatureRow(
            icon: Icons.psychology,
            text: 'Lernt deine Vorlieben',
          ),
          const _FeatureRow(
            icon: Icons.image,
            text: '10 AI-Bilder pro Monat',
          ),

          const SizedBox(height: 32),

          // CTA Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // TODO: Navigate to subscription screen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Premium testen',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Price info
          Text(
            'CHF 5.90 / Monat',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade500,
                ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _FeatureRow({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: AppColors.primaryGreen,
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:saisonier/core/theme/app_theme.dart';

class WelcomeStep extends StatelessWidget {
  final VoidCallback onGetStarted;
  final VoidCallback onSkip;

  const WelcomeStep({
    super.key,
    required this.onGetStarted,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),

          // Icon
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                '🎉',
                style: TextStyle(fontSize: 64),
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Title
          Text(
            'Willkommen bei Premium!',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          // Subtitle
          Text(
            'Lass uns deinen persönlichen AI Chef einrichten.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey.shade600,
                ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          Text(
            'Je mehr ich über dich weiss, desto besser werden meine Vorschläge.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade500,
                ),
            textAlign: TextAlign.center,
          ),

          const Spacer(),

          // Buttons
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onGetStarted,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Los geht\'s',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),

          const SizedBox(height: 12),

          TextButton(
            onPressed: onSkip,
            child: Text(
              'Später',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

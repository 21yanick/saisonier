import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saisonier/features/seasonality/data/repositories/recipe_repository.dart';
import 'package:saisonier/features/seasonality/data/repositories/vegetable_repository.dart';
import 'package:saisonier/features/auth/application/auth_sync_service.dart';
import 'package:saisonier/features/auth/presentation/controllers/auth_controller.dart';

class MainScreen extends ConsumerStatefulWidget {
  final StatefulNavigationShell navigationShell;

  const MainScreen({
    super.key,
    required this.navigationShell,
  });

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  @override
  void initState() {
    super.initState();
    // Trigger Sync on app start
    // We intentionally don't await here to not block UI
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(vegetableRepositoryProvider).sync();
      ref.read(recipeRepositoryProvider).sync();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Listen for auth state changes to trigger Sync upon session restore
    ref.listen(currentUserProvider, (previous, next) {
      if (next.value != null && (previous?.value == null)) {
        // User just became active (login or startup restore)
        // Ensure sync runs
        ref.read(authSyncServiceProvider).syncOnLogin(next.value!);
      }
    });

    return Scaffold(
      // The body is the current branch of the StatefulShellRoute
      body: Stack(
        children: [
          // Content Layer
          widget.navigationShell,

          // Floating Toggle Pill Layer (Bottom Center)
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: _TogglePill(
                currentIndex: widget.navigationShell.currentIndex,
                onTap: (index) => _onTap(context, index),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onTap(BuildContext context, int index) {
    // When navigating to the same branch, go to the root of that branch
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }
}

class _TogglePill extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const _TogglePill({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1), // Fixed deprecation
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Animated Selection Background
          AnimatedAlign(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            alignment: currentIndex == 0 ? Alignment.centerLeft : Alignment.centerRight,
            child: Container(
              margin: const EdgeInsets.all(4),
              width: 96, // (200 - 8) / 2
              decoration: BoxDecoration(
                color: const Color(0xFF4A6C48), // Theme Seed Color
                borderRadius: BorderRadius.circular(21),
              ),
            ),
          ),
          
          // Row of Buttons
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onTap(0),
                  child: Center(
                    child: Text(
                      'Saison',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: currentIndex == 0 ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onTap(1),
                  child: Center(
                    child: Text(
                      'Katalog',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: currentIndex == 1 ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

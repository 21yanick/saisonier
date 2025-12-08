import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saisonier/features/seasonality/data/repositories/recipe_repository.dart';
import 'package:saisonier/features/seasonality/data/repositories/vegetable_repository.dart';
import 'package:saisonier/features/auth/application/auth_sync_service.dart';
import 'package:saisonier/features/auth/presentation/controllers/auth_controller.dart';
import 'package:saisonier/features/weekplan/presentation/state/weekplan_controller.dart';

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
        // Sync week plan data
        ref.read(weekplanControllerProvider.notifier).sync();
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

  static const _labels = ['Saison', 'Katalog', 'Rezepte', 'Plan'];
  static const _pillWidth = 320.0;
  static const _segmentCount = 4;
  static const _segmentWidth = (_pillWidth - 8) / _segmentCount;

  @override
  Widget build(BuildContext context) {
    const segmentWidth = _segmentWidth;

    return Container(
      height: 50,
      width: _pillWidth,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Animated Selection Background
          AnimatedPositioned(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            left: 4 + (currentIndex * segmentWidth),
            top: 4,
            bottom: 4,
            width: segmentWidth,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF4A6C48),
                borderRadius: BorderRadius.circular(21),
              ),
            ),
          ),

          // Row of Buttons
          Row(
            children: List.generate(_segmentCount, (index) {
              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onTap(index),
                  child: Center(
                    child: Text(
                      _labels[index],
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: currentIndex == index ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saisonier/features/seasonality/data/repositories/recipe_repository.dart';
import 'package:saisonier/features/seasonality/data/repositories/vegetable_repository.dart';
import 'package:saisonier/features/auth/application/auth_sync_service.dart';
import 'package:saisonier/features/auth/presentation/controllers/auth_controller.dart';
import 'package:saisonier/features/weekplan/presentation/state/weekplan_controller.dart';

import 'feed_screen.dart';
import 'grid_screen.dart';
import '../../../recipes/presentation/screens/my_recipes_screen.dart';
import '../../../weekplan/presentation/screens/weekplan_screen.dart';
import '../../../shopping_list/presentation/screens/shopping_list_screen.dart';

/// Provider für den aktuellen Page-Index (0-4)
/// 0 = Feed, 1 = Katalog, 2 = Rezepte, 3 = Plan, 4 = Einkauf
final mainPageIndexProvider = StateProvider<int>((ref) => 0);

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    // Read initial page from provider (allows deep-linking back to specific page)
    _pageController = PageController(initialPage: ref.read(mainPageIndexProvider));

    // Trigger Sync on app start
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(vegetableRepositoryProvider).sync();
      ref.read(recipeRepositoryProvider).sync();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    ref.read(mainPageIndexProvider.notifier).state = index;
  }

  void _goToPage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Listen for auth state changes to trigger Sync upon session restore
    ref.listen(currentUserProvider, (previous, next) {
      if (next.value != null && (previous?.value == null)) {
        ref.read(authSyncServiceProvider).syncOnLogin(next.value!);
        ref.read(weekplanControllerProvider.notifier).sync();
      }
    });

    // Listen for external page changes (z.B. von anderen Screens)
    ref.listen(mainPageIndexProvider, (previous, next) {
      if (_pageController.hasClients &&
          _pageController.page?.round() != next) {
        _goToPage(next);
      }
    });

    final currentPage = ref.watch(mainPageIndexProvider);
    final isFeedOrKatalog = currentPage <= 1;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            currentPage == 0 ? Brightness.light : Brightness.dark,
        statusBarBrightness:
            currentPage == 0 ? Brightness.dark : Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: currentPage == 0 ? Colors.black : null,
        body: Stack(
          children: [
            // Main PageView mit allen 5 Screens
            PageView(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              children: const [
                FeedScreen(),
                GridScreen(),
                MyRecipesScreen(),
                WeekplanScreen(),
                ShoppingListScreen(),
              ],
            ),

            // Mini-Toggle (nur bei Feed oder Katalog)
            if (isFeedOrKatalog)
              Positioned(
                top: MediaQuery.of(context).padding.top + 8,
                left: 0,
                right: 0,
                child: Center(
                  child: _MiniToggle(
                    currentIndex: currentPage, // 0 = Feed, 1 = Katalog
                    onTap: _goToPage,
                    isFeedView: currentPage == 0,
                  ),
                ),
              ),

            // Floating Toggle Pill (Bottom Center)
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: Center(
                child: _TogglePill(
                  currentPage: currentPage,
                  onTap: (pillIndex) {
                    // Pill 0 (Saison) → Page 0 (Feed) wenn nicht schon im Saison-Bereich
                    // Pill 1 (Rezepte) → Page 2
                    // Pill 2 (Plan) → Page 3
                    // Pill 3 (Einkauf) → Page 4
                    int targetPage;
                    if (pillIndex == 0) {
                      // Wenn bereits im Saison-Bereich (Feed/Katalog), bleib dort
                      // Sonst geh zum Feed
                      targetPage = currentPage <= 1 ? currentPage : 0;
                    } else {
                      targetPage = pillIndex + 1;
                    }
                    _goToPage(targetPage);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Mini-Toggle für Feed/Katalog Wechsel
class _MiniToggle extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final bool isFeedView;

  const _MiniToggle({
    required this.currentIndex,
    required this.onTap,
    required this.isFeedView,
  });

  static const _width = 140.0;
  static const _height = 36.0;

  @override
  Widget build(BuildContext context) {
    const segmentWidth = (_width - 6) / 2;

    return Container(
      height: _height,
      width: _width,
      decoration: BoxDecoration(
        color: isFeedView
            ? Colors.white.withValues(alpha: 0.15)
            : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(_height / 2),
      ),
      child: Stack(
        children: [
          // Animated selection background
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            left: 3 + (currentIndex * segmentWidth),
            top: 3,
            bottom: 3,
            width: segmentWidth,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF4A6C48),
                borderRadius: BorderRadius.circular((_height - 6) / 2),
              ),
            ),
          ),

          // Buttons
          Row(
            children: [
              _buildSegment(0, Icons.auto_awesome, 'Feed'),
              _buildSegment(1, Icons.grid_view_rounded, 'Katalog'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSegment(int index, IconData icon, String tooltip) {
    final isSelected = currentIndex == index;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onTap(index),
        child: Tooltip(
          message: tooltip,
          child: Center(
            child: Icon(
              icon,
              size: 18,
              color: isSelected
                  ? Colors.white
                  : (isFeedView ? Colors.white70 : Colors.black54),
            ),
          ),
        ),
      ),
    );
  }
}

/// Haupt-Pill Navigation (4 Segmente für 5 Pages)
class _TogglePill extends StatelessWidget {
  final int currentPage;
  final Function(int) onTap;

  const _TogglePill({
    required this.currentPage,
    required this.onTap,
  });

  static const _labels = ['Saison', 'Rezepte', 'Plan', 'Einkauf'];
  static const _pillWidth = 320.0;
  static const _segmentCount = 4;
  static const _segmentWidth = (_pillWidth - 8) / _segmentCount;

  /// Mappt Page-Index (0-4) auf Pill-Index (0-3)
  /// Page 0,1 (Feed/Katalog) → Pill 0 (Saison)
  /// Page 2 (Rezepte) → Pill 1
  /// Page 3 (Plan) → Pill 2
  /// Page 4 (Einkauf) → Pill 3
  int get _activePillIndex => currentPage <= 1 ? 0 : currentPage - 1;

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
            left: 4 + (_activePillIndex * segmentWidth),
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
                        color: _activePillIndex == index
                            ? Colors.white
                            : Colors.black87,
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

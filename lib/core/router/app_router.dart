import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:saisonier/features/seasonality/presentation/screens/feed_screen.dart';
import 'package:saisonier/features/seasonality/presentation/screens/grid_screen.dart';
import 'package:saisonier/features/seasonality/presentation/screens/main_screen.dart';
import 'package:saisonier/features/seasonality/presentation/screens/detail_screen.dart';
import '../../features/seasonality/presentation/screens/recipe_detail_screen.dart';
import '../../features/auth/presentation/screens/profile_screen.dart';

// Private navigator keys
final _rootNavigatorKey = GlobalKey<NavigatorState>();


final appRouter = GoRouter(
  initialLocation: '/feed',
  navigatorKey: _rootNavigatorKey,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainScreen(navigationShell: navigationShell);
      },
      branches: [
        // Branch 1: Feed
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/feed',
              builder: (context, state) => const FeedScreen(),
            ),
          ],
        ),
        // Branch 2: Grid
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/grid',
              builder: (context, state) => const GridScreen(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/details/:id',
      parentNavigatorKey: _rootNavigatorKey, // Overlay the shell
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return DetailScreen(vegetableId: id);
      },
    ),
    // Recipe Detail Route
    GoRoute(
      path: '/recipes/:id',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return RecipeDetailScreen(recipeId: id);
      },
    ),
    // Profile Route
    GoRoute(
      path: '/profile',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ProfileScreen(),
    ),
  ],
);

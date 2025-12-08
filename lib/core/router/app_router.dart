import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:saisonier/features/seasonality/presentation/screens/feed_screen.dart';
import 'package:saisonier/features/seasonality/presentation/screens/grid_screen.dart';
import 'package:saisonier/features/seasonality/presentation/screens/main_screen.dart';
import 'package:saisonier/features/seasonality/presentation/screens/detail_screen.dart';
import '../../features/seasonality/presentation/screens/recipe_detail_screen.dart';
import 'package:saisonier/features/profile/presentation/screens/profile_settings_screen.dart';
import 'package:saisonier/features/profile/presentation/screens/onboarding_wizard_screen.dart';
import 'package:saisonier/features/recipes/presentation/screens/my_recipes_screen.dart';
import 'package:saisonier/features/recipes/presentation/screens/recipe_editor_screen.dart';
import 'package:saisonier/features/weekplan/presentation/screens/weekplan_screen.dart';

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
        // Branch 3: My Recipes
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/my-recipes',
              builder: (context, state) => const MyRecipesScreen(),
            ),
          ],
        ),
        // Branch 4: Week Plan
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/weekplan',
              builder: (context, state) => const WeekplanScreen(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/details/:id',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return DetailScreen(vegetableId: id);
      },
    ),
    // Recipe Editor - MUST come before /recipes/:id to avoid "new" being matched as :id
    GoRoute(
      path: '/recipes/new',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const RecipeEditorScreen(),
    ),
    GoRoute(
      path: '/recipes/:id/edit',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return RecipeEditorScreen(recipeId: id);
      },
    ),
    // Recipe Detail Route - parametrized route last
    GoRoute(
      path: '/recipes/:id',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return RecipeDetailScreen(recipeId: id);
      },
    ),
    // Profile Route (Main Settings)
    GoRoute(
      path: '/profile',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ProfileSettingsScreen(),
      routes: [
        GoRoute(
          path: 'setup',
          builder: (context, state) => const OnboardingWizardScreen(),
        ),
      ],
    ),
  ],
);

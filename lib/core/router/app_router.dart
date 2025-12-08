import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:saisonier/features/seasonality/presentation/screens/main_screen.dart';
import 'package:saisonier/features/seasonality/presentation/screens/detail_screen.dart';
import '../../features/seasonality/presentation/screens/recipe_detail_screen.dart';
import 'package:saisonier/features/profile/presentation/screens/profile_settings_screen.dart';
import 'package:saisonier/features/profile/presentation/screens/onboarding_wizard_screen.dart';
import 'package:saisonier/features/recipes/presentation/screens/recipe_editor_screen.dart';

// Private navigator keys
final _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  initialLocation: '/',
  navigatorKey: _rootNavigatorKey,
  routes: [
    // Main Screen mit PageView (Feed, Katalog, Rezepte, Plan, Einkauf)
    GoRoute(
      path: '/',
      builder: (context, state) => const MainScreen(),
    ),

    // Modal Routes (über dem MainScreen)
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
        final servingsParam = state.uri.queryParameters['servings'];
        final initialServings =
            servingsParam != null ? int.tryParse(servingsParam) : null;
        return RecipeDetailScreen(
          recipeId: id,
          initialServings: initialServings,
        );
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

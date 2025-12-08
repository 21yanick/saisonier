import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/database/app_database.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../data/repositories/weekplan_repository.dart';
import '../../domain/enums.dart';

part 'weekplan_controller.g.dart';

/// Provider for the currently selected week's start date (Monday)
@riverpod
class SelectedWeekStart extends _$SelectedWeekStart {
  @override
  DateTime build() {
    final now = DateTime.now();
    // Get Monday of current week
    return DateTime(now.year, now.month, now.day - (now.weekday - 1));
  }

  void goToWeek(DateTime date) {
    // Normalize to Monday of that week
    state = DateTime(date.year, date.month, date.day - (date.weekday - 1));
  }

  void nextWeek() {
    state = state.add(const Duration(days: 7));
  }

  void previousWeek() {
    state = state.subtract(const Duration(days: 7));
  }

  void goToToday() {
    final now = DateTime.now();
    state = DateTime(now.year, now.month, now.day - (now.weekday - 1));
  }
}

/// Provider for planned meals of the selected week
@riverpod
Stream<List<PlannedMeal>> weekPlannedMeals(Ref ref) {
  final user = ref.watch(currentUserProvider).valueOrNull;
  if (user == null) {
    return Stream.value([]);
  }

  final weekStart = ref.watch(selectedWeekStartProvider);
  return ref.watch(weekplanRepositoryProvider).watchWeek(user.id, weekStart);
}

/// Controller for week plan actions
@riverpod
class WeekplanController extends _$WeekplanController {
  @override
  FutureOr<void> build() {}

  Future<bool> addRecipeToSlot({
    required DateTime date,
    required MealSlot slot,
    required String recipeId,
    int servings = 2,
  }) async {
    final user = ref.read(currentUserProvider).valueOrNull;
    if (user == null) return false;

    try {
      await ref.read(weekplanRepositoryProvider).addRecipeToSlot(
            userId: user.id,
            date: date,
            slot: slot,
            recipeId: recipeId,
            servings: servings,
          );
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> addCustomEntry({
    required DateTime date,
    required MealSlot slot,
    required String customTitle,
    int servings = 2,
  }) async {
    final user = ref.read(currentUserProvider).valueOrNull;
    if (user == null) return false;

    try {
      await ref.read(weekplanRepositoryProvider).addCustomEntry(
            userId: user.id,
            date: date,
            slot: slot,
            customTitle: customTitle,
            servings: servings,
          );
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> removeMeal(String id) async {
    try {
      await ref.read(weekplanRepositoryProvider).removeMeal(id);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> updateServings(String id, int servings) async {
    try {
      await ref.read(weekplanRepositoryProvider).updateServings(id, servings);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> sync() async {
    final user = ref.read(currentUserProvider).valueOrNull;
    if (user == null) return;
    await ref.read(weekplanRepositoryProvider).sync(user.id);
  }
}

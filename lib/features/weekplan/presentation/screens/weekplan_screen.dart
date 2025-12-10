import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../ai/presentation/widgets/ai_fab.dart';
import '../../../ai/presentation/widgets/weekplan_ai_modal.dart';
import '../../../ai/presentation/screens/smart_weekplan_screen.dart';
import '../../domain/enums.dart';
import '../screens/add_meal_sheet.dart';
import '../state/weekplan_controller.dart';
import '../views/week_overview_view.dart';
import '../widgets/day_detail_sheet.dart';

class WeekplanScreen extends ConsumerStatefulWidget {
  const WeekplanScreen({super.key});

  @override
  ConsumerState<WeekplanScreen> createState() => _WeekplanScreenState();
}

class _WeekplanScreenState extends ConsumerState<WeekplanScreen> {
  void _showDayDetail(DateTime date) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DayDetailSheet(
        initialDate: date,
      ),
    );
  }

  void _openAddMealSheet(DateTime date, MealSlot slot) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddMealSheet(
        date: date,
        slot: slot,
      ),
    );
  }

  void _openAIModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => WeekplanAIModal(
        onPlanGenerated: (response) {
          Navigator.of(context).pop();
          _showPreviewScreen(response);
        },
      ),
    );
  }

  void _showPreviewScreen(dynamic response) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SmartWeekplanScreen(
          response: response,
          onRegenerate: () {
            Navigator.of(context).pop();
            _openAIModal();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wochenplan'),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => context.push('/profile'),
          ),
        ],
      ),
      body: userAsync.when(
        data: (user) {
          if (user == null) {
            return _buildLoginPrompt(context);
          }
          return _WeekplanContent(
            onDayTap: _showDayDetail,
            onAddMeal: _openAddMealSheet,
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Fehler: $e')),
      ),
      floatingActionButton: userAsync.maybeWhen(
        data: (user) {
          if (user == null) return null;
          return Padding(
            padding: const EdgeInsets.only(bottom: 72),
            child: AIFab(
              onPressed: _openAIModal,
              label: 'AI Planer',
            ),
          );
        },
        orElse: () => null,
      ),
    );
  }

  Widget _buildLoginPrompt(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_month_outlined, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 24),
            Text(
              'Dein Wochenplan',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Melde dich an, um deine Mahlzeiten zu planen und den Überblick zu behalten.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: () => context.push('/profile'),
              icon: const Icon(Icons.login),
              label: const Text('Anmelden'),
            ),
          ],
        ),
      ),
    );
  }
}

class _WeekplanContent extends ConsumerWidget {
  final void Function(DateTime date) onDayTap;
  final void Function(DateTime date, MealSlot slot) onAddMeal;

  const _WeekplanContent({
    required this.onDayTap,
    required this.onAddMeal,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mealsAsync = ref.watch(scrollCalendarMealsProvider);

    return mealsAsync.when(
      data: (meals) => WeekOverviewView(
        meals: meals,
        onDayTap: onDayTap,
        onAddMeal: onAddMeal,
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Fehler: $e')),
    );
  }
}

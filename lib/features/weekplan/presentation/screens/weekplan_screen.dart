import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/presentation/controllers/auth_controller.dart';
import '../state/weekplan_controller.dart';
import '../views/week_overview_view.dart';
import '../views/day_detail_view.dart';

class WeekplanScreen extends ConsumerStatefulWidget {
  const WeekplanScreen({super.key});

  @override
  ConsumerState<WeekplanScreen> createState() => _WeekplanScreenState();
}

class _WeekplanScreenState extends ConsumerState<WeekplanScreen> {
  // null = overview, otherwise = day index (0-6) for detail view
  int? _selectedDayIndex;

  void _showDayDetail(DateTime date) {
    final weekStart = ref.read(selectedWeekStartProvider);
    final dayIndex = date.difference(weekStart).inDays;
    setState(() => _selectedDayIndex = dayIndex.clamp(0, 6));
  }

  void _backToOverview() {
    setState(() => _selectedDayIndex = null);
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(currentUserProvider);

    return PopScope(
      canPop: _selectedDayIndex == null, // Only pop if in overview
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _selectedDayIndex != null) {
          _backToOverview();
        }
      },
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Wochenplan'),
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark,
              statusBarBrightness: Brightness.light,
            ),
            leading: _selectedDayIndex != null
                ? IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: _backToOverview,
                  )
                : null,
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
              selectedDayIndex: _selectedDayIndex,
              onDayTap: _showDayDetail,
              onBack: _backToOverview,
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Fehler: $e')),
          ),
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
  final int? selectedDayIndex;
  final void Function(DateTime date) onDayTap;
  final VoidCallback onBack;

  const _WeekplanContent({
    required this.selectedDayIndex,
    required this.onDayTap,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weekStart = ref.watch(selectedWeekStartProvider);
    final mealsAsync = ref.watch(weekPlannedMealsProvider);

    return mealsAsync.when(
      data: (meals) {
        // Detail view
        if (selectedDayIndex != null) {
          return DayDetailView(
            weekStart: weekStart,
            initialDayIndex: selectedDayIndex!,
            meals: meals,
            onBack: onBack,
          );
        }

        // Overview
        return WeekOverviewView(
          weekStart: weekStart,
          meals: meals,
          onDayTap: onDayTap,
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Fehler: $e')),
    );
  }
}

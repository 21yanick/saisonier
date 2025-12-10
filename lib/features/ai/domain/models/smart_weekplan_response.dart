import 'package:freezed_annotation/freezed_annotation.dart';

part 'smart_weekplan_response.freezed.dart';
part 'smart_weekplan_response.g.dart';

/// Response from smart weekplan generation.
@freezed
class SmartWeekplanResponse with _$SmartWeekplanResponse {
  const factory SmartWeekplanResponse({
    required ContextAnalysis contextAnalysis,
    required List<PlannedDay> weekplan,
    required Map<String, dynamic> recipes,
    required StrategyInsights strategy,
    @Default(0) int eligibleRecipeCount,
  }) = _SmartWeekplanResponse;

  factory SmartWeekplanResponse.fromJson(Map<String, dynamic> json) =>
      _$SmartWeekplanResponseFromJson(json);
}

/// AI's analysis of the user's week context.
@freezed
class ContextAnalysis with _$ContextAnalysis {
  const factory ContextAnalysis({
    @Default({}) Map<String, String> timeConstraints,
    @Default({}) Map<String, EventInfo> events,
    @Default([]) List<String> ingredientsToUse,
    String? displaySummary,
  }) = _ContextAnalysis;

  factory ContextAnalysis.fromJson(Map<String, dynamic> json) =>
      _$ContextAnalysisFromJson(json);
}

/// Event information for a specific day.
@freezed
class EventInfo with _$EventInfo {
  const factory EventInfo({
    required String type,
    int? guestCount,
  }) = _EventInfo;

  factory EventInfo.fromJson(Map<String, dynamic> json) =>
      _$EventInfoFromJson(json);
}

/// A planned day in the weekplan.
@freezed
class PlannedDay with _$PlannedDay {
  const factory PlannedDay({
    required String date,
    required String dayName,
    String? dayContext,
    required Map<String, PlannedMealSlot> meals,
  }) = _PlannedDay;

  factory PlannedDay.fromJson(Map<String, dynamic> json) =>
      _$PlannedDayFromJson(json);
}

/// A single meal slot with recipe and reasoning.
@freezed
class PlannedMealSlot with _$PlannedMealSlot {
  const factory PlannedMealSlot({
    String? recipeId,
    required String reasoning,
  }) = _PlannedMealSlot;

  factory PlannedMealSlot.fromJson(Map<String, dynamic> json) =>
      _$PlannedMealSlotFromJson(json);
}

/// Strategy insights from the AI.
@freezed
class StrategyInsights with _$StrategyInsights {
  const factory StrategyInsights({
    @Default([]) List<String> insights,
    @Default(0) int seasonalCount,
    @Default(0) int favoritesUsed,
    String? estimatedTotalTime,
  }) = _StrategyInsights;

  factory StrategyInsights.fromJson(Map<String, dynamic> json) =>
      _$StrategyInsightsFromJson(json);
}

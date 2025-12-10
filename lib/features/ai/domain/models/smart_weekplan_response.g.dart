// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'smart_weekplan_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SmartWeekplanResponseImpl _$$SmartWeekplanResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$SmartWeekplanResponseImpl(
      contextAnalysis: ContextAnalysis.fromJson(
          json['contextAnalysis'] as Map<String, dynamic>),
      weekplan: (json['weekplan'] as List<dynamic>)
          .map((e) => PlannedDay.fromJson(e as Map<String, dynamic>))
          .toList(),
      recipes: json['recipes'] as Map<String, dynamic>,
      strategy:
          StrategyInsights.fromJson(json['strategy'] as Map<String, dynamic>),
      eligibleRecipeCount: (json['eligibleRecipeCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$SmartWeekplanResponseImplToJson(
        _$SmartWeekplanResponseImpl instance) =>
    <String, dynamic>{
      'contextAnalysis': instance.contextAnalysis,
      'weekplan': instance.weekplan,
      'recipes': instance.recipes,
      'strategy': instance.strategy,
      'eligibleRecipeCount': instance.eligibleRecipeCount,
    };

_$ContextAnalysisImpl _$$ContextAnalysisImplFromJson(
        Map<String, dynamic> json) =>
    _$ContextAnalysisImpl(
      timeConstraints: (json['timeConstraints'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const {},
      events: (json['events'] as Map<String, dynamic>?)?.map(
            (k, e) =>
                MapEntry(k, EventInfo.fromJson(e as Map<String, dynamic>)),
          ) ??
          const {},
      ingredientsToUse: (json['ingredientsToUse'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      displaySummary: json['displaySummary'] as String?,
    );

Map<String, dynamic> _$$ContextAnalysisImplToJson(
        _$ContextAnalysisImpl instance) =>
    <String, dynamic>{
      'timeConstraints': instance.timeConstraints,
      'events': instance.events,
      'ingredientsToUse': instance.ingredientsToUse,
      'displaySummary': instance.displaySummary,
    };

_$EventInfoImpl _$$EventInfoImplFromJson(Map<String, dynamic> json) =>
    _$EventInfoImpl(
      type: json['type'] as String,
      guestCount: (json['guestCount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$EventInfoImplToJson(_$EventInfoImpl instance) =>
    <String, dynamic>{
      'type': instance.type,
      'guestCount': instance.guestCount,
    };

_$PlannedDayImpl _$$PlannedDayImplFromJson(Map<String, dynamic> json) =>
    _$PlannedDayImpl(
      date: json['date'] as String,
      dayName: json['dayName'] as String,
      dayContext: json['dayContext'] as String?,
      meals: (json['meals'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry(k, PlannedMealSlot.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$$PlannedDayImplToJson(_$PlannedDayImpl instance) =>
    <String, dynamic>{
      'date': instance.date,
      'dayName': instance.dayName,
      'dayContext': instance.dayContext,
      'meals': instance.meals,
    };

_$PlannedMealSlotImpl _$$PlannedMealSlotImplFromJson(
        Map<String, dynamic> json) =>
    _$PlannedMealSlotImpl(
      recipeId: json['recipeId'] as String?,
      reasoning: json['reasoning'] as String,
    );

Map<String, dynamic> _$$PlannedMealSlotImplToJson(
        _$PlannedMealSlotImpl instance) =>
    <String, dynamic>{
      'recipeId': instance.recipeId,
      'reasoning': instance.reasoning,
    };

_$StrategyInsightsImpl _$$StrategyInsightsImplFromJson(
        Map<String, dynamic> json) =>
    _$StrategyInsightsImpl(
      insights: (json['insights'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      seasonalCount: (json['seasonalCount'] as num?)?.toInt() ?? 0,
      favoritesUsed: (json['favoritesUsed'] as num?)?.toInt() ?? 0,
      estimatedTotalTime: json['estimatedTotalTime'] as String?,
    );

Map<String, dynamic> _$$StrategyInsightsImplToJson(
        _$StrategyInsightsImpl instance) =>
    <String, dynamic>{
      'insights': instance.insights,
      'seasonalCount': instance.seasonalCount,
      'favoritesUsed': instance.favoritesUsed,
      'estimatedTotalTime': instance.estimatedTotalTime,
    };

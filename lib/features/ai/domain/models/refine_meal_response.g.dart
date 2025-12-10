// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'refine_meal_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RefineMealResponseImpl _$$RefineMealResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$RefineMealResponseImpl(
      response: json['response'] as String,
      suggestions: (json['suggestions'] as List<dynamic>)
          .map((e) => MealSuggestion.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$RefineMealResponseImplToJson(
        _$RefineMealResponseImpl instance) =>
    <String, dynamic>{
      'response': instance.response,
      'suggestions': instance.suggestions,
    };

_$MealSuggestionImpl _$$MealSuggestionImplFromJson(Map<String, dynamic> json) =>
    _$MealSuggestionImpl(
      recipeId: json['recipeId'] as String?,
      title: json['title'] as String,
      reasoning: json['reasoning'] as String,
      cookTimeMin: (json['cookTimeMin'] as num?)?.toInt(),
      recipe: json['recipe'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$MealSuggestionImplToJson(
        _$MealSuggestionImpl instance) =>
    <String, dynamic>{
      'recipeId': instance.recipeId,
      'title': instance.title,
      'reasoning': instance.reasoning,
      'cookTimeMin': instance.cookTimeMin,
      'recipe': instance.recipe,
    };

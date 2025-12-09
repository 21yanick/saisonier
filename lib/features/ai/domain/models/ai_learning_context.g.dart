// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_learning_context.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AILearningContextImpl _$$AILearningContextImplFromJson(
        Map<String, dynamic> json) =>
    _$AILearningContextImpl(
      topIngredients: (json['topIngredients'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      categoryUsage: (json['categoryUsage'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toInt()),
          ) ??
          const {},
      acceptedSuggestions: (json['acceptedSuggestions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      rejectedSuggestions: (json['rejectedSuggestions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      activeCookingDays: (json['activeCookingDays'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
      avgServings: (json['avgServings'] as num?)?.toDouble() ?? 2.0,
      totalAIRequests: (json['totalAIRequests'] as num?)?.toInt() ?? 0,
      lastAIInteraction: json['lastAIInteraction'] == null
          ? null
          : DateTime.parse(json['lastAIInteraction'] as String),
    );

Map<String, dynamic> _$$AILearningContextImplToJson(
        _$AILearningContextImpl instance) =>
    <String, dynamic>{
      'topIngredients': instance.topIngredients,
      'categoryUsage': instance.categoryUsage,
      'acceptedSuggestions': instance.acceptedSuggestions,
      'rejectedSuggestions': instance.rejectedSuggestions,
      'activeCookingDays': instance.activeCookingDays,
      'avgServings': instance.avgServings,
      'totalAIRequests': instance.totalAIRequests,
      'lastAIInteraction': instance.lastAIInteraction?.toIso8601String(),
    };

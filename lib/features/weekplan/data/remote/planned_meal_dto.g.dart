// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'planned_meal_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlannedMealDtoImpl _$$PlannedMealDtoImplFromJson(Map<String, dynamic> json) =>
    _$PlannedMealDtoImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      date: DateTime.parse(json['date'] as String),
      slot: json['slot'] as String,
      recipeId: emptyToNull(json['recipe_id']),
      customTitle: json['custom_title'] as String?,
      servings: (json['servings'] as num?)?.toInt() ?? 2,
    );

Map<String, dynamic> _$$PlannedMealDtoImplToJson(
        _$PlannedMealDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'date': instance.date.toIso8601String(),
      'slot': instance.slot,
      'recipe_id': instance.recipeId,
      'custom_title': instance.customTitle,
      'servings': instance.servings,
    };

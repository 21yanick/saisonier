// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RecipeDtoImpl _$$RecipeDtoImplFromJson(Map<String, dynamic> json) =>
    _$RecipeDtoImpl(
      id: json['id'] as String,
      vegetableId: json['vegetable_id'] as String,
      title: json['title'] as String,
      image: json['image'] as String,
      timeMin: (json['time_min'] as num?)?.toInt() ?? 0,
      ingredients: json['ingredients'] as List<dynamic>? ?? const [],
      steps:
          (json['steps'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
    );

Map<String, dynamic> _$$RecipeDtoImplToJson(_$RecipeDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'vegetable_id': instance.vegetableId,
      'title': instance.title,
      'image': instance.image,
      'time_min': instance.timeMin,
      'ingredients': instance.ingredients,
      'steps': instance.steps,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RecipeDtoImpl _$$RecipeDtoImplFromJson(Map<String, dynamic> json) =>
    _$RecipeDtoImpl(
      id: json['id'] as String,
      vegetableId: json['vegetable_id'] as String?,
      title: json['title'] as String,
      image: json['image'] as String? ?? '',
      timeMin: (json['time_min'] as num?)?.toInt() ?? 0,
      servings: (json['servings'] as num?)?.toInt() ?? 4,
      ingredients: json['ingredients'] as List<dynamic>? ?? const [],
      steps:
          (json['steps'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      source: json['source'] as String? ?? 'curated',
      userId: json['user_id'] as String?,
      isPublic: json['is_public'] as bool? ?? false,
      difficulty: json['difficulty'] as String?,
    );

Map<String, dynamic> _$$RecipeDtoImplToJson(_$RecipeDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'vegetable_id': instance.vegetableId,
      'title': instance.title,
      'image': instance.image,
      'time_min': instance.timeMin,
      'servings': instance.servings,
      'ingredients': instance.ingredients,
      'steps': instance.steps,
      'source': instance.source,
      'user_id': instance.userId,
      'is_public': instance.isPublic,
      'difficulty': instance.difficulty,
    };

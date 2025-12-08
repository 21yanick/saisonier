// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RecipeDtoImpl _$$RecipeDtoImplFromJson(Map<String, dynamic> json) =>
    _$RecipeDtoImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      image: json['image'] as String? ?? '',
      prepTimeMin: (json['prep_time_min'] as num?)?.toInt() ?? 0,
      cookTimeMin: (json['cook_time_min'] as num?)?.toInt() ?? 0,
      servings: (json['servings'] as num?)?.toInt() ?? 4,
      difficulty: json['difficulty'] as String?,
      category: json['category'] as String?,
      ingredients: json['ingredients'] as List<dynamic>? ?? const [],
      steps: json['steps'] as List<dynamic>? ?? const [],
      tags: json['tags'] as List<dynamic>? ?? const [],
      vegetableId: json['vegetable_id'] as String?,
      source: json['source'] as String? ?? 'curated',
      userId: json['user_id'] as String?,
      isPublic: json['is_public'] as bool? ?? false,
      isVegetarian: json['is_vegetarian'] as bool? ?? false,
      isVegan: json['is_vegan'] as bool? ?? false,
      containsGluten: json['contains_gluten'] as bool? ?? false,
      containsLactose: json['contains_lactose'] as bool? ?? false,
      containsNuts: json['contains_nuts'] as bool? ?? false,
      containsEggs: json['contains_eggs'] as bool? ?? false,
      containsSoy: json['contains_soy'] as bool? ?? false,
      containsFish: json['contains_fish'] as bool? ?? false,
      containsShellfish: json['contains_shellfish'] as bool? ?? false,
    );

Map<String, dynamic> _$$RecipeDtoImplToJson(_$RecipeDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'image': instance.image,
      'prep_time_min': instance.prepTimeMin,
      'cook_time_min': instance.cookTimeMin,
      'servings': instance.servings,
      'difficulty': instance.difficulty,
      'category': instance.category,
      'ingredients': instance.ingredients,
      'steps': instance.steps,
      'tags': instance.tags,
      'vegetable_id': instance.vegetableId,
      'source': instance.source,
      'user_id': instance.userId,
      'is_public': instance.isPublic,
      'is_vegetarian': instance.isVegetarian,
      'is_vegan': instance.isVegan,
      'contains_gluten': instance.containsGluten,
      'contains_lactose': instance.containsLactose,
      'contains_nuts': instance.containsNuts,
      'contains_eggs': instance.containsEggs,
      'contains_soy': instance.containsSoy,
      'contains_fish': instance.containsFish,
      'contains_shellfish': instance.containsShellfish,
    };

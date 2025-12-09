// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generated_recipe.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GeneratedRecipeImpl _$$GeneratedRecipeImplFromJson(
        Map<String, dynamic> json) =>
    _$GeneratedRecipeImpl(
      title: json['title'] as String,
      description: json['description'] as String,
      prepTimeMin: (json['prepTimeMin'] as num).toInt(),
      cookTimeMin: (json['cookTimeMin'] as num).toInt(),
      servings: (json['servings'] as num).toInt(),
      difficulty: json['difficulty'] as String,
      category: json['category'] as String,
      ingredients: (json['ingredients'] as List<dynamic>)
          .map((e) => GeneratedIngredient.fromJson(e as Map<String, dynamic>))
          .toList(),
      steps: (json['steps'] as List<dynamic>).map((e) => e as String).toList(),
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      isVegetarian: json['isVegetarian'] as bool? ?? false,
      isVegan: json['isVegan'] as bool? ?? false,
      mainVegetable: json['mainVegetable'] as String?,
      tip: json['tip'] as String?,
    );

Map<String, dynamic> _$$GeneratedRecipeImplToJson(
        _$GeneratedRecipeImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'prepTimeMin': instance.prepTimeMin,
      'cookTimeMin': instance.cookTimeMin,
      'servings': instance.servings,
      'difficulty': instance.difficulty,
      'category': instance.category,
      'ingredients': instance.ingredients,
      'steps': instance.steps,
      'tags': instance.tags,
      'isVegetarian': instance.isVegetarian,
      'isVegan': instance.isVegan,
      'mainVegetable': instance.mainVegetable,
      'tip': instance.tip,
    };

_$GeneratedIngredientImpl _$$GeneratedIngredientImplFromJson(
        Map<String, dynamic> json) =>
    _$GeneratedIngredientImpl(
      item: json['item'] as String,
      amount: json['amount'] as String,
      unit: json['unit'] as String? ?? '',
      note: json['note'] as String?,
    );

Map<String, dynamic> _$$GeneratedIngredientImplToJson(
        _$GeneratedIngredientImpl instance) =>
    <String, dynamic>{
      'item': instance.item,
      'amount': instance.amount,
      'unit': instance.unit,
      'note': instance.note,
    };

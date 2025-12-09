// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shopping_item_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ShoppingItemDtoImpl _$$ShoppingItemDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$ShoppingItemDtoImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      item: json['item'] as String,
      amount: (json['amount'] as num?)?.toDouble(),
      unit: json['unit'] as String?,
      note: json['note'] as String?,
      isChecked: json['is_checked'] as bool? ?? false,
      sourceRecipeId: emptyToNull(json['source_recipe_id']),
      createdAt: _parseCreated(json['created']),
    );

Map<String, dynamic> _$$ShoppingItemDtoImplToJson(
        _$ShoppingItemDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'item': instance.item,
      'amount': instance.amount,
      'unit': instance.unit,
      'note': instance.note,
      'is_checked': instance.isChecked,
      'source_recipe_id': instance.sourceRecipeId,
      'created': instance.createdAt.toIso8601String(),
    };

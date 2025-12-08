// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingredient.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$IngredientImpl _$$IngredientImplFromJson(Map<String, dynamic> json) =>
    _$IngredientImpl(
      item: json['item'] as String,
      amount: (json['amount'] as num?)?.toDouble(),
      unit: json['unit'] as String?,
      note: json['note'] as String?,
    );

Map<String, dynamic> _$$IngredientImplToJson(_$IngredientImpl instance) =>
    <String, dynamic>{
      'item': instance.item,
      'amount': instance.amount,
      'unit': instance.unit,
      'note': instance.note,
    };

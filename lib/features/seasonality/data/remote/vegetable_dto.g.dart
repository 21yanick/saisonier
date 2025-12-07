// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vegetable_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VegetableDtoImpl _$$VegetableDtoImplFromJson(Map<String, dynamic> json) =>
    _$VegetableDtoImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      description: json['description'] as String? ?? '',
      image: json['image'] as String,
      hexColor: json['hex_color'] as String,
      months: json['months'] as List<dynamic>,
      tier: (json['tier'] as num).toInt(),
    );

Map<String, dynamic> _$$VegetableDtoImplToJson(_$VegetableDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'description': instance.description,
      'image': instance.image,
      'hex_color': instance.hexColor,
      'months': instance.months,
      'tier': instance.tier,
    };

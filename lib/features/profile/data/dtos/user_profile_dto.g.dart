// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserProfileDtoImpl _$$UserProfileDtoImplFromJson(Map<String, dynamic> json) =>
    _$UserProfileDtoImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      householdSize: (json['household_size'] as num).toInt(),
      childrenCount: (json['children_count'] as num).toInt(),
      childrenAges: (json['children_ages'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      allergens: (json['allergens'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      diet: json['diet'] as String,
      dislikes: (json['dislikes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      skill: json['skill'] as String,
      maxCookingTimeMin: (json['max_cooking_time_min'] as num).toInt(),
      bringEmail: json['bring_email'] as String?,
      bringListUuid: json['bring_list_uuid'] as String?,
    );

Map<String, dynamic> _$$UserProfileDtoImplToJson(
        _$UserProfileDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'household_size': instance.householdSize,
      'children_count': instance.childrenCount,
      'children_ages': instance.childrenAges,
      'allergens': instance.allergens,
      'diet': instance.diet,
      'dislikes': instance.dislikes,
      'skill': instance.skill,
      'max_cooking_time_min': instance.maxCookingTimeMin,
      'bring_email': instance.bringEmail,
      'bring_list_uuid': instance.bringListUuid,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserProfileImpl _$$UserProfileImplFromJson(Map<String, dynamic> json) =>
    _$UserProfileImpl(
      userId: json['userId'] as String,
      householdSize: (json['householdSize'] as num?)?.toInt() ?? 1,
      childrenCount: (json['childrenCount'] as num?)?.toInt() ?? 0,
      childrenAges: (json['childrenAges'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      allergens: (json['allergens'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$AllergenEnumMap, e))
              .toList() ??
          const [],
      diet: $enumDecodeNullable(_$DietTypeEnumMap, json['diet']) ??
          DietType.omnivore,
      dislikes: (json['dislikes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      skill: $enumDecodeNullable(_$CookingSkillEnumMap, json['skill']) ??
          CookingSkill.beginner,
      maxCookingTimeMin: (json['maxCookingTimeMin'] as num?)?.toInt() ?? 30,
      bringEmail: json['bringEmail'] as String?,
      bringListUuid: json['bringListUuid'] as String?,
    );

Map<String, dynamic> _$$UserProfileImplToJson(_$UserProfileImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'householdSize': instance.householdSize,
      'childrenCount': instance.childrenCount,
      'childrenAges': instance.childrenAges,
      'allergens':
          instance.allergens.map((e) => _$AllergenEnumMap[e]!).toList(),
      'diet': _$DietTypeEnumMap[instance.diet]!,
      'dislikes': instance.dislikes,
      'skill': _$CookingSkillEnumMap[instance.skill]!,
      'maxCookingTimeMin': instance.maxCookingTimeMin,
      'bringEmail': instance.bringEmail,
      'bringListUuid': instance.bringListUuid,
    };

const _$AllergenEnumMap = {
  Allergen.gluten: 'gluten',
  Allergen.lactose: 'lactose',
  Allergen.nuts: 'nuts',
  Allergen.eggs: 'eggs',
  Allergen.soy: 'soy',
  Allergen.shellfish: 'shellfish',
  Allergen.fish: 'fish',
};

const _$DietTypeEnumMap = {
  DietType.omnivore: 'omnivore',
  DietType.vegetarian: 'vegetarian',
  DietType.vegan: 'vegan',
  DietType.pescatarian: 'pescatarian',
  DietType.flexitarian: 'flexitarian',
};

const _$CookingSkillEnumMap = {
  CookingSkill.beginner: 'beginner',
  CookingSkill.intermediate: 'intermediate',
  CookingSkill.advanced: 'advanced',
};

// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vegetable_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

VegetableDto _$VegetableDtoFromJson(Map<String, dynamic> json) {
  return _VegetableDto.fromJson(json);
}

/// @nodoc
mixin _$VegetableDto {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get image => throw _privateConstructorUsedError;
  @JsonKey(name: 'hex_color')
  String get hexColor => throw _privateConstructorUsedError;
  List<dynamic> get months =>
      throw _privateConstructorUsedError; // Pocketbase stores this as JSON array
  int get tier => throw _privateConstructorUsedError;

  /// Serializes this VegetableDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VegetableDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VegetableDtoCopyWith<VegetableDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VegetableDtoCopyWith<$Res> {
  factory $VegetableDtoCopyWith(
          VegetableDto value, $Res Function(VegetableDto) then) =
      _$VegetableDtoCopyWithImpl<$Res, VegetableDto>;
  @useResult
  $Res call(
      {String id,
      String name,
      String type,
      String description,
      String image,
      @JsonKey(name: 'hex_color') String hexColor,
      List<dynamic> months,
      int tier});
}

/// @nodoc
class _$VegetableDtoCopyWithImpl<$Res, $Val extends VegetableDto>
    implements $VegetableDtoCopyWith<$Res> {
  _$VegetableDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VegetableDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? description = null,
    Object? image = null,
    Object? hexColor = null,
    Object? months = null,
    Object? tier = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      image: null == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String,
      hexColor: null == hexColor
          ? _value.hexColor
          : hexColor // ignore: cast_nullable_to_non_nullable
              as String,
      months: null == months
          ? _value.months
          : months // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      tier: null == tier
          ? _value.tier
          : tier // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VegetableDtoImplCopyWith<$Res>
    implements $VegetableDtoCopyWith<$Res> {
  factory _$$VegetableDtoImplCopyWith(
          _$VegetableDtoImpl value, $Res Function(_$VegetableDtoImpl) then) =
      __$$VegetableDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String type,
      String description,
      String image,
      @JsonKey(name: 'hex_color') String hexColor,
      List<dynamic> months,
      int tier});
}

/// @nodoc
class __$$VegetableDtoImplCopyWithImpl<$Res>
    extends _$VegetableDtoCopyWithImpl<$Res, _$VegetableDtoImpl>
    implements _$$VegetableDtoImplCopyWith<$Res> {
  __$$VegetableDtoImplCopyWithImpl(
      _$VegetableDtoImpl _value, $Res Function(_$VegetableDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of VegetableDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? description = null,
    Object? image = null,
    Object? hexColor = null,
    Object? months = null,
    Object? tier = null,
  }) {
    return _then(_$VegetableDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      image: null == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String,
      hexColor: null == hexColor
          ? _value.hexColor
          : hexColor // ignore: cast_nullable_to_non_nullable
              as String,
      months: null == months
          ? _value._months
          : months // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      tier: null == tier
          ? _value.tier
          : tier // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VegetableDtoImpl implements _VegetableDto {
  const _$VegetableDtoImpl(
      {required this.id,
      required this.name,
      required this.type,
      this.description = '',
      required this.image,
      @JsonKey(name: 'hex_color') required this.hexColor,
      required final List<dynamic> months,
      required this.tier})
      : _months = months;

  factory _$VegetableDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$VegetableDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String type;
  @override
  @JsonKey()
  final String description;
  @override
  final String image;
  @override
  @JsonKey(name: 'hex_color')
  final String hexColor;
  final List<dynamic> _months;
  @override
  List<dynamic> get months {
    if (_months is EqualUnmodifiableListView) return _months;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_months);
  }

// Pocketbase stores this as JSON array
  @override
  final int tier;

  @override
  String toString() {
    return 'VegetableDto(id: $id, name: $name, type: $type, description: $description, image: $image, hexColor: $hexColor, months: $months, tier: $tier)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VegetableDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.hexColor, hexColor) ||
                other.hexColor == hexColor) &&
            const DeepCollectionEquality().equals(other._months, _months) &&
            (identical(other.tier, tier) || other.tier == tier));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, type, description,
      image, hexColor, const DeepCollectionEquality().hash(_months), tier);

  /// Create a copy of VegetableDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VegetableDtoImplCopyWith<_$VegetableDtoImpl> get copyWith =>
      __$$VegetableDtoImplCopyWithImpl<_$VegetableDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VegetableDtoImplToJson(
      this,
    );
  }
}

abstract class _VegetableDto implements VegetableDto {
  const factory _VegetableDto(
      {required final String id,
      required final String name,
      required final String type,
      final String description,
      required final String image,
      @JsonKey(name: 'hex_color') required final String hexColor,
      required final List<dynamic> months,
      required final int tier}) = _$VegetableDtoImpl;

  factory _VegetableDto.fromJson(Map<String, dynamic> json) =
      _$VegetableDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get type;
  @override
  String get description;
  @override
  String get image;
  @override
  @JsonKey(name: 'hex_color')
  String get hexColor;
  @override
  List<dynamic> get months; // Pocketbase stores this as JSON array
  @override
  int get tier;

  /// Create a copy of VegetableDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VegetableDtoImplCopyWith<_$VegetableDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

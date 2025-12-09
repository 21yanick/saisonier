// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shopping_item_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ShoppingItemDto _$ShoppingItemDtoFromJson(Map<String, dynamic> json) {
  return _ShoppingItemDto.fromJson(json);
}

/// @nodoc
mixin _$ShoppingItemDto {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  String get item => throw _privateConstructorUsedError;
  double? get amount => throw _privateConstructorUsedError;
  String? get unit => throw _privateConstructorUsedError;
  String? get note => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_checked')
  bool get isChecked => throw _privateConstructorUsedError;
  @JsonKey(name: 'source_recipe_id', fromJson: emptyToNull)
  String? get sourceRecipeId => throw _privateConstructorUsedError;
  @JsonKey(name: 'created', fromJson: _parseCreated)
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this ShoppingItemDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ShoppingItemDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShoppingItemDtoCopyWith<ShoppingItemDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShoppingItemDtoCopyWith<$Res> {
  factory $ShoppingItemDtoCopyWith(
          ShoppingItemDto value, $Res Function(ShoppingItemDto) then) =
      _$ShoppingItemDtoCopyWithImpl<$Res, ShoppingItemDto>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      String item,
      double? amount,
      String? unit,
      String? note,
      @JsonKey(name: 'is_checked') bool isChecked,
      @JsonKey(name: 'source_recipe_id', fromJson: emptyToNull)
      String? sourceRecipeId,
      @JsonKey(name: 'created', fromJson: _parseCreated) DateTime createdAt});
}

/// @nodoc
class _$ShoppingItemDtoCopyWithImpl<$Res, $Val extends ShoppingItemDto>
    implements $ShoppingItemDtoCopyWith<$Res> {
  _$ShoppingItemDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShoppingItemDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? item = null,
    Object? amount = freezed,
    Object? unit = freezed,
    Object? note = freezed,
    Object? isChecked = null,
    Object? sourceRecipeId = freezed,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      item: null == item
          ? _value.item
          : item // ignore: cast_nullable_to_non_nullable
              as String,
      amount: freezed == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double?,
      unit: freezed == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String?,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
      isChecked: null == isChecked
          ? _value.isChecked
          : isChecked // ignore: cast_nullable_to_non_nullable
              as bool,
      sourceRecipeId: freezed == sourceRecipeId
          ? _value.sourceRecipeId
          : sourceRecipeId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ShoppingItemDtoImplCopyWith<$Res>
    implements $ShoppingItemDtoCopyWith<$Res> {
  factory _$$ShoppingItemDtoImplCopyWith(_$ShoppingItemDtoImpl value,
          $Res Function(_$ShoppingItemDtoImpl) then) =
      __$$ShoppingItemDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      String item,
      double? amount,
      String? unit,
      String? note,
      @JsonKey(name: 'is_checked') bool isChecked,
      @JsonKey(name: 'source_recipe_id', fromJson: emptyToNull)
      String? sourceRecipeId,
      @JsonKey(name: 'created', fromJson: _parseCreated) DateTime createdAt});
}

/// @nodoc
class __$$ShoppingItemDtoImplCopyWithImpl<$Res>
    extends _$ShoppingItemDtoCopyWithImpl<$Res, _$ShoppingItemDtoImpl>
    implements _$$ShoppingItemDtoImplCopyWith<$Res> {
  __$$ShoppingItemDtoImplCopyWithImpl(
      _$ShoppingItemDtoImpl _value, $Res Function(_$ShoppingItemDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of ShoppingItemDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? item = null,
    Object? amount = freezed,
    Object? unit = freezed,
    Object? note = freezed,
    Object? isChecked = null,
    Object? sourceRecipeId = freezed,
    Object? createdAt = null,
  }) {
    return _then(_$ShoppingItemDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      item: null == item
          ? _value.item
          : item // ignore: cast_nullable_to_non_nullable
              as String,
      amount: freezed == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double?,
      unit: freezed == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String?,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
      isChecked: null == isChecked
          ? _value.isChecked
          : isChecked // ignore: cast_nullable_to_non_nullable
              as bool,
      sourceRecipeId: freezed == sourceRecipeId
          ? _value.sourceRecipeId
          : sourceRecipeId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ShoppingItemDtoImpl implements _ShoppingItemDto {
  const _$ShoppingItemDtoImpl(
      {required this.id,
      @JsonKey(name: 'user_id') required this.userId,
      required this.item,
      this.amount,
      this.unit,
      this.note,
      @JsonKey(name: 'is_checked') this.isChecked = false,
      @JsonKey(name: 'source_recipe_id', fromJson: emptyToNull)
      this.sourceRecipeId,
      @JsonKey(name: 'created', fromJson: _parseCreated)
      required this.createdAt});

  factory _$ShoppingItemDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShoppingItemDtoImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  final String item;
  @override
  final double? amount;
  @override
  final String? unit;
  @override
  final String? note;
  @override
  @JsonKey(name: 'is_checked')
  final bool isChecked;
  @override
  @JsonKey(name: 'source_recipe_id', fromJson: emptyToNull)
  final String? sourceRecipeId;
  @override
  @JsonKey(name: 'created', fromJson: _parseCreated)
  final DateTime createdAt;

  @override
  String toString() {
    return 'ShoppingItemDto(id: $id, userId: $userId, item: $item, amount: $amount, unit: $unit, note: $note, isChecked: $isChecked, sourceRecipeId: $sourceRecipeId, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShoppingItemDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.item, item) || other.item == item) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.isChecked, isChecked) ||
                other.isChecked == isChecked) &&
            (identical(other.sourceRecipeId, sourceRecipeId) ||
                other.sourceRecipeId == sourceRecipeId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, userId, item, amount, unit,
      note, isChecked, sourceRecipeId, createdAt);

  /// Create a copy of ShoppingItemDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShoppingItemDtoImplCopyWith<_$ShoppingItemDtoImpl> get copyWith =>
      __$$ShoppingItemDtoImplCopyWithImpl<_$ShoppingItemDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ShoppingItemDtoImplToJson(
      this,
    );
  }
}

abstract class _ShoppingItemDto implements ShoppingItemDto {
  const factory _ShoppingItemDto(
      {required final String id,
      @JsonKey(name: 'user_id') required final String userId,
      required final String item,
      final double? amount,
      final String? unit,
      final String? note,
      @JsonKey(name: 'is_checked') final bool isChecked,
      @JsonKey(name: 'source_recipe_id', fromJson: emptyToNull)
      final String? sourceRecipeId,
      @JsonKey(name: 'created', fromJson: _parseCreated)
      required final DateTime createdAt}) = _$ShoppingItemDtoImpl;

  factory _ShoppingItemDto.fromJson(Map<String, dynamic> json) =
      _$ShoppingItemDtoImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  String get item;
  @override
  double? get amount;
  @override
  String? get unit;
  @override
  String? get note;
  @override
  @JsonKey(name: 'is_checked')
  bool get isChecked;
  @override
  @JsonKey(name: 'source_recipe_id', fromJson: emptyToNull)
  String? get sourceRecipeId;
  @override
  @JsonKey(name: 'created', fromJson: _parseCreated)
  DateTime get createdAt;

  /// Create a copy of ShoppingItemDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShoppingItemDtoImplCopyWith<_$ShoppingItemDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

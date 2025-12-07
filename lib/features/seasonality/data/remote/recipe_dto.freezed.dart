// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recipe_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RecipeDto _$RecipeDtoFromJson(Map<String, dynamic> json) {
  return _RecipeDto.fromJson(json);
}

/// @nodoc
mixin _$RecipeDto {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'vegetable_id')
  String? get vegetableId =>
      throw _privateConstructorUsedError; // Nullable for user recipes
  String get title => throw _privateConstructorUsedError;
  String get image => throw _privateConstructorUsedError;
  @JsonKey(name: 'time_min')
  int get timeMin => throw _privateConstructorUsedError;
  int get servings => throw _privateConstructorUsedError;
  List<dynamic> get ingredients =>
      throw _privateConstructorUsedError; // JSON array of objects
  List<String> get steps =>
      throw _privateConstructorUsedError; // JSON array of strings
// Phase 11: User Recipes
  String get source => throw _privateConstructorUsedError; // 'curated' | 'user'
  @JsonKey(name: 'user_id')
  String? get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_public')
  bool get isPublic => throw _privateConstructorUsedError;
  String? get difficulty => throw _privateConstructorUsedError;

  /// Serializes this RecipeDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RecipeDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecipeDtoCopyWith<RecipeDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecipeDtoCopyWith<$Res> {
  factory $RecipeDtoCopyWith(RecipeDto value, $Res Function(RecipeDto) then) =
      _$RecipeDtoCopyWithImpl<$Res, RecipeDto>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'vegetable_id') String? vegetableId,
      String title,
      String image,
      @JsonKey(name: 'time_min') int timeMin,
      int servings,
      List<dynamic> ingredients,
      List<String> steps,
      String source,
      @JsonKey(name: 'user_id') String? userId,
      @JsonKey(name: 'is_public') bool isPublic,
      String? difficulty});
}

/// @nodoc
class _$RecipeDtoCopyWithImpl<$Res, $Val extends RecipeDto>
    implements $RecipeDtoCopyWith<$Res> {
  _$RecipeDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecipeDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? vegetableId = freezed,
    Object? title = null,
    Object? image = null,
    Object? timeMin = null,
    Object? servings = null,
    Object? ingredients = null,
    Object? steps = null,
    Object? source = null,
    Object? userId = freezed,
    Object? isPublic = null,
    Object? difficulty = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      vegetableId: freezed == vegetableId
          ? _value.vegetableId
          : vegetableId // ignore: cast_nullable_to_non_nullable
              as String?,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      image: null == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String,
      timeMin: null == timeMin
          ? _value.timeMin
          : timeMin // ignore: cast_nullable_to_non_nullable
              as int,
      servings: null == servings
          ? _value.servings
          : servings // ignore: cast_nullable_to_non_nullable
              as int,
      ingredients: null == ingredients
          ? _value.ingredients
          : ingredients // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      steps: null == steps
          ? _value.steps
          : steps // ignore: cast_nullable_to_non_nullable
              as List<String>,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      isPublic: null == isPublic
          ? _value.isPublic
          : isPublic // ignore: cast_nullable_to_non_nullable
              as bool,
      difficulty: freezed == difficulty
          ? _value.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RecipeDtoImplCopyWith<$Res>
    implements $RecipeDtoCopyWith<$Res> {
  factory _$$RecipeDtoImplCopyWith(
          _$RecipeDtoImpl value, $Res Function(_$RecipeDtoImpl) then) =
      __$$RecipeDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'vegetable_id') String? vegetableId,
      String title,
      String image,
      @JsonKey(name: 'time_min') int timeMin,
      int servings,
      List<dynamic> ingredients,
      List<String> steps,
      String source,
      @JsonKey(name: 'user_id') String? userId,
      @JsonKey(name: 'is_public') bool isPublic,
      String? difficulty});
}

/// @nodoc
class __$$RecipeDtoImplCopyWithImpl<$Res>
    extends _$RecipeDtoCopyWithImpl<$Res, _$RecipeDtoImpl>
    implements _$$RecipeDtoImplCopyWith<$Res> {
  __$$RecipeDtoImplCopyWithImpl(
      _$RecipeDtoImpl _value, $Res Function(_$RecipeDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of RecipeDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? vegetableId = freezed,
    Object? title = null,
    Object? image = null,
    Object? timeMin = null,
    Object? servings = null,
    Object? ingredients = null,
    Object? steps = null,
    Object? source = null,
    Object? userId = freezed,
    Object? isPublic = null,
    Object? difficulty = freezed,
  }) {
    return _then(_$RecipeDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      vegetableId: freezed == vegetableId
          ? _value.vegetableId
          : vegetableId // ignore: cast_nullable_to_non_nullable
              as String?,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      image: null == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String,
      timeMin: null == timeMin
          ? _value.timeMin
          : timeMin // ignore: cast_nullable_to_non_nullable
              as int,
      servings: null == servings
          ? _value.servings
          : servings // ignore: cast_nullable_to_non_nullable
              as int,
      ingredients: null == ingredients
          ? _value._ingredients
          : ingredients // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      steps: null == steps
          ? _value._steps
          : steps // ignore: cast_nullable_to_non_nullable
              as List<String>,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      isPublic: null == isPublic
          ? _value.isPublic
          : isPublic // ignore: cast_nullable_to_non_nullable
              as bool,
      difficulty: freezed == difficulty
          ? _value.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RecipeDtoImpl implements _RecipeDto {
  const _$RecipeDtoImpl(
      {required this.id,
      @JsonKey(name: 'vegetable_id') this.vegetableId,
      required this.title,
      this.image = '',
      @JsonKey(name: 'time_min') this.timeMin = 0,
      this.servings = 4,
      final List<dynamic> ingredients = const [],
      final List<String> steps = const [],
      this.source = 'curated',
      @JsonKey(name: 'user_id') this.userId,
      @JsonKey(name: 'is_public') this.isPublic = false,
      this.difficulty})
      : _ingredients = ingredients,
        _steps = steps;

  factory _$RecipeDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecipeDtoImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'vegetable_id')
  final String? vegetableId;
// Nullable for user recipes
  @override
  final String title;
  @override
  @JsonKey()
  final String image;
  @override
  @JsonKey(name: 'time_min')
  final int timeMin;
  @override
  @JsonKey()
  final int servings;
  final List<dynamic> _ingredients;
  @override
  @JsonKey()
  List<dynamic> get ingredients {
    if (_ingredients is EqualUnmodifiableListView) return _ingredients;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_ingredients);
  }

// JSON array of objects
  final List<String> _steps;
// JSON array of objects
  @override
  @JsonKey()
  List<String> get steps {
    if (_steps is EqualUnmodifiableListView) return _steps;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_steps);
  }

// JSON array of strings
// Phase 11: User Recipes
  @override
  @JsonKey()
  final String source;
// 'curated' | 'user'
  @override
  @JsonKey(name: 'user_id')
  final String? userId;
  @override
  @JsonKey(name: 'is_public')
  final bool isPublic;
  @override
  final String? difficulty;

  @override
  String toString() {
    return 'RecipeDto(id: $id, vegetableId: $vegetableId, title: $title, image: $image, timeMin: $timeMin, servings: $servings, ingredients: $ingredients, steps: $steps, source: $source, userId: $userId, isPublic: $isPublic, difficulty: $difficulty)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecipeDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.vegetableId, vegetableId) ||
                other.vegetableId == vegetableId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.timeMin, timeMin) || other.timeMin == timeMin) &&
            (identical(other.servings, servings) ||
                other.servings == servings) &&
            const DeepCollectionEquality()
                .equals(other._ingredients, _ingredients) &&
            const DeepCollectionEquality().equals(other._steps, _steps) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.isPublic, isPublic) ||
                other.isPublic == isPublic) &&
            (identical(other.difficulty, difficulty) ||
                other.difficulty == difficulty));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      vegetableId,
      title,
      image,
      timeMin,
      servings,
      const DeepCollectionEquality().hash(_ingredients),
      const DeepCollectionEquality().hash(_steps),
      source,
      userId,
      isPublic,
      difficulty);

  /// Create a copy of RecipeDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecipeDtoImplCopyWith<_$RecipeDtoImpl> get copyWith =>
      __$$RecipeDtoImplCopyWithImpl<_$RecipeDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RecipeDtoImplToJson(
      this,
    );
  }
}

abstract class _RecipeDto implements RecipeDto {
  const factory _RecipeDto(
      {required final String id,
      @JsonKey(name: 'vegetable_id') final String? vegetableId,
      required final String title,
      final String image,
      @JsonKey(name: 'time_min') final int timeMin,
      final int servings,
      final List<dynamic> ingredients,
      final List<String> steps,
      final String source,
      @JsonKey(name: 'user_id') final String? userId,
      @JsonKey(name: 'is_public') final bool isPublic,
      final String? difficulty}) = _$RecipeDtoImpl;

  factory _RecipeDto.fromJson(Map<String, dynamic> json) =
      _$RecipeDtoImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'vegetable_id')
  String? get vegetableId; // Nullable for user recipes
  @override
  String get title;
  @override
  String get image;
  @override
  @JsonKey(name: 'time_min')
  int get timeMin;
  @override
  int get servings;
  @override
  List<dynamic> get ingredients; // JSON array of objects
  @override
  List<String> get steps; // JSON array of strings
// Phase 11: User Recipes
  @override
  String get source; // 'curated' | 'user'
  @override
  @JsonKey(name: 'user_id')
  String? get userId;
  @override
  @JsonKey(name: 'is_public')
  bool get isPublic;
  @override
  String? get difficulty;

  /// Create a copy of RecipeDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecipeDtoImplCopyWith<_$RecipeDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

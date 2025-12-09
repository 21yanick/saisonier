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
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get image =>
      throw _privateConstructorUsedError; // === Zeiten (getrennt) ===
  @JsonKey(name: 'prep_time_min')
  int get prepTimeMin => throw _privateConstructorUsedError;
  @JsonKey(name: 'cook_time_min')
  int get cookTimeMin =>
      throw _privateConstructorUsedError; // === Portionen & Schwierigkeit ===
  int get servings => throw _privateConstructorUsedError;
  String? get difficulty =>
      throw _privateConstructorUsedError; // 'easy' | 'medium' | 'hard'
  String? get category =>
      throw _privateConstructorUsedError; // 'main' | 'side' | 'dessert' | 'snack' | 'breakfast' | 'soup' | 'salad'
// === Inhalte (JSON) ===
  List<dynamic> get ingredients =>
      throw _privateConstructorUsedError; // JSON array: [{item, amount, unit, note}]
  List<dynamic> get steps =>
      throw _privateConstructorUsedError; // JSON array of strings
// === Tags ===
  List<dynamic> get tags =>
      throw _privateConstructorUsedError; // Array: ["schnell", "günstig"]
// === Beziehungen ===
  @JsonKey(name: 'vegetable_id', fromJson: emptyToNull)
  String? get vegetableId =>
      throw _privateConstructorUsedError; // === Ownership ===
  String get source => throw _privateConstructorUsedError; // 'curated' | 'user'
  @JsonKey(name: 'user_id', fromJson: emptyToNull)
  String? get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_public')
  bool get isPublic => throw _privateConstructorUsedError; // === Ernährung ===
  @JsonKey(name: 'is_vegetarian')
  bool get isVegetarian => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_vegan')
  bool get isVegan =>
      throw _privateConstructorUsedError; // === Allergene (contains = true wenn enthalten) ===
  @JsonKey(name: 'contains_gluten')
  bool get containsGluten => throw _privateConstructorUsedError;
  @JsonKey(name: 'contains_lactose')
  bool get containsLactose => throw _privateConstructorUsedError;
  @JsonKey(name: 'contains_nuts')
  bool get containsNuts => throw _privateConstructorUsedError;
  @JsonKey(name: 'contains_eggs')
  bool get containsEggs => throw _privateConstructorUsedError;
  @JsonKey(name: 'contains_soy')
  bool get containsSoy => throw _privateConstructorUsedError;
  @JsonKey(name: 'contains_fish')
  bool get containsFish => throw _privateConstructorUsedError;
  @JsonKey(name: 'contains_shellfish')
  bool get containsShellfish => throw _privateConstructorUsedError;

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
      String title,
      String description,
      String image,
      @JsonKey(name: 'prep_time_min') int prepTimeMin,
      @JsonKey(name: 'cook_time_min') int cookTimeMin,
      int servings,
      String? difficulty,
      String? category,
      List<dynamic> ingredients,
      List<dynamic> steps,
      List<dynamic> tags,
      @JsonKey(name: 'vegetable_id', fromJson: emptyToNull) String? vegetableId,
      String source,
      @JsonKey(name: 'user_id', fromJson: emptyToNull) String? userId,
      @JsonKey(name: 'is_public') bool isPublic,
      @JsonKey(name: 'is_vegetarian') bool isVegetarian,
      @JsonKey(name: 'is_vegan') bool isVegan,
      @JsonKey(name: 'contains_gluten') bool containsGluten,
      @JsonKey(name: 'contains_lactose') bool containsLactose,
      @JsonKey(name: 'contains_nuts') bool containsNuts,
      @JsonKey(name: 'contains_eggs') bool containsEggs,
      @JsonKey(name: 'contains_soy') bool containsSoy,
      @JsonKey(name: 'contains_fish') bool containsFish,
      @JsonKey(name: 'contains_shellfish') bool containsShellfish});
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
    Object? title = null,
    Object? description = null,
    Object? image = null,
    Object? prepTimeMin = null,
    Object? cookTimeMin = null,
    Object? servings = null,
    Object? difficulty = freezed,
    Object? category = freezed,
    Object? ingredients = null,
    Object? steps = null,
    Object? tags = null,
    Object? vegetableId = freezed,
    Object? source = null,
    Object? userId = freezed,
    Object? isPublic = null,
    Object? isVegetarian = null,
    Object? isVegan = null,
    Object? containsGluten = null,
    Object? containsLactose = null,
    Object? containsNuts = null,
    Object? containsEggs = null,
    Object? containsSoy = null,
    Object? containsFish = null,
    Object? containsShellfish = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      image: null == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String,
      prepTimeMin: null == prepTimeMin
          ? _value.prepTimeMin
          : prepTimeMin // ignore: cast_nullable_to_non_nullable
              as int,
      cookTimeMin: null == cookTimeMin
          ? _value.cookTimeMin
          : cookTimeMin // ignore: cast_nullable_to_non_nullable
              as int,
      servings: null == servings
          ? _value.servings
          : servings // ignore: cast_nullable_to_non_nullable
              as int,
      difficulty: freezed == difficulty
          ? _value.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      ingredients: null == ingredients
          ? _value.ingredients
          : ingredients // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      steps: null == steps
          ? _value.steps
          : steps // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      vegetableId: freezed == vegetableId
          ? _value.vegetableId
          : vegetableId // ignore: cast_nullable_to_non_nullable
              as String?,
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
      isVegetarian: null == isVegetarian
          ? _value.isVegetarian
          : isVegetarian // ignore: cast_nullable_to_non_nullable
              as bool,
      isVegan: null == isVegan
          ? _value.isVegan
          : isVegan // ignore: cast_nullable_to_non_nullable
              as bool,
      containsGluten: null == containsGluten
          ? _value.containsGluten
          : containsGluten // ignore: cast_nullable_to_non_nullable
              as bool,
      containsLactose: null == containsLactose
          ? _value.containsLactose
          : containsLactose // ignore: cast_nullable_to_non_nullable
              as bool,
      containsNuts: null == containsNuts
          ? _value.containsNuts
          : containsNuts // ignore: cast_nullable_to_non_nullable
              as bool,
      containsEggs: null == containsEggs
          ? _value.containsEggs
          : containsEggs // ignore: cast_nullable_to_non_nullable
              as bool,
      containsSoy: null == containsSoy
          ? _value.containsSoy
          : containsSoy // ignore: cast_nullable_to_non_nullable
              as bool,
      containsFish: null == containsFish
          ? _value.containsFish
          : containsFish // ignore: cast_nullable_to_non_nullable
              as bool,
      containsShellfish: null == containsShellfish
          ? _value.containsShellfish
          : containsShellfish // ignore: cast_nullable_to_non_nullable
              as bool,
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
      String title,
      String description,
      String image,
      @JsonKey(name: 'prep_time_min') int prepTimeMin,
      @JsonKey(name: 'cook_time_min') int cookTimeMin,
      int servings,
      String? difficulty,
      String? category,
      List<dynamic> ingredients,
      List<dynamic> steps,
      List<dynamic> tags,
      @JsonKey(name: 'vegetable_id', fromJson: emptyToNull) String? vegetableId,
      String source,
      @JsonKey(name: 'user_id', fromJson: emptyToNull) String? userId,
      @JsonKey(name: 'is_public') bool isPublic,
      @JsonKey(name: 'is_vegetarian') bool isVegetarian,
      @JsonKey(name: 'is_vegan') bool isVegan,
      @JsonKey(name: 'contains_gluten') bool containsGluten,
      @JsonKey(name: 'contains_lactose') bool containsLactose,
      @JsonKey(name: 'contains_nuts') bool containsNuts,
      @JsonKey(name: 'contains_eggs') bool containsEggs,
      @JsonKey(name: 'contains_soy') bool containsSoy,
      @JsonKey(name: 'contains_fish') bool containsFish,
      @JsonKey(name: 'contains_shellfish') bool containsShellfish});
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
    Object? title = null,
    Object? description = null,
    Object? image = null,
    Object? prepTimeMin = null,
    Object? cookTimeMin = null,
    Object? servings = null,
    Object? difficulty = freezed,
    Object? category = freezed,
    Object? ingredients = null,
    Object? steps = null,
    Object? tags = null,
    Object? vegetableId = freezed,
    Object? source = null,
    Object? userId = freezed,
    Object? isPublic = null,
    Object? isVegetarian = null,
    Object? isVegan = null,
    Object? containsGluten = null,
    Object? containsLactose = null,
    Object? containsNuts = null,
    Object? containsEggs = null,
    Object? containsSoy = null,
    Object? containsFish = null,
    Object? containsShellfish = null,
  }) {
    return _then(_$RecipeDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      image: null == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String,
      prepTimeMin: null == prepTimeMin
          ? _value.prepTimeMin
          : prepTimeMin // ignore: cast_nullable_to_non_nullable
              as int,
      cookTimeMin: null == cookTimeMin
          ? _value.cookTimeMin
          : cookTimeMin // ignore: cast_nullable_to_non_nullable
              as int,
      servings: null == servings
          ? _value.servings
          : servings // ignore: cast_nullable_to_non_nullable
              as int,
      difficulty: freezed == difficulty
          ? _value.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      ingredients: null == ingredients
          ? _value._ingredients
          : ingredients // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      steps: null == steps
          ? _value._steps
          : steps // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      vegetableId: freezed == vegetableId
          ? _value.vegetableId
          : vegetableId // ignore: cast_nullable_to_non_nullable
              as String?,
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
      isVegetarian: null == isVegetarian
          ? _value.isVegetarian
          : isVegetarian // ignore: cast_nullable_to_non_nullable
              as bool,
      isVegan: null == isVegan
          ? _value.isVegan
          : isVegan // ignore: cast_nullable_to_non_nullable
              as bool,
      containsGluten: null == containsGluten
          ? _value.containsGluten
          : containsGluten // ignore: cast_nullable_to_non_nullable
              as bool,
      containsLactose: null == containsLactose
          ? _value.containsLactose
          : containsLactose // ignore: cast_nullable_to_non_nullable
              as bool,
      containsNuts: null == containsNuts
          ? _value.containsNuts
          : containsNuts // ignore: cast_nullable_to_non_nullable
              as bool,
      containsEggs: null == containsEggs
          ? _value.containsEggs
          : containsEggs // ignore: cast_nullable_to_non_nullable
              as bool,
      containsSoy: null == containsSoy
          ? _value.containsSoy
          : containsSoy // ignore: cast_nullable_to_non_nullable
              as bool,
      containsFish: null == containsFish
          ? _value.containsFish
          : containsFish // ignore: cast_nullable_to_non_nullable
              as bool,
      containsShellfish: null == containsShellfish
          ? _value.containsShellfish
          : containsShellfish // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RecipeDtoImpl implements _RecipeDto {
  const _$RecipeDtoImpl(
      {required this.id,
      required this.title,
      this.description = '',
      this.image = '',
      @JsonKey(name: 'prep_time_min') this.prepTimeMin = 0,
      @JsonKey(name: 'cook_time_min') this.cookTimeMin = 0,
      this.servings = 4,
      this.difficulty,
      this.category,
      final List<dynamic> ingredients = const [],
      final List<dynamic> steps = const [],
      final List<dynamic> tags = const [],
      @JsonKey(name: 'vegetable_id', fromJson: emptyToNull) this.vegetableId,
      this.source = 'curated',
      @JsonKey(name: 'user_id', fromJson: emptyToNull) this.userId,
      @JsonKey(name: 'is_public') this.isPublic = false,
      @JsonKey(name: 'is_vegetarian') this.isVegetarian = false,
      @JsonKey(name: 'is_vegan') this.isVegan = false,
      @JsonKey(name: 'contains_gluten') this.containsGluten = false,
      @JsonKey(name: 'contains_lactose') this.containsLactose = false,
      @JsonKey(name: 'contains_nuts') this.containsNuts = false,
      @JsonKey(name: 'contains_eggs') this.containsEggs = false,
      @JsonKey(name: 'contains_soy') this.containsSoy = false,
      @JsonKey(name: 'contains_fish') this.containsFish = false,
      @JsonKey(name: 'contains_shellfish') this.containsShellfish = false})
      : _ingredients = ingredients,
        _steps = steps,
        _tags = tags;

  factory _$RecipeDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecipeDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  @JsonKey()
  final String description;
  @override
  @JsonKey()
  final String image;
// === Zeiten (getrennt) ===
  @override
  @JsonKey(name: 'prep_time_min')
  final int prepTimeMin;
  @override
  @JsonKey(name: 'cook_time_min')
  final int cookTimeMin;
// === Portionen & Schwierigkeit ===
  @override
  @JsonKey()
  final int servings;
  @override
  final String? difficulty;
// 'easy' | 'medium' | 'hard'
  @override
  final String? category;
// 'main' | 'side' | 'dessert' | 'snack' | 'breakfast' | 'soup' | 'salad'
// === Inhalte (JSON) ===
  final List<dynamic> _ingredients;
// 'main' | 'side' | 'dessert' | 'snack' | 'breakfast' | 'soup' | 'salad'
// === Inhalte (JSON) ===
  @override
  @JsonKey()
  List<dynamic> get ingredients {
    if (_ingredients is EqualUnmodifiableListView) return _ingredients;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_ingredients);
  }

// JSON array: [{item, amount, unit, note}]
  final List<dynamic> _steps;
// JSON array: [{item, amount, unit, note}]
  @override
  @JsonKey()
  List<dynamic> get steps {
    if (_steps is EqualUnmodifiableListView) return _steps;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_steps);
  }

// JSON array of strings
// === Tags ===
  final List<dynamic> _tags;
// JSON array of strings
// === Tags ===
  @override
  @JsonKey()
  List<dynamic> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

// Array: ["schnell", "günstig"]
// === Beziehungen ===
  @override
  @JsonKey(name: 'vegetable_id', fromJson: emptyToNull)
  final String? vegetableId;
// === Ownership ===
  @override
  @JsonKey()
  final String source;
// 'curated' | 'user'
  @override
  @JsonKey(name: 'user_id', fromJson: emptyToNull)
  final String? userId;
  @override
  @JsonKey(name: 'is_public')
  final bool isPublic;
// === Ernährung ===
  @override
  @JsonKey(name: 'is_vegetarian')
  final bool isVegetarian;
  @override
  @JsonKey(name: 'is_vegan')
  final bool isVegan;
// === Allergene (contains = true wenn enthalten) ===
  @override
  @JsonKey(name: 'contains_gluten')
  final bool containsGluten;
  @override
  @JsonKey(name: 'contains_lactose')
  final bool containsLactose;
  @override
  @JsonKey(name: 'contains_nuts')
  final bool containsNuts;
  @override
  @JsonKey(name: 'contains_eggs')
  final bool containsEggs;
  @override
  @JsonKey(name: 'contains_soy')
  final bool containsSoy;
  @override
  @JsonKey(name: 'contains_fish')
  final bool containsFish;
  @override
  @JsonKey(name: 'contains_shellfish')
  final bool containsShellfish;

  @override
  String toString() {
    return 'RecipeDto(id: $id, title: $title, description: $description, image: $image, prepTimeMin: $prepTimeMin, cookTimeMin: $cookTimeMin, servings: $servings, difficulty: $difficulty, category: $category, ingredients: $ingredients, steps: $steps, tags: $tags, vegetableId: $vegetableId, source: $source, userId: $userId, isPublic: $isPublic, isVegetarian: $isVegetarian, isVegan: $isVegan, containsGluten: $containsGluten, containsLactose: $containsLactose, containsNuts: $containsNuts, containsEggs: $containsEggs, containsSoy: $containsSoy, containsFish: $containsFish, containsShellfish: $containsShellfish)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecipeDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.prepTimeMin, prepTimeMin) ||
                other.prepTimeMin == prepTimeMin) &&
            (identical(other.cookTimeMin, cookTimeMin) ||
                other.cookTimeMin == cookTimeMin) &&
            (identical(other.servings, servings) ||
                other.servings == servings) &&
            (identical(other.difficulty, difficulty) ||
                other.difficulty == difficulty) &&
            (identical(other.category, category) ||
                other.category == category) &&
            const DeepCollectionEquality()
                .equals(other._ingredients, _ingredients) &&
            const DeepCollectionEquality().equals(other._steps, _steps) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.vegetableId, vegetableId) ||
                other.vegetableId == vegetableId) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.isPublic, isPublic) ||
                other.isPublic == isPublic) &&
            (identical(other.isVegetarian, isVegetarian) ||
                other.isVegetarian == isVegetarian) &&
            (identical(other.isVegan, isVegan) || other.isVegan == isVegan) &&
            (identical(other.containsGluten, containsGluten) ||
                other.containsGluten == containsGluten) &&
            (identical(other.containsLactose, containsLactose) ||
                other.containsLactose == containsLactose) &&
            (identical(other.containsNuts, containsNuts) ||
                other.containsNuts == containsNuts) &&
            (identical(other.containsEggs, containsEggs) ||
                other.containsEggs == containsEggs) &&
            (identical(other.containsSoy, containsSoy) ||
                other.containsSoy == containsSoy) &&
            (identical(other.containsFish, containsFish) ||
                other.containsFish == containsFish) &&
            (identical(other.containsShellfish, containsShellfish) ||
                other.containsShellfish == containsShellfish));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        title,
        description,
        image,
        prepTimeMin,
        cookTimeMin,
        servings,
        difficulty,
        category,
        const DeepCollectionEquality().hash(_ingredients),
        const DeepCollectionEquality().hash(_steps),
        const DeepCollectionEquality().hash(_tags),
        vegetableId,
        source,
        userId,
        isPublic,
        isVegetarian,
        isVegan,
        containsGluten,
        containsLactose,
        containsNuts,
        containsEggs,
        containsSoy,
        containsFish,
        containsShellfish
      ]);

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
          required final String title,
          final String description,
          final String image,
          @JsonKey(name: 'prep_time_min') final int prepTimeMin,
          @JsonKey(name: 'cook_time_min') final int cookTimeMin,
          final int servings,
          final String? difficulty,
          final String? category,
          final List<dynamic> ingredients,
          final List<dynamic> steps,
          final List<dynamic> tags,
          @JsonKey(name: 'vegetable_id', fromJson: emptyToNull)
          final String? vegetableId,
          final String source,
          @JsonKey(name: 'user_id', fromJson: emptyToNull) final String? userId,
          @JsonKey(name: 'is_public') final bool isPublic,
          @JsonKey(name: 'is_vegetarian') final bool isVegetarian,
          @JsonKey(name: 'is_vegan') final bool isVegan,
          @JsonKey(name: 'contains_gluten') final bool containsGluten,
          @JsonKey(name: 'contains_lactose') final bool containsLactose,
          @JsonKey(name: 'contains_nuts') final bool containsNuts,
          @JsonKey(name: 'contains_eggs') final bool containsEggs,
          @JsonKey(name: 'contains_soy') final bool containsSoy,
          @JsonKey(name: 'contains_fish') final bool containsFish,
          @JsonKey(name: 'contains_shellfish') final bool containsShellfish}) =
      _$RecipeDtoImpl;

  factory _RecipeDto.fromJson(Map<String, dynamic> json) =
      _$RecipeDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get description;
  @override
  String get image; // === Zeiten (getrennt) ===
  @override
  @JsonKey(name: 'prep_time_min')
  int get prepTimeMin;
  @override
  @JsonKey(name: 'cook_time_min')
  int get cookTimeMin; // === Portionen & Schwierigkeit ===
  @override
  int get servings;
  @override
  String? get difficulty; // 'easy' | 'medium' | 'hard'
  @override
  String?
      get category; // 'main' | 'side' | 'dessert' | 'snack' | 'breakfast' | 'soup' | 'salad'
// === Inhalte (JSON) ===
  @override
  List<dynamic> get ingredients; // JSON array: [{item, amount, unit, note}]
  @override
  List<dynamic> get steps; // JSON array of strings
// === Tags ===
  @override
  List<dynamic> get tags; // Array: ["schnell", "günstig"]
// === Beziehungen ===
  @override
  @JsonKey(name: 'vegetable_id', fromJson: emptyToNull)
  String? get vegetableId; // === Ownership ===
  @override
  String get source; // 'curated' | 'user'
  @override
  @JsonKey(name: 'user_id', fromJson: emptyToNull)
  String? get userId;
  @override
  @JsonKey(name: 'is_public')
  bool get isPublic; // === Ernährung ===
  @override
  @JsonKey(name: 'is_vegetarian')
  bool get isVegetarian;
  @override
  @JsonKey(name: 'is_vegan')
  bool get isVegan; // === Allergene (contains = true wenn enthalten) ===
  @override
  @JsonKey(name: 'contains_gluten')
  bool get containsGluten;
  @override
  @JsonKey(name: 'contains_lactose')
  bool get containsLactose;
  @override
  @JsonKey(name: 'contains_nuts')
  bool get containsNuts;
  @override
  @JsonKey(name: 'contains_eggs')
  bool get containsEggs;
  @override
  @JsonKey(name: 'contains_soy')
  bool get containsSoy;
  @override
  @JsonKey(name: 'contains_fish')
  bool get containsFish;
  @override
  @JsonKey(name: 'contains_shellfish')
  bool get containsShellfish;

  /// Create a copy of RecipeDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecipeDtoImplCopyWith<_$RecipeDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

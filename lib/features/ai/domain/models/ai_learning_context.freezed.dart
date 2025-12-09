// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_learning_context.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AILearningContext _$AILearningContextFromJson(Map<String, dynamic> json) {
  return _AILearningContext.fromJson(json);
}

/// @nodoc
mixin _$AILearningContext {
  /// Derived from favorites & usage - most used ingredients
  List<String> get topIngredients => throw _privateConstructorUsedError;

  /// Category usage frequency: {"Suppe": 5, "Pasta": 8}
  Map<String, int> get categoryUsage => throw _privateConstructorUsedError;

  /// Ingredients/recipes the user accepted from AI suggestions
  List<String> get acceptedSuggestions => throw _privateConstructorUsedError;

  /// Ingredients/recipes the user rejected or regenerated
  List<String> get rejectedSuggestions => throw _privateConstructorUsedError;

  /// Days user typically cooks: [1,2,3,5] = Mo,Di,Mi,Fr
  List<int> get activeCookingDays => throw _privateConstructorUsedError;

  /// Average servings per meal
  double get avgServings => throw _privateConstructorUsedError;

  /// Total AI requests made
  int get totalAIRequests => throw _privateConstructorUsedError;

  /// Last AI interaction timestamp
  DateTime? get lastAIInteraction => throw _privateConstructorUsedError;

  /// Serializes this AILearningContext to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AILearningContext
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AILearningContextCopyWith<AILearningContext> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AILearningContextCopyWith<$Res> {
  factory $AILearningContextCopyWith(
          AILearningContext value, $Res Function(AILearningContext) then) =
      _$AILearningContextCopyWithImpl<$Res, AILearningContext>;
  @useResult
  $Res call(
      {List<String> topIngredients,
      Map<String, int> categoryUsage,
      List<String> acceptedSuggestions,
      List<String> rejectedSuggestions,
      List<int> activeCookingDays,
      double avgServings,
      int totalAIRequests,
      DateTime? lastAIInteraction});
}

/// @nodoc
class _$AILearningContextCopyWithImpl<$Res, $Val extends AILearningContext>
    implements $AILearningContextCopyWith<$Res> {
  _$AILearningContextCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AILearningContext
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? topIngredients = null,
    Object? categoryUsage = null,
    Object? acceptedSuggestions = null,
    Object? rejectedSuggestions = null,
    Object? activeCookingDays = null,
    Object? avgServings = null,
    Object? totalAIRequests = null,
    Object? lastAIInteraction = freezed,
  }) {
    return _then(_value.copyWith(
      topIngredients: null == topIngredients
          ? _value.topIngredients
          : topIngredients // ignore: cast_nullable_to_non_nullable
              as List<String>,
      categoryUsage: null == categoryUsage
          ? _value.categoryUsage
          : categoryUsage // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      acceptedSuggestions: null == acceptedSuggestions
          ? _value.acceptedSuggestions
          : acceptedSuggestions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      rejectedSuggestions: null == rejectedSuggestions
          ? _value.rejectedSuggestions
          : rejectedSuggestions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      activeCookingDays: null == activeCookingDays
          ? _value.activeCookingDays
          : activeCookingDays // ignore: cast_nullable_to_non_nullable
              as List<int>,
      avgServings: null == avgServings
          ? _value.avgServings
          : avgServings // ignore: cast_nullable_to_non_nullable
              as double,
      totalAIRequests: null == totalAIRequests
          ? _value.totalAIRequests
          : totalAIRequests // ignore: cast_nullable_to_non_nullable
              as int,
      lastAIInteraction: freezed == lastAIInteraction
          ? _value.lastAIInteraction
          : lastAIInteraction // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AILearningContextImplCopyWith<$Res>
    implements $AILearningContextCopyWith<$Res> {
  factory _$$AILearningContextImplCopyWith(_$AILearningContextImpl value,
          $Res Function(_$AILearningContextImpl) then) =
      __$$AILearningContextImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<String> topIngredients,
      Map<String, int> categoryUsage,
      List<String> acceptedSuggestions,
      List<String> rejectedSuggestions,
      List<int> activeCookingDays,
      double avgServings,
      int totalAIRequests,
      DateTime? lastAIInteraction});
}

/// @nodoc
class __$$AILearningContextImplCopyWithImpl<$Res>
    extends _$AILearningContextCopyWithImpl<$Res, _$AILearningContextImpl>
    implements _$$AILearningContextImplCopyWith<$Res> {
  __$$AILearningContextImplCopyWithImpl(_$AILearningContextImpl _value,
      $Res Function(_$AILearningContextImpl) _then)
      : super(_value, _then);

  /// Create a copy of AILearningContext
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? topIngredients = null,
    Object? categoryUsage = null,
    Object? acceptedSuggestions = null,
    Object? rejectedSuggestions = null,
    Object? activeCookingDays = null,
    Object? avgServings = null,
    Object? totalAIRequests = null,
    Object? lastAIInteraction = freezed,
  }) {
    return _then(_$AILearningContextImpl(
      topIngredients: null == topIngredients
          ? _value._topIngredients
          : topIngredients // ignore: cast_nullable_to_non_nullable
              as List<String>,
      categoryUsage: null == categoryUsage
          ? _value._categoryUsage
          : categoryUsage // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      acceptedSuggestions: null == acceptedSuggestions
          ? _value._acceptedSuggestions
          : acceptedSuggestions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      rejectedSuggestions: null == rejectedSuggestions
          ? _value._rejectedSuggestions
          : rejectedSuggestions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      activeCookingDays: null == activeCookingDays
          ? _value._activeCookingDays
          : activeCookingDays // ignore: cast_nullable_to_non_nullable
              as List<int>,
      avgServings: null == avgServings
          ? _value.avgServings
          : avgServings // ignore: cast_nullable_to_non_nullable
              as double,
      totalAIRequests: null == totalAIRequests
          ? _value.totalAIRequests
          : totalAIRequests // ignore: cast_nullable_to_non_nullable
              as int,
      lastAIInteraction: freezed == lastAIInteraction
          ? _value.lastAIInteraction
          : lastAIInteraction // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AILearningContextImpl implements _AILearningContext {
  const _$AILearningContextImpl(
      {final List<String> topIngredients = const [],
      final Map<String, int> categoryUsage = const {},
      final List<String> acceptedSuggestions = const [],
      final List<String> rejectedSuggestions = const [],
      final List<int> activeCookingDays = const [],
      this.avgServings = 2.0,
      this.totalAIRequests = 0,
      this.lastAIInteraction})
      : _topIngredients = topIngredients,
        _categoryUsage = categoryUsage,
        _acceptedSuggestions = acceptedSuggestions,
        _rejectedSuggestions = rejectedSuggestions,
        _activeCookingDays = activeCookingDays;

  factory _$AILearningContextImpl.fromJson(Map<String, dynamic> json) =>
      _$$AILearningContextImplFromJson(json);

  /// Derived from favorites & usage - most used ingredients
  final List<String> _topIngredients;

  /// Derived from favorites & usage - most used ingredients
  @override
  @JsonKey()
  List<String> get topIngredients {
    if (_topIngredients is EqualUnmodifiableListView) return _topIngredients;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_topIngredients);
  }

  /// Category usage frequency: {"Suppe": 5, "Pasta": 8}
  final Map<String, int> _categoryUsage;

  /// Category usage frequency: {"Suppe": 5, "Pasta": 8}
  @override
  @JsonKey()
  Map<String, int> get categoryUsage {
    if (_categoryUsage is EqualUnmodifiableMapView) return _categoryUsage;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_categoryUsage);
  }

  /// Ingredients/recipes the user accepted from AI suggestions
  final List<String> _acceptedSuggestions;

  /// Ingredients/recipes the user accepted from AI suggestions
  @override
  @JsonKey()
  List<String> get acceptedSuggestions {
    if (_acceptedSuggestions is EqualUnmodifiableListView)
      return _acceptedSuggestions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_acceptedSuggestions);
  }

  /// Ingredients/recipes the user rejected or regenerated
  final List<String> _rejectedSuggestions;

  /// Ingredients/recipes the user rejected or regenerated
  @override
  @JsonKey()
  List<String> get rejectedSuggestions {
    if (_rejectedSuggestions is EqualUnmodifiableListView)
      return _rejectedSuggestions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_rejectedSuggestions);
  }

  /// Days user typically cooks: [1,2,3,5] = Mo,Di,Mi,Fr
  final List<int> _activeCookingDays;

  /// Days user typically cooks: [1,2,3,5] = Mo,Di,Mi,Fr
  @override
  @JsonKey()
  List<int> get activeCookingDays {
    if (_activeCookingDays is EqualUnmodifiableListView)
      return _activeCookingDays;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_activeCookingDays);
  }

  /// Average servings per meal
  @override
  @JsonKey()
  final double avgServings;

  /// Total AI requests made
  @override
  @JsonKey()
  final int totalAIRequests;

  /// Last AI interaction timestamp
  @override
  final DateTime? lastAIInteraction;

  @override
  String toString() {
    return 'AILearningContext(topIngredients: $topIngredients, categoryUsage: $categoryUsage, acceptedSuggestions: $acceptedSuggestions, rejectedSuggestions: $rejectedSuggestions, activeCookingDays: $activeCookingDays, avgServings: $avgServings, totalAIRequests: $totalAIRequests, lastAIInteraction: $lastAIInteraction)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AILearningContextImpl &&
            const DeepCollectionEquality()
                .equals(other._topIngredients, _topIngredients) &&
            const DeepCollectionEquality()
                .equals(other._categoryUsage, _categoryUsage) &&
            const DeepCollectionEquality()
                .equals(other._acceptedSuggestions, _acceptedSuggestions) &&
            const DeepCollectionEquality()
                .equals(other._rejectedSuggestions, _rejectedSuggestions) &&
            const DeepCollectionEquality()
                .equals(other._activeCookingDays, _activeCookingDays) &&
            (identical(other.avgServings, avgServings) ||
                other.avgServings == avgServings) &&
            (identical(other.totalAIRequests, totalAIRequests) ||
                other.totalAIRequests == totalAIRequests) &&
            (identical(other.lastAIInteraction, lastAIInteraction) ||
                other.lastAIInteraction == lastAIInteraction));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_topIngredients),
      const DeepCollectionEquality().hash(_categoryUsage),
      const DeepCollectionEquality().hash(_acceptedSuggestions),
      const DeepCollectionEquality().hash(_rejectedSuggestions),
      const DeepCollectionEquality().hash(_activeCookingDays),
      avgServings,
      totalAIRequests,
      lastAIInteraction);

  /// Create a copy of AILearningContext
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AILearningContextImplCopyWith<_$AILearningContextImpl> get copyWith =>
      __$$AILearningContextImplCopyWithImpl<_$AILearningContextImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AILearningContextImplToJson(
      this,
    );
  }
}

abstract class _AILearningContext implements AILearningContext {
  const factory _AILearningContext(
      {final List<String> topIngredients,
      final Map<String, int> categoryUsage,
      final List<String> acceptedSuggestions,
      final List<String> rejectedSuggestions,
      final List<int> activeCookingDays,
      final double avgServings,
      final int totalAIRequests,
      final DateTime? lastAIInteraction}) = _$AILearningContextImpl;

  factory _AILearningContext.fromJson(Map<String, dynamic> json) =
      _$AILearningContextImpl.fromJson;

  /// Derived from favorites & usage - most used ingredients
  @override
  List<String> get topIngredients;

  /// Category usage frequency: {"Suppe": 5, "Pasta": 8}
  @override
  Map<String, int> get categoryUsage;

  /// Ingredients/recipes the user accepted from AI suggestions
  @override
  List<String> get acceptedSuggestions;

  /// Ingredients/recipes the user rejected or regenerated
  @override
  List<String> get rejectedSuggestions;

  /// Days user typically cooks: [1,2,3,5] = Mo,Di,Mi,Fr
  @override
  List<int> get activeCookingDays;

  /// Average servings per meal
  @override
  double get avgServings;

  /// Total AI requests made
  @override
  int get totalAIRequests;

  /// Last AI interaction timestamp
  @override
  DateTime? get lastAIInteraction;

  /// Create a copy of AILearningContext
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AILearningContextImplCopyWith<_$AILearningContextImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

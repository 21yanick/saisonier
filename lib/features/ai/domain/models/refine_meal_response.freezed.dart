// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'refine_meal_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RefineMealResponse _$RefineMealResponseFromJson(Map<String, dynamic> json) {
  return _RefineMealResponse.fromJson(json);
}

/// @nodoc
mixin _$RefineMealResponse {
  String get response => throw _privateConstructorUsedError;
  List<MealSuggestion> get suggestions => throw _privateConstructorUsedError;

  /// Serializes this RefineMealResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RefineMealResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RefineMealResponseCopyWith<RefineMealResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RefineMealResponseCopyWith<$Res> {
  factory $RefineMealResponseCopyWith(
          RefineMealResponse value, $Res Function(RefineMealResponse) then) =
      _$RefineMealResponseCopyWithImpl<$Res, RefineMealResponse>;
  @useResult
  $Res call({String response, List<MealSuggestion> suggestions});
}

/// @nodoc
class _$RefineMealResponseCopyWithImpl<$Res, $Val extends RefineMealResponse>
    implements $RefineMealResponseCopyWith<$Res> {
  _$RefineMealResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RefineMealResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? response = null,
    Object? suggestions = null,
  }) {
    return _then(_value.copyWith(
      response: null == response
          ? _value.response
          : response // ignore: cast_nullable_to_non_nullable
              as String,
      suggestions: null == suggestions
          ? _value.suggestions
          : suggestions // ignore: cast_nullable_to_non_nullable
              as List<MealSuggestion>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RefineMealResponseImplCopyWith<$Res>
    implements $RefineMealResponseCopyWith<$Res> {
  factory _$$RefineMealResponseImplCopyWith(_$RefineMealResponseImpl value,
          $Res Function(_$RefineMealResponseImpl) then) =
      __$$RefineMealResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String response, List<MealSuggestion> suggestions});
}

/// @nodoc
class __$$RefineMealResponseImplCopyWithImpl<$Res>
    extends _$RefineMealResponseCopyWithImpl<$Res, _$RefineMealResponseImpl>
    implements _$$RefineMealResponseImplCopyWith<$Res> {
  __$$RefineMealResponseImplCopyWithImpl(_$RefineMealResponseImpl _value,
      $Res Function(_$RefineMealResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of RefineMealResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? response = null,
    Object? suggestions = null,
  }) {
    return _then(_$RefineMealResponseImpl(
      response: null == response
          ? _value.response
          : response // ignore: cast_nullable_to_non_nullable
              as String,
      suggestions: null == suggestions
          ? _value._suggestions
          : suggestions // ignore: cast_nullable_to_non_nullable
              as List<MealSuggestion>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RefineMealResponseImpl implements _RefineMealResponse {
  const _$RefineMealResponseImpl(
      {required this.response, required final List<MealSuggestion> suggestions})
      : _suggestions = suggestions;

  factory _$RefineMealResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$RefineMealResponseImplFromJson(json);

  @override
  final String response;
  final List<MealSuggestion> _suggestions;
  @override
  List<MealSuggestion> get suggestions {
    if (_suggestions is EqualUnmodifiableListView) return _suggestions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_suggestions);
  }

  @override
  String toString() {
    return 'RefineMealResponse(response: $response, suggestions: $suggestions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RefineMealResponseImpl &&
            (identical(other.response, response) ||
                other.response == response) &&
            const DeepCollectionEquality()
                .equals(other._suggestions, _suggestions));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, response, const DeepCollectionEquality().hash(_suggestions));

  /// Create a copy of RefineMealResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RefineMealResponseImplCopyWith<_$RefineMealResponseImpl> get copyWith =>
      __$$RefineMealResponseImplCopyWithImpl<_$RefineMealResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RefineMealResponseImplToJson(
      this,
    );
  }
}

abstract class _RefineMealResponse implements RefineMealResponse {
  const factory _RefineMealResponse(
          {required final String response,
          required final List<MealSuggestion> suggestions}) =
      _$RefineMealResponseImpl;

  factory _RefineMealResponse.fromJson(Map<String, dynamic> json) =
      _$RefineMealResponseImpl.fromJson;

  @override
  String get response;
  @override
  List<MealSuggestion> get suggestions;

  /// Create a copy of RefineMealResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RefineMealResponseImplCopyWith<_$RefineMealResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MealSuggestion _$MealSuggestionFromJson(Map<String, dynamic> json) {
  return _MealSuggestion.fromJson(json);
}

/// @nodoc
mixin _$MealSuggestion {
  String? get recipeId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get reasoning => throw _privateConstructorUsedError;
  int? get cookTimeMin => throw _privateConstructorUsedError;
  Map<String, dynamic>? get recipe => throw _privateConstructorUsedError;

  /// Serializes this MealSuggestion to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MealSuggestion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MealSuggestionCopyWith<MealSuggestion> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MealSuggestionCopyWith<$Res> {
  factory $MealSuggestionCopyWith(
          MealSuggestion value, $Res Function(MealSuggestion) then) =
      _$MealSuggestionCopyWithImpl<$Res, MealSuggestion>;
  @useResult
  $Res call(
      {String? recipeId,
      String title,
      String reasoning,
      int? cookTimeMin,
      Map<String, dynamic>? recipe});
}

/// @nodoc
class _$MealSuggestionCopyWithImpl<$Res, $Val extends MealSuggestion>
    implements $MealSuggestionCopyWith<$Res> {
  _$MealSuggestionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MealSuggestion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? recipeId = freezed,
    Object? title = null,
    Object? reasoning = null,
    Object? cookTimeMin = freezed,
    Object? recipe = freezed,
  }) {
    return _then(_value.copyWith(
      recipeId: freezed == recipeId
          ? _value.recipeId
          : recipeId // ignore: cast_nullable_to_non_nullable
              as String?,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      reasoning: null == reasoning
          ? _value.reasoning
          : reasoning // ignore: cast_nullable_to_non_nullable
              as String,
      cookTimeMin: freezed == cookTimeMin
          ? _value.cookTimeMin
          : cookTimeMin // ignore: cast_nullable_to_non_nullable
              as int?,
      recipe: freezed == recipe
          ? _value.recipe
          : recipe // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MealSuggestionImplCopyWith<$Res>
    implements $MealSuggestionCopyWith<$Res> {
  factory _$$MealSuggestionImplCopyWith(_$MealSuggestionImpl value,
          $Res Function(_$MealSuggestionImpl) then) =
      __$$MealSuggestionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? recipeId,
      String title,
      String reasoning,
      int? cookTimeMin,
      Map<String, dynamic>? recipe});
}

/// @nodoc
class __$$MealSuggestionImplCopyWithImpl<$Res>
    extends _$MealSuggestionCopyWithImpl<$Res, _$MealSuggestionImpl>
    implements _$$MealSuggestionImplCopyWith<$Res> {
  __$$MealSuggestionImplCopyWithImpl(
      _$MealSuggestionImpl _value, $Res Function(_$MealSuggestionImpl) _then)
      : super(_value, _then);

  /// Create a copy of MealSuggestion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? recipeId = freezed,
    Object? title = null,
    Object? reasoning = null,
    Object? cookTimeMin = freezed,
    Object? recipe = freezed,
  }) {
    return _then(_$MealSuggestionImpl(
      recipeId: freezed == recipeId
          ? _value.recipeId
          : recipeId // ignore: cast_nullable_to_non_nullable
              as String?,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      reasoning: null == reasoning
          ? _value.reasoning
          : reasoning // ignore: cast_nullable_to_non_nullable
              as String,
      cookTimeMin: freezed == cookTimeMin
          ? _value.cookTimeMin
          : cookTimeMin // ignore: cast_nullable_to_non_nullable
              as int?,
      recipe: freezed == recipe
          ? _value._recipe
          : recipe // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MealSuggestionImpl implements _MealSuggestion {
  const _$MealSuggestionImpl(
      {this.recipeId,
      required this.title,
      required this.reasoning,
      this.cookTimeMin,
      final Map<String, dynamic>? recipe})
      : _recipe = recipe;

  factory _$MealSuggestionImpl.fromJson(Map<String, dynamic> json) =>
      _$$MealSuggestionImplFromJson(json);

  @override
  final String? recipeId;
  @override
  final String title;
  @override
  final String reasoning;
  @override
  final int? cookTimeMin;
  final Map<String, dynamic>? _recipe;
  @override
  Map<String, dynamic>? get recipe {
    final value = _recipe;
    if (value == null) return null;
    if (_recipe is EqualUnmodifiableMapView) return _recipe;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'MealSuggestion(recipeId: $recipeId, title: $title, reasoning: $reasoning, cookTimeMin: $cookTimeMin, recipe: $recipe)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MealSuggestionImpl &&
            (identical(other.recipeId, recipeId) ||
                other.recipeId == recipeId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.reasoning, reasoning) ||
                other.reasoning == reasoning) &&
            (identical(other.cookTimeMin, cookTimeMin) ||
                other.cookTimeMin == cookTimeMin) &&
            const DeepCollectionEquality().equals(other._recipe, _recipe));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, recipeId, title, reasoning,
      cookTimeMin, const DeepCollectionEquality().hash(_recipe));

  /// Create a copy of MealSuggestion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MealSuggestionImplCopyWith<_$MealSuggestionImpl> get copyWith =>
      __$$MealSuggestionImplCopyWithImpl<_$MealSuggestionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MealSuggestionImplToJson(
      this,
    );
  }
}

abstract class _MealSuggestion implements MealSuggestion {
  const factory _MealSuggestion(
      {final String? recipeId,
      required final String title,
      required final String reasoning,
      final int? cookTimeMin,
      final Map<String, dynamic>? recipe}) = _$MealSuggestionImpl;

  factory _MealSuggestion.fromJson(Map<String, dynamic> json) =
      _$MealSuggestionImpl.fromJson;

  @override
  String? get recipeId;
  @override
  String get title;
  @override
  String get reasoning;
  @override
  int? get cookTimeMin;
  @override
  Map<String, dynamic>? get recipe;

  /// Create a copy of MealSuggestion
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MealSuggestionImplCopyWith<_$MealSuggestionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

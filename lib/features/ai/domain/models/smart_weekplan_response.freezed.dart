// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'smart_weekplan_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SmartWeekplanResponse _$SmartWeekplanResponseFromJson(
    Map<String, dynamic> json) {
  return _SmartWeekplanResponse.fromJson(json);
}

/// @nodoc
mixin _$SmartWeekplanResponse {
  ContextAnalysis get contextAnalysis => throw _privateConstructorUsedError;
  List<PlannedDay> get weekplan => throw _privateConstructorUsedError;
  Map<String, dynamic> get recipes => throw _privateConstructorUsedError;
  StrategyInsights get strategy => throw _privateConstructorUsedError;
  int get eligibleRecipeCount => throw _privateConstructorUsedError;

  /// Serializes this SmartWeekplanResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SmartWeekplanResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SmartWeekplanResponseCopyWith<SmartWeekplanResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SmartWeekplanResponseCopyWith<$Res> {
  factory $SmartWeekplanResponseCopyWith(SmartWeekplanResponse value,
          $Res Function(SmartWeekplanResponse) then) =
      _$SmartWeekplanResponseCopyWithImpl<$Res, SmartWeekplanResponse>;
  @useResult
  $Res call(
      {ContextAnalysis contextAnalysis,
      List<PlannedDay> weekplan,
      Map<String, dynamic> recipes,
      StrategyInsights strategy,
      int eligibleRecipeCount});

  $ContextAnalysisCopyWith<$Res> get contextAnalysis;
  $StrategyInsightsCopyWith<$Res> get strategy;
}

/// @nodoc
class _$SmartWeekplanResponseCopyWithImpl<$Res,
        $Val extends SmartWeekplanResponse>
    implements $SmartWeekplanResponseCopyWith<$Res> {
  _$SmartWeekplanResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SmartWeekplanResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contextAnalysis = null,
    Object? weekplan = null,
    Object? recipes = null,
    Object? strategy = null,
    Object? eligibleRecipeCount = null,
  }) {
    return _then(_value.copyWith(
      contextAnalysis: null == contextAnalysis
          ? _value.contextAnalysis
          : contextAnalysis // ignore: cast_nullable_to_non_nullable
              as ContextAnalysis,
      weekplan: null == weekplan
          ? _value.weekplan
          : weekplan // ignore: cast_nullable_to_non_nullable
              as List<PlannedDay>,
      recipes: null == recipes
          ? _value.recipes
          : recipes // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      strategy: null == strategy
          ? _value.strategy
          : strategy // ignore: cast_nullable_to_non_nullable
              as StrategyInsights,
      eligibleRecipeCount: null == eligibleRecipeCount
          ? _value.eligibleRecipeCount
          : eligibleRecipeCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }

  /// Create a copy of SmartWeekplanResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ContextAnalysisCopyWith<$Res> get contextAnalysis {
    return $ContextAnalysisCopyWith<$Res>(_value.contextAnalysis, (value) {
      return _then(_value.copyWith(contextAnalysis: value) as $Val);
    });
  }

  /// Create a copy of SmartWeekplanResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $StrategyInsightsCopyWith<$Res> get strategy {
    return $StrategyInsightsCopyWith<$Res>(_value.strategy, (value) {
      return _then(_value.copyWith(strategy: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SmartWeekplanResponseImplCopyWith<$Res>
    implements $SmartWeekplanResponseCopyWith<$Res> {
  factory _$$SmartWeekplanResponseImplCopyWith(
          _$SmartWeekplanResponseImpl value,
          $Res Function(_$SmartWeekplanResponseImpl) then) =
      __$$SmartWeekplanResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {ContextAnalysis contextAnalysis,
      List<PlannedDay> weekplan,
      Map<String, dynamic> recipes,
      StrategyInsights strategy,
      int eligibleRecipeCount});

  @override
  $ContextAnalysisCopyWith<$Res> get contextAnalysis;
  @override
  $StrategyInsightsCopyWith<$Res> get strategy;
}

/// @nodoc
class __$$SmartWeekplanResponseImplCopyWithImpl<$Res>
    extends _$SmartWeekplanResponseCopyWithImpl<$Res,
        _$SmartWeekplanResponseImpl>
    implements _$$SmartWeekplanResponseImplCopyWith<$Res> {
  __$$SmartWeekplanResponseImplCopyWithImpl(_$SmartWeekplanResponseImpl _value,
      $Res Function(_$SmartWeekplanResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of SmartWeekplanResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contextAnalysis = null,
    Object? weekplan = null,
    Object? recipes = null,
    Object? strategy = null,
    Object? eligibleRecipeCount = null,
  }) {
    return _then(_$SmartWeekplanResponseImpl(
      contextAnalysis: null == contextAnalysis
          ? _value.contextAnalysis
          : contextAnalysis // ignore: cast_nullable_to_non_nullable
              as ContextAnalysis,
      weekplan: null == weekplan
          ? _value._weekplan
          : weekplan // ignore: cast_nullable_to_non_nullable
              as List<PlannedDay>,
      recipes: null == recipes
          ? _value._recipes
          : recipes // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      strategy: null == strategy
          ? _value.strategy
          : strategy // ignore: cast_nullable_to_non_nullable
              as StrategyInsights,
      eligibleRecipeCount: null == eligibleRecipeCount
          ? _value.eligibleRecipeCount
          : eligibleRecipeCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SmartWeekplanResponseImpl implements _SmartWeekplanResponse {
  const _$SmartWeekplanResponseImpl(
      {required this.contextAnalysis,
      required final List<PlannedDay> weekplan,
      required final Map<String, dynamic> recipes,
      required this.strategy,
      this.eligibleRecipeCount = 0})
      : _weekplan = weekplan,
        _recipes = recipes;

  factory _$SmartWeekplanResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$SmartWeekplanResponseImplFromJson(json);

  @override
  final ContextAnalysis contextAnalysis;
  final List<PlannedDay> _weekplan;
  @override
  List<PlannedDay> get weekplan {
    if (_weekplan is EqualUnmodifiableListView) return _weekplan;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_weekplan);
  }

  final Map<String, dynamic> _recipes;
  @override
  Map<String, dynamic> get recipes {
    if (_recipes is EqualUnmodifiableMapView) return _recipes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_recipes);
  }

  @override
  final StrategyInsights strategy;
  @override
  @JsonKey()
  final int eligibleRecipeCount;

  @override
  String toString() {
    return 'SmartWeekplanResponse(contextAnalysis: $contextAnalysis, weekplan: $weekplan, recipes: $recipes, strategy: $strategy, eligibleRecipeCount: $eligibleRecipeCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SmartWeekplanResponseImpl &&
            (identical(other.contextAnalysis, contextAnalysis) ||
                other.contextAnalysis == contextAnalysis) &&
            const DeepCollectionEquality().equals(other._weekplan, _weekplan) &&
            const DeepCollectionEquality().equals(other._recipes, _recipes) &&
            (identical(other.strategy, strategy) ||
                other.strategy == strategy) &&
            (identical(other.eligibleRecipeCount, eligibleRecipeCount) ||
                other.eligibleRecipeCount == eligibleRecipeCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      contextAnalysis,
      const DeepCollectionEquality().hash(_weekplan),
      const DeepCollectionEquality().hash(_recipes),
      strategy,
      eligibleRecipeCount);

  /// Create a copy of SmartWeekplanResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SmartWeekplanResponseImplCopyWith<_$SmartWeekplanResponseImpl>
      get copyWith => __$$SmartWeekplanResponseImplCopyWithImpl<
          _$SmartWeekplanResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SmartWeekplanResponseImplToJson(
      this,
    );
  }
}

abstract class _SmartWeekplanResponse implements SmartWeekplanResponse {
  const factory _SmartWeekplanResponse(
      {required final ContextAnalysis contextAnalysis,
      required final List<PlannedDay> weekplan,
      required final Map<String, dynamic> recipes,
      required final StrategyInsights strategy,
      final int eligibleRecipeCount}) = _$SmartWeekplanResponseImpl;

  factory _SmartWeekplanResponse.fromJson(Map<String, dynamic> json) =
      _$SmartWeekplanResponseImpl.fromJson;

  @override
  ContextAnalysis get contextAnalysis;
  @override
  List<PlannedDay> get weekplan;
  @override
  Map<String, dynamic> get recipes;
  @override
  StrategyInsights get strategy;
  @override
  int get eligibleRecipeCount;

  /// Create a copy of SmartWeekplanResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SmartWeekplanResponseImplCopyWith<_$SmartWeekplanResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ContextAnalysis _$ContextAnalysisFromJson(Map<String, dynamic> json) {
  return _ContextAnalysis.fromJson(json);
}

/// @nodoc
mixin _$ContextAnalysis {
  Map<String, String> get timeConstraints => throw _privateConstructorUsedError;
  Map<String, EventInfo> get events => throw _privateConstructorUsedError;
  List<String> get ingredientsToUse => throw _privateConstructorUsedError;
  String? get displaySummary => throw _privateConstructorUsedError;

  /// Serializes this ContextAnalysis to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ContextAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ContextAnalysisCopyWith<ContextAnalysis> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContextAnalysisCopyWith<$Res> {
  factory $ContextAnalysisCopyWith(
          ContextAnalysis value, $Res Function(ContextAnalysis) then) =
      _$ContextAnalysisCopyWithImpl<$Res, ContextAnalysis>;
  @useResult
  $Res call(
      {Map<String, String> timeConstraints,
      Map<String, EventInfo> events,
      List<String> ingredientsToUse,
      String? displaySummary});
}

/// @nodoc
class _$ContextAnalysisCopyWithImpl<$Res, $Val extends ContextAnalysis>
    implements $ContextAnalysisCopyWith<$Res> {
  _$ContextAnalysisCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ContextAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? timeConstraints = null,
    Object? events = null,
    Object? ingredientsToUse = null,
    Object? displaySummary = freezed,
  }) {
    return _then(_value.copyWith(
      timeConstraints: null == timeConstraints
          ? _value.timeConstraints
          : timeConstraints // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      events: null == events
          ? _value.events
          : events // ignore: cast_nullable_to_non_nullable
              as Map<String, EventInfo>,
      ingredientsToUse: null == ingredientsToUse
          ? _value.ingredientsToUse
          : ingredientsToUse // ignore: cast_nullable_to_non_nullable
              as List<String>,
      displaySummary: freezed == displaySummary
          ? _value.displaySummary
          : displaySummary // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ContextAnalysisImplCopyWith<$Res>
    implements $ContextAnalysisCopyWith<$Res> {
  factory _$$ContextAnalysisImplCopyWith(_$ContextAnalysisImpl value,
          $Res Function(_$ContextAnalysisImpl) then) =
      __$$ContextAnalysisImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Map<String, String> timeConstraints,
      Map<String, EventInfo> events,
      List<String> ingredientsToUse,
      String? displaySummary});
}

/// @nodoc
class __$$ContextAnalysisImplCopyWithImpl<$Res>
    extends _$ContextAnalysisCopyWithImpl<$Res, _$ContextAnalysisImpl>
    implements _$$ContextAnalysisImplCopyWith<$Res> {
  __$$ContextAnalysisImplCopyWithImpl(
      _$ContextAnalysisImpl _value, $Res Function(_$ContextAnalysisImpl) _then)
      : super(_value, _then);

  /// Create a copy of ContextAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? timeConstraints = null,
    Object? events = null,
    Object? ingredientsToUse = null,
    Object? displaySummary = freezed,
  }) {
    return _then(_$ContextAnalysisImpl(
      timeConstraints: null == timeConstraints
          ? _value._timeConstraints
          : timeConstraints // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      events: null == events
          ? _value._events
          : events // ignore: cast_nullable_to_non_nullable
              as Map<String, EventInfo>,
      ingredientsToUse: null == ingredientsToUse
          ? _value._ingredientsToUse
          : ingredientsToUse // ignore: cast_nullable_to_non_nullable
              as List<String>,
      displaySummary: freezed == displaySummary
          ? _value.displaySummary
          : displaySummary // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ContextAnalysisImpl implements _ContextAnalysis {
  const _$ContextAnalysisImpl(
      {final Map<String, String> timeConstraints = const {},
      final Map<String, EventInfo> events = const {},
      final List<String> ingredientsToUse = const [],
      this.displaySummary})
      : _timeConstraints = timeConstraints,
        _events = events,
        _ingredientsToUse = ingredientsToUse;

  factory _$ContextAnalysisImpl.fromJson(Map<String, dynamic> json) =>
      _$$ContextAnalysisImplFromJson(json);

  final Map<String, String> _timeConstraints;
  @override
  @JsonKey()
  Map<String, String> get timeConstraints {
    if (_timeConstraints is EqualUnmodifiableMapView) return _timeConstraints;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_timeConstraints);
  }

  final Map<String, EventInfo> _events;
  @override
  @JsonKey()
  Map<String, EventInfo> get events {
    if (_events is EqualUnmodifiableMapView) return _events;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_events);
  }

  final List<String> _ingredientsToUse;
  @override
  @JsonKey()
  List<String> get ingredientsToUse {
    if (_ingredientsToUse is EqualUnmodifiableListView)
      return _ingredientsToUse;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_ingredientsToUse);
  }

  @override
  final String? displaySummary;

  @override
  String toString() {
    return 'ContextAnalysis(timeConstraints: $timeConstraints, events: $events, ingredientsToUse: $ingredientsToUse, displaySummary: $displaySummary)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContextAnalysisImpl &&
            const DeepCollectionEquality()
                .equals(other._timeConstraints, _timeConstraints) &&
            const DeepCollectionEquality().equals(other._events, _events) &&
            const DeepCollectionEquality()
                .equals(other._ingredientsToUse, _ingredientsToUse) &&
            (identical(other.displaySummary, displaySummary) ||
                other.displaySummary == displaySummary));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_timeConstraints),
      const DeepCollectionEquality().hash(_events),
      const DeepCollectionEquality().hash(_ingredientsToUse),
      displaySummary);

  /// Create a copy of ContextAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ContextAnalysisImplCopyWith<_$ContextAnalysisImpl> get copyWith =>
      __$$ContextAnalysisImplCopyWithImpl<_$ContextAnalysisImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ContextAnalysisImplToJson(
      this,
    );
  }
}

abstract class _ContextAnalysis implements ContextAnalysis {
  const factory _ContextAnalysis(
      {final Map<String, String> timeConstraints,
      final Map<String, EventInfo> events,
      final List<String> ingredientsToUse,
      final String? displaySummary}) = _$ContextAnalysisImpl;

  factory _ContextAnalysis.fromJson(Map<String, dynamic> json) =
      _$ContextAnalysisImpl.fromJson;

  @override
  Map<String, String> get timeConstraints;
  @override
  Map<String, EventInfo> get events;
  @override
  List<String> get ingredientsToUse;
  @override
  String? get displaySummary;

  /// Create a copy of ContextAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ContextAnalysisImplCopyWith<_$ContextAnalysisImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

EventInfo _$EventInfoFromJson(Map<String, dynamic> json) {
  return _EventInfo.fromJson(json);
}

/// @nodoc
mixin _$EventInfo {
  String get type => throw _privateConstructorUsedError;
  int? get guestCount => throw _privateConstructorUsedError;

  /// Serializes this EventInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EventInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EventInfoCopyWith<EventInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventInfoCopyWith<$Res> {
  factory $EventInfoCopyWith(EventInfo value, $Res Function(EventInfo) then) =
      _$EventInfoCopyWithImpl<$Res, EventInfo>;
  @useResult
  $Res call({String type, int? guestCount});
}

/// @nodoc
class _$EventInfoCopyWithImpl<$Res, $Val extends EventInfo>
    implements $EventInfoCopyWith<$Res> {
  _$EventInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EventInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? guestCount = freezed,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      guestCount: freezed == guestCount
          ? _value.guestCount
          : guestCount // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EventInfoImplCopyWith<$Res>
    implements $EventInfoCopyWith<$Res> {
  factory _$$EventInfoImplCopyWith(
          _$EventInfoImpl value, $Res Function(_$EventInfoImpl) then) =
      __$$EventInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String type, int? guestCount});
}

/// @nodoc
class __$$EventInfoImplCopyWithImpl<$Res>
    extends _$EventInfoCopyWithImpl<$Res, _$EventInfoImpl>
    implements _$$EventInfoImplCopyWith<$Res> {
  __$$EventInfoImplCopyWithImpl(
      _$EventInfoImpl _value, $Res Function(_$EventInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of EventInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? guestCount = freezed,
  }) {
    return _then(_$EventInfoImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      guestCount: freezed == guestCount
          ? _value.guestCount
          : guestCount // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EventInfoImpl implements _EventInfo {
  const _$EventInfoImpl({required this.type, this.guestCount});

  factory _$EventInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventInfoImplFromJson(json);

  @override
  final String type;
  @override
  final int? guestCount;

  @override
  String toString() {
    return 'EventInfo(type: $type, guestCount: $guestCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventInfoImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.guestCount, guestCount) ||
                other.guestCount == guestCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, type, guestCount);

  /// Create a copy of EventInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EventInfoImplCopyWith<_$EventInfoImpl> get copyWith =>
      __$$EventInfoImplCopyWithImpl<_$EventInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EventInfoImplToJson(
      this,
    );
  }
}

abstract class _EventInfo implements EventInfo {
  const factory _EventInfo(
      {required final String type, final int? guestCount}) = _$EventInfoImpl;

  factory _EventInfo.fromJson(Map<String, dynamic> json) =
      _$EventInfoImpl.fromJson;

  @override
  String get type;
  @override
  int? get guestCount;

  /// Create a copy of EventInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EventInfoImplCopyWith<_$EventInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PlannedDay _$PlannedDayFromJson(Map<String, dynamic> json) {
  return _PlannedDay.fromJson(json);
}

/// @nodoc
mixin _$PlannedDay {
  String get date => throw _privateConstructorUsedError;
  String get dayName => throw _privateConstructorUsedError;
  String? get dayContext => throw _privateConstructorUsedError;
  Map<String, PlannedMealSlot> get meals => throw _privateConstructorUsedError;

  /// Serializes this PlannedDay to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PlannedDay
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlannedDayCopyWith<PlannedDay> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlannedDayCopyWith<$Res> {
  factory $PlannedDayCopyWith(
          PlannedDay value, $Res Function(PlannedDay) then) =
      _$PlannedDayCopyWithImpl<$Res, PlannedDay>;
  @useResult
  $Res call(
      {String date,
      String dayName,
      String? dayContext,
      Map<String, PlannedMealSlot> meals});
}

/// @nodoc
class _$PlannedDayCopyWithImpl<$Res, $Val extends PlannedDay>
    implements $PlannedDayCopyWith<$Res> {
  _$PlannedDayCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlannedDay
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? dayName = null,
    Object? dayContext = freezed,
    Object? meals = null,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      dayName: null == dayName
          ? _value.dayName
          : dayName // ignore: cast_nullable_to_non_nullable
              as String,
      dayContext: freezed == dayContext
          ? _value.dayContext
          : dayContext // ignore: cast_nullable_to_non_nullable
              as String?,
      meals: null == meals
          ? _value.meals
          : meals // ignore: cast_nullable_to_non_nullable
              as Map<String, PlannedMealSlot>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PlannedDayImplCopyWith<$Res>
    implements $PlannedDayCopyWith<$Res> {
  factory _$$PlannedDayImplCopyWith(
          _$PlannedDayImpl value, $Res Function(_$PlannedDayImpl) then) =
      __$$PlannedDayImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String date,
      String dayName,
      String? dayContext,
      Map<String, PlannedMealSlot> meals});
}

/// @nodoc
class __$$PlannedDayImplCopyWithImpl<$Res>
    extends _$PlannedDayCopyWithImpl<$Res, _$PlannedDayImpl>
    implements _$$PlannedDayImplCopyWith<$Res> {
  __$$PlannedDayImplCopyWithImpl(
      _$PlannedDayImpl _value, $Res Function(_$PlannedDayImpl) _then)
      : super(_value, _then);

  /// Create a copy of PlannedDay
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? dayName = null,
    Object? dayContext = freezed,
    Object? meals = null,
  }) {
    return _then(_$PlannedDayImpl(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      dayName: null == dayName
          ? _value.dayName
          : dayName // ignore: cast_nullable_to_non_nullable
              as String,
      dayContext: freezed == dayContext
          ? _value.dayContext
          : dayContext // ignore: cast_nullable_to_non_nullable
              as String?,
      meals: null == meals
          ? _value._meals
          : meals // ignore: cast_nullable_to_non_nullable
              as Map<String, PlannedMealSlot>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PlannedDayImpl implements _PlannedDay {
  const _$PlannedDayImpl(
      {required this.date,
      required this.dayName,
      this.dayContext,
      required final Map<String, PlannedMealSlot> meals})
      : _meals = meals;

  factory _$PlannedDayImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlannedDayImplFromJson(json);

  @override
  final String date;
  @override
  final String dayName;
  @override
  final String? dayContext;
  final Map<String, PlannedMealSlot> _meals;
  @override
  Map<String, PlannedMealSlot> get meals {
    if (_meals is EqualUnmodifiableMapView) return _meals;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_meals);
  }

  @override
  String toString() {
    return 'PlannedDay(date: $date, dayName: $dayName, dayContext: $dayContext, meals: $meals)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlannedDayImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.dayName, dayName) || other.dayName == dayName) &&
            (identical(other.dayContext, dayContext) ||
                other.dayContext == dayContext) &&
            const DeepCollectionEquality().equals(other._meals, _meals));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, date, dayName, dayContext,
      const DeepCollectionEquality().hash(_meals));

  /// Create a copy of PlannedDay
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlannedDayImplCopyWith<_$PlannedDayImpl> get copyWith =>
      __$$PlannedDayImplCopyWithImpl<_$PlannedDayImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlannedDayImplToJson(
      this,
    );
  }
}

abstract class _PlannedDay implements PlannedDay {
  const factory _PlannedDay(
      {required final String date,
      required final String dayName,
      final String? dayContext,
      required final Map<String, PlannedMealSlot> meals}) = _$PlannedDayImpl;

  factory _PlannedDay.fromJson(Map<String, dynamic> json) =
      _$PlannedDayImpl.fromJson;

  @override
  String get date;
  @override
  String get dayName;
  @override
  String? get dayContext;
  @override
  Map<String, PlannedMealSlot> get meals;

  /// Create a copy of PlannedDay
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlannedDayImplCopyWith<_$PlannedDayImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PlannedMealSlot _$PlannedMealSlotFromJson(Map<String, dynamic> json) {
  return _PlannedMealSlot.fromJson(json);
}

/// @nodoc
mixin _$PlannedMealSlot {
  String? get recipeId => throw _privateConstructorUsedError;
  String get reasoning => throw _privateConstructorUsedError;

  /// Serializes this PlannedMealSlot to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PlannedMealSlot
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlannedMealSlotCopyWith<PlannedMealSlot> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlannedMealSlotCopyWith<$Res> {
  factory $PlannedMealSlotCopyWith(
          PlannedMealSlot value, $Res Function(PlannedMealSlot) then) =
      _$PlannedMealSlotCopyWithImpl<$Res, PlannedMealSlot>;
  @useResult
  $Res call({String? recipeId, String reasoning});
}

/// @nodoc
class _$PlannedMealSlotCopyWithImpl<$Res, $Val extends PlannedMealSlot>
    implements $PlannedMealSlotCopyWith<$Res> {
  _$PlannedMealSlotCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlannedMealSlot
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? recipeId = freezed,
    Object? reasoning = null,
  }) {
    return _then(_value.copyWith(
      recipeId: freezed == recipeId
          ? _value.recipeId
          : recipeId // ignore: cast_nullable_to_non_nullable
              as String?,
      reasoning: null == reasoning
          ? _value.reasoning
          : reasoning // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PlannedMealSlotImplCopyWith<$Res>
    implements $PlannedMealSlotCopyWith<$Res> {
  factory _$$PlannedMealSlotImplCopyWith(_$PlannedMealSlotImpl value,
          $Res Function(_$PlannedMealSlotImpl) then) =
      __$$PlannedMealSlotImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? recipeId, String reasoning});
}

/// @nodoc
class __$$PlannedMealSlotImplCopyWithImpl<$Res>
    extends _$PlannedMealSlotCopyWithImpl<$Res, _$PlannedMealSlotImpl>
    implements _$$PlannedMealSlotImplCopyWith<$Res> {
  __$$PlannedMealSlotImplCopyWithImpl(
      _$PlannedMealSlotImpl _value, $Res Function(_$PlannedMealSlotImpl) _then)
      : super(_value, _then);

  /// Create a copy of PlannedMealSlot
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? recipeId = freezed,
    Object? reasoning = null,
  }) {
    return _then(_$PlannedMealSlotImpl(
      recipeId: freezed == recipeId
          ? _value.recipeId
          : recipeId // ignore: cast_nullable_to_non_nullable
              as String?,
      reasoning: null == reasoning
          ? _value.reasoning
          : reasoning // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PlannedMealSlotImpl implements _PlannedMealSlot {
  const _$PlannedMealSlotImpl({this.recipeId, required this.reasoning});

  factory _$PlannedMealSlotImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlannedMealSlotImplFromJson(json);

  @override
  final String? recipeId;
  @override
  final String reasoning;

  @override
  String toString() {
    return 'PlannedMealSlot(recipeId: $recipeId, reasoning: $reasoning)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlannedMealSlotImpl &&
            (identical(other.recipeId, recipeId) ||
                other.recipeId == recipeId) &&
            (identical(other.reasoning, reasoning) ||
                other.reasoning == reasoning));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, recipeId, reasoning);

  /// Create a copy of PlannedMealSlot
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlannedMealSlotImplCopyWith<_$PlannedMealSlotImpl> get copyWith =>
      __$$PlannedMealSlotImplCopyWithImpl<_$PlannedMealSlotImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlannedMealSlotImplToJson(
      this,
    );
  }
}

abstract class _PlannedMealSlot implements PlannedMealSlot {
  const factory _PlannedMealSlot(
      {final String? recipeId,
      required final String reasoning}) = _$PlannedMealSlotImpl;

  factory _PlannedMealSlot.fromJson(Map<String, dynamic> json) =
      _$PlannedMealSlotImpl.fromJson;

  @override
  String? get recipeId;
  @override
  String get reasoning;

  /// Create a copy of PlannedMealSlot
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlannedMealSlotImplCopyWith<_$PlannedMealSlotImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StrategyInsights _$StrategyInsightsFromJson(Map<String, dynamic> json) {
  return _StrategyInsights.fromJson(json);
}

/// @nodoc
mixin _$StrategyInsights {
  List<String> get insights => throw _privateConstructorUsedError;
  int get seasonalCount => throw _privateConstructorUsedError;
  int get favoritesUsed => throw _privateConstructorUsedError;
  String? get estimatedTotalTime => throw _privateConstructorUsedError;

  /// Serializes this StrategyInsights to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StrategyInsights
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StrategyInsightsCopyWith<StrategyInsights> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StrategyInsightsCopyWith<$Res> {
  factory $StrategyInsightsCopyWith(
          StrategyInsights value, $Res Function(StrategyInsights) then) =
      _$StrategyInsightsCopyWithImpl<$Res, StrategyInsights>;
  @useResult
  $Res call(
      {List<String> insights,
      int seasonalCount,
      int favoritesUsed,
      String? estimatedTotalTime});
}

/// @nodoc
class _$StrategyInsightsCopyWithImpl<$Res, $Val extends StrategyInsights>
    implements $StrategyInsightsCopyWith<$Res> {
  _$StrategyInsightsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StrategyInsights
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? insights = null,
    Object? seasonalCount = null,
    Object? favoritesUsed = null,
    Object? estimatedTotalTime = freezed,
  }) {
    return _then(_value.copyWith(
      insights: null == insights
          ? _value.insights
          : insights // ignore: cast_nullable_to_non_nullable
              as List<String>,
      seasonalCount: null == seasonalCount
          ? _value.seasonalCount
          : seasonalCount // ignore: cast_nullable_to_non_nullable
              as int,
      favoritesUsed: null == favoritesUsed
          ? _value.favoritesUsed
          : favoritesUsed // ignore: cast_nullable_to_non_nullable
              as int,
      estimatedTotalTime: freezed == estimatedTotalTime
          ? _value.estimatedTotalTime
          : estimatedTotalTime // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StrategyInsightsImplCopyWith<$Res>
    implements $StrategyInsightsCopyWith<$Res> {
  factory _$$StrategyInsightsImplCopyWith(_$StrategyInsightsImpl value,
          $Res Function(_$StrategyInsightsImpl) then) =
      __$$StrategyInsightsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<String> insights,
      int seasonalCount,
      int favoritesUsed,
      String? estimatedTotalTime});
}

/// @nodoc
class __$$StrategyInsightsImplCopyWithImpl<$Res>
    extends _$StrategyInsightsCopyWithImpl<$Res, _$StrategyInsightsImpl>
    implements _$$StrategyInsightsImplCopyWith<$Res> {
  __$$StrategyInsightsImplCopyWithImpl(_$StrategyInsightsImpl _value,
      $Res Function(_$StrategyInsightsImpl) _then)
      : super(_value, _then);

  /// Create a copy of StrategyInsights
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? insights = null,
    Object? seasonalCount = null,
    Object? favoritesUsed = null,
    Object? estimatedTotalTime = freezed,
  }) {
    return _then(_$StrategyInsightsImpl(
      insights: null == insights
          ? _value._insights
          : insights // ignore: cast_nullable_to_non_nullable
              as List<String>,
      seasonalCount: null == seasonalCount
          ? _value.seasonalCount
          : seasonalCount // ignore: cast_nullable_to_non_nullable
              as int,
      favoritesUsed: null == favoritesUsed
          ? _value.favoritesUsed
          : favoritesUsed // ignore: cast_nullable_to_non_nullable
              as int,
      estimatedTotalTime: freezed == estimatedTotalTime
          ? _value.estimatedTotalTime
          : estimatedTotalTime // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StrategyInsightsImpl implements _StrategyInsights {
  const _$StrategyInsightsImpl(
      {final List<String> insights = const [],
      this.seasonalCount = 0,
      this.favoritesUsed = 0,
      this.estimatedTotalTime})
      : _insights = insights;

  factory _$StrategyInsightsImpl.fromJson(Map<String, dynamic> json) =>
      _$$StrategyInsightsImplFromJson(json);

  final List<String> _insights;
  @override
  @JsonKey()
  List<String> get insights {
    if (_insights is EqualUnmodifiableListView) return _insights;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_insights);
  }

  @override
  @JsonKey()
  final int seasonalCount;
  @override
  @JsonKey()
  final int favoritesUsed;
  @override
  final String? estimatedTotalTime;

  @override
  String toString() {
    return 'StrategyInsights(insights: $insights, seasonalCount: $seasonalCount, favoritesUsed: $favoritesUsed, estimatedTotalTime: $estimatedTotalTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StrategyInsightsImpl &&
            const DeepCollectionEquality().equals(other._insights, _insights) &&
            (identical(other.seasonalCount, seasonalCount) ||
                other.seasonalCount == seasonalCount) &&
            (identical(other.favoritesUsed, favoritesUsed) ||
                other.favoritesUsed == favoritesUsed) &&
            (identical(other.estimatedTotalTime, estimatedTotalTime) ||
                other.estimatedTotalTime == estimatedTotalTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_insights),
      seasonalCount,
      favoritesUsed,
      estimatedTotalTime);

  /// Create a copy of StrategyInsights
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StrategyInsightsImplCopyWith<_$StrategyInsightsImpl> get copyWith =>
      __$$StrategyInsightsImplCopyWithImpl<_$StrategyInsightsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StrategyInsightsImplToJson(
      this,
    );
  }
}

abstract class _StrategyInsights implements StrategyInsights {
  const factory _StrategyInsights(
      {final List<String> insights,
      final int seasonalCount,
      final int favoritesUsed,
      final String? estimatedTotalTime}) = _$StrategyInsightsImpl;

  factory _StrategyInsights.fromJson(Map<String, dynamic> json) =
      _$StrategyInsightsImpl.fromJson;

  @override
  List<String> get insights;
  @override
  int get seasonalCount;
  @override
  int get favoritesUsed;
  @override
  String? get estimatedTotalTime;

  /// Create a copy of StrategyInsights
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StrategyInsightsImplCopyWith<_$StrategyInsightsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

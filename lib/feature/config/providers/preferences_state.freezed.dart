// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'preferences_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PreferencesState {

 bool get autoCorrectOpenEndedWhithAi; bool get autoFeedbackMultipleChoiseWhithAi; EdgeStyle get edgeStyle;
/// Create a copy of PreferencesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PreferencesStateCopyWith<PreferencesState> get copyWith => _$PreferencesStateCopyWithImpl<PreferencesState>(this as PreferencesState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PreferencesState&&(identical(other.autoCorrectOpenEndedWhithAi, autoCorrectOpenEndedWhithAi) || other.autoCorrectOpenEndedWhithAi == autoCorrectOpenEndedWhithAi)&&(identical(other.autoFeedbackMultipleChoiseWhithAi, autoFeedbackMultipleChoiseWhithAi) || other.autoFeedbackMultipleChoiseWhithAi == autoFeedbackMultipleChoiseWhithAi)&&(identical(other.edgeStyle, edgeStyle) || other.edgeStyle == edgeStyle));
}


@override
int get hashCode => Object.hash(runtimeType,autoCorrectOpenEndedWhithAi,autoFeedbackMultipleChoiseWhithAi,edgeStyle);

@override
String toString() {
  return 'PreferencesState(autoCorrectOpenEndedWhithAi: $autoCorrectOpenEndedWhithAi, autoFeedbackMultipleChoiseWhithAi: $autoFeedbackMultipleChoiseWhithAi, edgeStyle: $edgeStyle)';
}


}

/// @nodoc
abstract mixin class $PreferencesStateCopyWith<$Res>  {
  factory $PreferencesStateCopyWith(PreferencesState value, $Res Function(PreferencesState) _then) = _$PreferencesStateCopyWithImpl;
@useResult
$Res call({
 bool autoCorrectOpenEndedWhithAi, bool autoFeedbackMultipleChoiseWhithAi, EdgeStyle edgeStyle
});




}
/// @nodoc
class _$PreferencesStateCopyWithImpl<$Res>
    implements $PreferencesStateCopyWith<$Res> {
  _$PreferencesStateCopyWithImpl(this._self, this._then);

  final PreferencesState _self;
  final $Res Function(PreferencesState) _then;

/// Create a copy of PreferencesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? autoCorrectOpenEndedWhithAi = null,Object? autoFeedbackMultipleChoiseWhithAi = null,Object? edgeStyle = null,}) {
  return _then(_self.copyWith(
autoCorrectOpenEndedWhithAi: null == autoCorrectOpenEndedWhithAi ? _self.autoCorrectOpenEndedWhithAi : autoCorrectOpenEndedWhithAi // ignore: cast_nullable_to_non_nullable
as bool,autoFeedbackMultipleChoiseWhithAi: null == autoFeedbackMultipleChoiseWhithAi ? _self.autoFeedbackMultipleChoiseWhithAi : autoFeedbackMultipleChoiseWhithAi // ignore: cast_nullable_to_non_nullable
as bool,edgeStyle: null == edgeStyle ? _self.edgeStyle : edgeStyle // ignore: cast_nullable_to_non_nullable
as EdgeStyle,
  ));
}

}


/// Adds pattern-matching-related methods to [PreferencesState].
extension PreferencesStatePatterns on PreferencesState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PreferencesState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PreferencesState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PreferencesState value)  $default,){
final _that = this;
switch (_that) {
case _PreferencesState():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PreferencesState value)?  $default,){
final _that = this;
switch (_that) {
case _PreferencesState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool autoCorrectOpenEndedWhithAi,  bool autoFeedbackMultipleChoiseWhithAi,  EdgeStyle edgeStyle)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PreferencesState() when $default != null:
return $default(_that.autoCorrectOpenEndedWhithAi,_that.autoFeedbackMultipleChoiseWhithAi,_that.edgeStyle);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool autoCorrectOpenEndedWhithAi,  bool autoFeedbackMultipleChoiseWhithAi,  EdgeStyle edgeStyle)  $default,) {final _that = this;
switch (_that) {
case _PreferencesState():
return $default(_that.autoCorrectOpenEndedWhithAi,_that.autoFeedbackMultipleChoiseWhithAi,_that.edgeStyle);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool autoCorrectOpenEndedWhithAi,  bool autoFeedbackMultipleChoiseWhithAi,  EdgeStyle edgeStyle)?  $default,) {final _that = this;
switch (_that) {
case _PreferencesState() when $default != null:
return $default(_that.autoCorrectOpenEndedWhithAi,_that.autoFeedbackMultipleChoiseWhithAi,_that.edgeStyle);case _:
  return null;

}
}

}

/// @nodoc


class _PreferencesState implements PreferencesState {
  const _PreferencesState({this.autoCorrectOpenEndedWhithAi = true, this.autoFeedbackMultipleChoiseWhithAi = true, this.edgeStyle = EdgeStyle.rounded});
  

@override@JsonKey() final  bool autoCorrectOpenEndedWhithAi;
@override@JsonKey() final  bool autoFeedbackMultipleChoiseWhithAi;
@override@JsonKey() final  EdgeStyle edgeStyle;

/// Create a copy of PreferencesState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PreferencesStateCopyWith<_PreferencesState> get copyWith => __$PreferencesStateCopyWithImpl<_PreferencesState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PreferencesState&&(identical(other.autoCorrectOpenEndedWhithAi, autoCorrectOpenEndedWhithAi) || other.autoCorrectOpenEndedWhithAi == autoCorrectOpenEndedWhithAi)&&(identical(other.autoFeedbackMultipleChoiseWhithAi, autoFeedbackMultipleChoiseWhithAi) || other.autoFeedbackMultipleChoiseWhithAi == autoFeedbackMultipleChoiseWhithAi)&&(identical(other.edgeStyle, edgeStyle) || other.edgeStyle == edgeStyle));
}


@override
int get hashCode => Object.hash(runtimeType,autoCorrectOpenEndedWhithAi,autoFeedbackMultipleChoiseWhithAi,edgeStyle);

@override
String toString() {
  return 'PreferencesState(autoCorrectOpenEndedWhithAi: $autoCorrectOpenEndedWhithAi, autoFeedbackMultipleChoiseWhithAi: $autoFeedbackMultipleChoiseWhithAi, edgeStyle: $edgeStyle)';
}


}

/// @nodoc
abstract mixin class _$PreferencesStateCopyWith<$Res> implements $PreferencesStateCopyWith<$Res> {
  factory _$PreferencesStateCopyWith(_PreferencesState value, $Res Function(_PreferencesState) _then) = __$PreferencesStateCopyWithImpl;
@override @useResult
$Res call({
 bool autoCorrectOpenEndedWhithAi, bool autoFeedbackMultipleChoiseWhithAi, EdgeStyle edgeStyle
});




}
/// @nodoc
class __$PreferencesStateCopyWithImpl<$Res>
    implements _$PreferencesStateCopyWith<$Res> {
  __$PreferencesStateCopyWithImpl(this._self, this._then);

  final _PreferencesState _self;
  final $Res Function(_PreferencesState) _then;

/// Create a copy of PreferencesState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? autoCorrectOpenEndedWhithAi = null,Object? autoFeedbackMultipleChoiseWhithAi = null,Object? edgeStyle = null,}) {
  return _then(_PreferencesState(
autoCorrectOpenEndedWhithAi: null == autoCorrectOpenEndedWhithAi ? _self.autoCorrectOpenEndedWhithAi : autoCorrectOpenEndedWhithAi // ignore: cast_nullable_to_non_nullable
as bool,autoFeedbackMultipleChoiseWhithAi: null == autoFeedbackMultipleChoiseWhithAi ? _self.autoFeedbackMultipleChoiseWhithAi : autoFeedbackMultipleChoiseWhithAi // ignore: cast_nullable_to_non_nullable
as bool,edgeStyle: null == edgeStyle ? _self.edgeStyle : edgeStyle // ignore: cast_nullable_to_non_nullable
as EdgeStyle,
  ));
}


}

// dart format on

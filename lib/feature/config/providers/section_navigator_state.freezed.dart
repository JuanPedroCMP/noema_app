// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'section_navigator_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SectionNavigatorState {

 ConfigSections get currentSection;
/// Create a copy of SectionNavigatorState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SectionNavigatorStateCopyWith<SectionNavigatorState> get copyWith => _$SectionNavigatorStateCopyWithImpl<SectionNavigatorState>(this as SectionNavigatorState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SectionNavigatorState&&(identical(other.currentSection, currentSection) || other.currentSection == currentSection));
}


@override
int get hashCode => Object.hash(runtimeType,currentSection);

@override
String toString() {
  return 'SectionNavigatorState(currentSection: $currentSection)';
}


}

/// @nodoc
abstract mixin class $SectionNavigatorStateCopyWith<$Res>  {
  factory $SectionNavigatorStateCopyWith(SectionNavigatorState value, $Res Function(SectionNavigatorState) _then) = _$SectionNavigatorStateCopyWithImpl;
@useResult
$Res call({
 ConfigSections currentSection
});




}
/// @nodoc
class _$SectionNavigatorStateCopyWithImpl<$Res>
    implements $SectionNavigatorStateCopyWith<$Res> {
  _$SectionNavigatorStateCopyWithImpl(this._self, this._then);

  final SectionNavigatorState _self;
  final $Res Function(SectionNavigatorState) _then;

/// Create a copy of SectionNavigatorState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currentSection = null,}) {
  return _then(_self.copyWith(
currentSection: null == currentSection ? _self.currentSection : currentSection // ignore: cast_nullable_to_non_nullable
as ConfigSections,
  ));
}

}


/// Adds pattern-matching-related methods to [SectionNavigatorState].
extension SectionNavigatorStatePatterns on SectionNavigatorState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SectionNavigatorState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SectionNavigatorState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SectionNavigatorState value)  $default,){
final _that = this;
switch (_that) {
case _SectionNavigatorState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SectionNavigatorState value)?  $default,){
final _that = this;
switch (_that) {
case _SectionNavigatorState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ConfigSections currentSection)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SectionNavigatorState() when $default != null:
return $default(_that.currentSection);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ConfigSections currentSection)  $default,) {final _that = this;
switch (_that) {
case _SectionNavigatorState():
return $default(_that.currentSection);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ConfigSections currentSection)?  $default,) {final _that = this;
switch (_that) {
case _SectionNavigatorState() when $default != null:
return $default(_that.currentSection);case _:
  return null;

}
}

}

/// @nodoc


class _SectionNavigatorState implements SectionNavigatorState {
  const _SectionNavigatorState({this.currentSection = ConfigSections.profile});
  

@override@JsonKey() final  ConfigSections currentSection;

/// Create a copy of SectionNavigatorState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SectionNavigatorStateCopyWith<_SectionNavigatorState> get copyWith => __$SectionNavigatorStateCopyWithImpl<_SectionNavigatorState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SectionNavigatorState&&(identical(other.currentSection, currentSection) || other.currentSection == currentSection));
}


@override
int get hashCode => Object.hash(runtimeType,currentSection);

@override
String toString() {
  return 'SectionNavigatorState(currentSection: $currentSection)';
}


}

/// @nodoc
abstract mixin class _$SectionNavigatorStateCopyWith<$Res> implements $SectionNavigatorStateCopyWith<$Res> {
  factory _$SectionNavigatorStateCopyWith(_SectionNavigatorState value, $Res Function(_SectionNavigatorState) _then) = __$SectionNavigatorStateCopyWithImpl;
@override @useResult
$Res call({
 ConfigSections currentSection
});




}
/// @nodoc
class __$SectionNavigatorStateCopyWithImpl<$Res>
    implements _$SectionNavigatorStateCopyWith<$Res> {
  __$SectionNavigatorStateCopyWithImpl(this._self, this._then);

  final _SectionNavigatorState _self;
  final $Res Function(_SectionNavigatorState) _then;

/// Create a copy of SectionNavigatorState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentSection = null,}) {
  return _then(_SectionNavigatorState(
currentSection: null == currentSection ? _self.currentSection : currentSection // ignore: cast_nullable_to_non_nullable
as ConfigSections,
  ));
}


}

// dart format on

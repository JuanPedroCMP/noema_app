// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'color_form_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ColorUpFormState {

 int get color;
/// Create a copy of ColorUpFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ColorUpFormStateCopyWith<ColorUpFormState> get copyWith => _$ColorUpFormStateCopyWithImpl<ColorUpFormState>(this as ColorUpFormState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ColorUpFormState&&(identical(other.color, color) || other.color == color));
}


@override
int get hashCode => Object.hash(runtimeType,color);

@override
String toString() {
  return 'ColorUpFormState(color: $color)';
}


}

/// @nodoc
abstract mixin class $ColorUpFormStateCopyWith<$Res>  {
  factory $ColorUpFormStateCopyWith(ColorUpFormState value, $Res Function(ColorUpFormState) _then) = _$ColorUpFormStateCopyWithImpl;
@useResult
$Res call({
 int color
});




}
/// @nodoc
class _$ColorUpFormStateCopyWithImpl<$Res>
    implements $ColorUpFormStateCopyWith<$Res> {
  _$ColorUpFormStateCopyWithImpl(this._self, this._then);

  final ColorUpFormState _self;
  final $Res Function(ColorUpFormState) _then;

/// Create a copy of ColorUpFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? color = null,}) {
  return _then(_self.copyWith(
color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ColorUpFormState].
extension ColorUpFormStatePatterns on ColorUpFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ColorUpFormState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ColorUpFormState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ColorUpFormState value)  $default,){
final _that = this;
switch (_that) {
case _ColorUpFormState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ColorUpFormState value)?  $default,){
final _that = this;
switch (_that) {
case _ColorUpFormState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int color)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ColorUpFormState() when $default != null:
return $default(_that.color);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int color)  $default,) {final _that = this;
switch (_that) {
case _ColorUpFormState():
return $default(_that.color);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int color)?  $default,) {final _that = this;
switch (_that) {
case _ColorUpFormState() when $default != null:
return $default(_that.color);case _:
  return null;

}
}

}

/// @nodoc


class _ColorUpFormState implements ColorUpFormState {
  const _ColorUpFormState({this.color = 0});
  

@override@JsonKey() final  int color;

/// Create a copy of ColorUpFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ColorUpFormStateCopyWith<_ColorUpFormState> get copyWith => __$ColorUpFormStateCopyWithImpl<_ColorUpFormState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ColorUpFormState&&(identical(other.color, color) || other.color == color));
}


@override
int get hashCode => Object.hash(runtimeType,color);

@override
String toString() {
  return 'ColorUpFormState(color: $color)';
}


}

/// @nodoc
abstract mixin class _$ColorUpFormStateCopyWith<$Res> implements $ColorUpFormStateCopyWith<$Res> {
  factory _$ColorUpFormStateCopyWith(_ColorUpFormState value, $Res Function(_ColorUpFormState) _then) = __$ColorUpFormStateCopyWithImpl;
@override @useResult
$Res call({
 int color
});




}
/// @nodoc
class __$ColorUpFormStateCopyWithImpl<$Res>
    implements _$ColorUpFormStateCopyWith<$Res> {
  __$ColorUpFormStateCopyWithImpl(this._self, this._then);

  final _ColorUpFormState _self;
  final $Res Function(_ColorUpFormState) _then;

/// Create a copy of ColorUpFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? color = null,}) {
  return _then(_ColorUpFormState(
color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on

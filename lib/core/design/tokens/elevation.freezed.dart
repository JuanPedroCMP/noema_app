// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'elevation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AppElevation {

/// Flat
 double get none;/// Hover
 double get xs;/// Buttons
 double get sm;/// Cards
 double get md;/// Dialogs
 double get lg;/// Navigation Drawer
 double get xl;/// Floating
 double get xxl;/// Máximo recomendado
 double get huge;
/// Create a copy of AppElevation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppElevationCopyWith<AppElevation> get copyWith => _$AppElevationCopyWithImpl<AppElevation>(this as AppElevation, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppElevation&&(identical(other.none, none) || other.none == none)&&(identical(other.xs, xs) || other.xs == xs)&&(identical(other.sm, sm) || other.sm == sm)&&(identical(other.md, md) || other.md == md)&&(identical(other.lg, lg) || other.lg == lg)&&(identical(other.xl, xl) || other.xl == xl)&&(identical(other.xxl, xxl) || other.xxl == xxl)&&(identical(other.huge, huge) || other.huge == huge));
}


@override
int get hashCode => Object.hash(runtimeType,none,xs,sm,md,lg,xl,xxl,huge);

@override
String toString() {
  return 'AppElevation(none: $none, xs: $xs, sm: $sm, md: $md, lg: $lg, xl: $xl, xxl: $xxl, huge: $huge)';
}


}

/// @nodoc
abstract mixin class $AppElevationCopyWith<$Res>  {
  factory $AppElevationCopyWith(AppElevation value, $Res Function(AppElevation) _then) = _$AppElevationCopyWithImpl;
@useResult
$Res call({
 double none, double xs, double sm, double md, double lg, double xl, double xxl, double huge
});




}
/// @nodoc
class _$AppElevationCopyWithImpl<$Res>
    implements $AppElevationCopyWith<$Res> {
  _$AppElevationCopyWithImpl(this._self, this._then);

  final AppElevation _self;
  final $Res Function(AppElevation) _then;

/// Create a copy of AppElevation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? none = null,Object? xs = null,Object? sm = null,Object? md = null,Object? lg = null,Object? xl = null,Object? xxl = null,Object? huge = null,}) {
  return _then(_self.copyWith(
none: null == none ? _self.none : none // ignore: cast_nullable_to_non_nullable
as double,xs: null == xs ? _self.xs : xs // ignore: cast_nullable_to_non_nullable
as double,sm: null == sm ? _self.sm : sm // ignore: cast_nullable_to_non_nullable
as double,md: null == md ? _self.md : md // ignore: cast_nullable_to_non_nullable
as double,lg: null == lg ? _self.lg : lg // ignore: cast_nullable_to_non_nullable
as double,xl: null == xl ? _self.xl : xl // ignore: cast_nullable_to_non_nullable
as double,xxl: null == xxl ? _self.xxl : xxl // ignore: cast_nullable_to_non_nullable
as double,huge: null == huge ? _self.huge : huge // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [AppElevation].
extension AppElevationPatterns on AppElevation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppElevation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppElevation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppElevation value)  $default,){
final _that = this;
switch (_that) {
case _AppElevation():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppElevation value)?  $default,){
final _that = this;
switch (_that) {
case _AppElevation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double none,  double xs,  double sm,  double md,  double lg,  double xl,  double xxl,  double huge)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppElevation() when $default != null:
return $default(_that.none,_that.xs,_that.sm,_that.md,_that.lg,_that.xl,_that.xxl,_that.huge);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double none,  double xs,  double sm,  double md,  double lg,  double xl,  double xxl,  double huge)  $default,) {final _that = this;
switch (_that) {
case _AppElevation():
return $default(_that.none,_that.xs,_that.sm,_that.md,_that.lg,_that.xl,_that.xxl,_that.huge);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double none,  double xs,  double sm,  double md,  double lg,  double xl,  double xxl,  double huge)?  $default,) {final _that = this;
switch (_that) {
case _AppElevation() when $default != null:
return $default(_that.none,_that.xs,_that.sm,_that.md,_that.lg,_that.xl,_that.xxl,_that.huge);case _:
  return null;

}
}

}

/// @nodoc


class _AppElevation implements AppElevation {
  const _AppElevation({required this.none, required this.xs, required this.sm, required this.md, required this.lg, required this.xl, required this.xxl, required this.huge});
  

/// Flat
@override final  double none;
/// Hover
@override final  double xs;
/// Buttons
@override final  double sm;
/// Cards
@override final  double md;
/// Dialogs
@override final  double lg;
/// Navigation Drawer
@override final  double xl;
/// Floating
@override final  double xxl;
/// Máximo recomendado
@override final  double huge;

/// Create a copy of AppElevation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppElevationCopyWith<_AppElevation> get copyWith => __$AppElevationCopyWithImpl<_AppElevation>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppElevation&&(identical(other.none, none) || other.none == none)&&(identical(other.xs, xs) || other.xs == xs)&&(identical(other.sm, sm) || other.sm == sm)&&(identical(other.md, md) || other.md == md)&&(identical(other.lg, lg) || other.lg == lg)&&(identical(other.xl, xl) || other.xl == xl)&&(identical(other.xxl, xxl) || other.xxl == xxl)&&(identical(other.huge, huge) || other.huge == huge));
}


@override
int get hashCode => Object.hash(runtimeType,none,xs,sm,md,lg,xl,xxl,huge);

@override
String toString() {
  return 'AppElevation(none: $none, xs: $xs, sm: $sm, md: $md, lg: $lg, xl: $xl, xxl: $xxl, huge: $huge)';
}


}

/// @nodoc
abstract mixin class _$AppElevationCopyWith<$Res> implements $AppElevationCopyWith<$Res> {
  factory _$AppElevationCopyWith(_AppElevation value, $Res Function(_AppElevation) _then) = __$AppElevationCopyWithImpl;
@override @useResult
$Res call({
 double none, double xs, double sm, double md, double lg, double xl, double xxl, double huge
});




}
/// @nodoc
class __$AppElevationCopyWithImpl<$Res>
    implements _$AppElevationCopyWith<$Res> {
  __$AppElevationCopyWithImpl(this._self, this._then);

  final _AppElevation _self;
  final $Res Function(_AppElevation) _then;

/// Create a copy of AppElevation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? none = null,Object? xs = null,Object? sm = null,Object? md = null,Object? lg = null,Object? xl = null,Object? xxl = null,Object? huge = null,}) {
  return _then(_AppElevation(
none: null == none ? _self.none : none // ignore: cast_nullable_to_non_nullable
as double,xs: null == xs ? _self.xs : xs // ignore: cast_nullable_to_non_nullable
as double,sm: null == sm ? _self.sm : sm // ignore: cast_nullable_to_non_nullable
as double,md: null == md ? _self.md : md // ignore: cast_nullable_to_non_nullable
as double,lg: null == lg ? _self.lg : lg // ignore: cast_nullable_to_non_nullable
as double,xl: null == xl ? _self.xl : xl // ignore: cast_nullable_to_non_nullable
as double,xxl: null == xxl ? _self.xxl : xxl // ignore: cast_nullable_to_non_nullable
as double,huge: null == huge ? _self.huge : huge // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on

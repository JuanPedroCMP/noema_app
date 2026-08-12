// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'spacing.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AppSpacing {

 double get xxs; double get xs; double get sm; double get md; double get lg; double get xl; double get xxl; double get xxxl; double get huge;
/// Create a copy of AppSpacing
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppSpacingCopyWith<AppSpacing> get copyWith => _$AppSpacingCopyWithImpl<AppSpacing>(this as AppSpacing, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppSpacing&&(identical(other.xxs, xxs) || other.xxs == xxs)&&(identical(other.xs, xs) || other.xs == xs)&&(identical(other.sm, sm) || other.sm == sm)&&(identical(other.md, md) || other.md == md)&&(identical(other.lg, lg) || other.lg == lg)&&(identical(other.xl, xl) || other.xl == xl)&&(identical(other.xxl, xxl) || other.xxl == xxl)&&(identical(other.xxxl, xxxl) || other.xxxl == xxxl)&&(identical(other.huge, huge) || other.huge == huge));
}


@override
int get hashCode => Object.hash(runtimeType,xxs,xs,sm,md,lg,xl,xxl,xxxl,huge);

@override
String toString() {
  return 'AppSpacing(xxs: $xxs, xs: $xs, sm: $sm, md: $md, lg: $lg, xl: $xl, xxl: $xxl, xxxl: $xxxl, huge: $huge)';
}


}

/// @nodoc
abstract mixin class $AppSpacingCopyWith<$Res>  {
  factory $AppSpacingCopyWith(AppSpacing value, $Res Function(AppSpacing) _then) = _$AppSpacingCopyWithImpl;
@useResult
$Res call({
 double xxs, double xs, double sm, double md, double lg, double xl, double xxl, double xxxl, double huge
});




}
/// @nodoc
class _$AppSpacingCopyWithImpl<$Res>
    implements $AppSpacingCopyWith<$Res> {
  _$AppSpacingCopyWithImpl(this._self, this._then);

  final AppSpacing _self;
  final $Res Function(AppSpacing) _then;

/// Create a copy of AppSpacing
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? xxs = null,Object? xs = null,Object? sm = null,Object? md = null,Object? lg = null,Object? xl = null,Object? xxl = null,Object? xxxl = null,Object? huge = null,}) {
  return _then(_self.copyWith(
xxs: null == xxs ? _self.xxs : xxs // ignore: cast_nullable_to_non_nullable
as double,xs: null == xs ? _self.xs : xs // ignore: cast_nullable_to_non_nullable
as double,sm: null == sm ? _self.sm : sm // ignore: cast_nullable_to_non_nullable
as double,md: null == md ? _self.md : md // ignore: cast_nullable_to_non_nullable
as double,lg: null == lg ? _self.lg : lg // ignore: cast_nullable_to_non_nullable
as double,xl: null == xl ? _self.xl : xl // ignore: cast_nullable_to_non_nullable
as double,xxl: null == xxl ? _self.xxl : xxl // ignore: cast_nullable_to_non_nullable
as double,xxxl: null == xxxl ? _self.xxxl : xxxl // ignore: cast_nullable_to_non_nullable
as double,huge: null == huge ? _self.huge : huge // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [AppSpacing].
extension AppSpacingPatterns on AppSpacing {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppSpacing value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppSpacing() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppSpacing value)  $default,){
final _that = this;
switch (_that) {
case _AppSpacing():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppSpacing value)?  $default,){
final _that = this;
switch (_that) {
case _AppSpacing() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double xxs,  double xs,  double sm,  double md,  double lg,  double xl,  double xxl,  double xxxl,  double huge)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppSpacing() when $default != null:
return $default(_that.xxs,_that.xs,_that.sm,_that.md,_that.lg,_that.xl,_that.xxl,_that.xxxl,_that.huge);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double xxs,  double xs,  double sm,  double md,  double lg,  double xl,  double xxl,  double xxxl,  double huge)  $default,) {final _that = this;
switch (_that) {
case _AppSpacing():
return $default(_that.xxs,_that.xs,_that.sm,_that.md,_that.lg,_that.xl,_that.xxl,_that.xxxl,_that.huge);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double xxs,  double xs,  double sm,  double md,  double lg,  double xl,  double xxl,  double xxxl,  double huge)?  $default,) {final _that = this;
switch (_that) {
case _AppSpacing() when $default != null:
return $default(_that.xxs,_that.xs,_that.sm,_that.md,_that.lg,_that.xl,_that.xxl,_that.xxxl,_that.huge);case _:
  return null;

}
}

}

/// @nodoc


class _AppSpacing implements AppSpacing {
  const _AppSpacing({required this.xxs, required this.xs, required this.sm, required this.md, required this.lg, required this.xl, required this.xxl, required this.xxxl, required this.huge});
  

@override final  double xxs;
@override final  double xs;
@override final  double sm;
@override final  double md;
@override final  double lg;
@override final  double xl;
@override final  double xxl;
@override final  double xxxl;
@override final  double huge;

/// Create a copy of AppSpacing
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppSpacingCopyWith<_AppSpacing> get copyWith => __$AppSpacingCopyWithImpl<_AppSpacing>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppSpacing&&(identical(other.xxs, xxs) || other.xxs == xxs)&&(identical(other.xs, xs) || other.xs == xs)&&(identical(other.sm, sm) || other.sm == sm)&&(identical(other.md, md) || other.md == md)&&(identical(other.lg, lg) || other.lg == lg)&&(identical(other.xl, xl) || other.xl == xl)&&(identical(other.xxl, xxl) || other.xxl == xxl)&&(identical(other.xxxl, xxxl) || other.xxxl == xxxl)&&(identical(other.huge, huge) || other.huge == huge));
}


@override
int get hashCode => Object.hash(runtimeType,xxs,xs,sm,md,lg,xl,xxl,xxxl,huge);

@override
String toString() {
  return 'AppSpacing(xxs: $xxs, xs: $xs, sm: $sm, md: $md, lg: $lg, xl: $xl, xxl: $xxl, xxxl: $xxxl, huge: $huge)';
}


}

/// @nodoc
abstract mixin class _$AppSpacingCopyWith<$Res> implements $AppSpacingCopyWith<$Res> {
  factory _$AppSpacingCopyWith(_AppSpacing value, $Res Function(_AppSpacing) _then) = __$AppSpacingCopyWithImpl;
@override @useResult
$Res call({
 double xxs, double xs, double sm, double md, double lg, double xl, double xxl, double xxxl, double huge
});




}
/// @nodoc
class __$AppSpacingCopyWithImpl<$Res>
    implements _$AppSpacingCopyWith<$Res> {
  __$AppSpacingCopyWithImpl(this._self, this._then);

  final _AppSpacing _self;
  final $Res Function(_AppSpacing) _then;

/// Create a copy of AppSpacing
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? xxs = null,Object? xs = null,Object? sm = null,Object? md = null,Object? lg = null,Object? xl = null,Object? xxl = null,Object? xxxl = null,Object? huge = null,}) {
  return _then(_AppSpacing(
xxs: null == xxs ? _self.xxs : xxs // ignore: cast_nullable_to_non_nullable
as double,xs: null == xs ? _self.xs : xs // ignore: cast_nullable_to_non_nullable
as double,sm: null == sm ? _self.sm : sm // ignore: cast_nullable_to_non_nullable
as double,md: null == md ? _self.md : md // ignore: cast_nullable_to_non_nullable
as double,lg: null == lg ? _self.lg : lg // ignore: cast_nullable_to_non_nullable
as double,xl: null == xl ? _self.xl : xl // ignore: cast_nullable_to_non_nullable
as double,xxl: null == xxl ? _self.xxl : xxl // ignore: cast_nullable_to_non_nullable
as double,xxxl: null == xxxl ? _self.xxxl : xxxl // ignore: cast_nullable_to_non_nullable
as double,huge: null == huge ? _self.huge : huge // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on

// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'icon_size.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AppIconSize {

/// Indicadores
 double get xxs;/// Pequenos
 double get xs;/// Compactos
 double get sm;/// Material padrão
 double get md;/// AppBar
 double get lg;/// Botões grandes
 double get xl;/// Destaques
 double get xxl;/// Hero
 double get huge;/// Splash
 double get giant;/// Ilustrações
 double get massive;
/// Create a copy of AppIconSize
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppIconSizeCopyWith<AppIconSize> get copyWith => _$AppIconSizeCopyWithImpl<AppIconSize>(this as AppIconSize, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppIconSize&&(identical(other.xxs, xxs) || other.xxs == xxs)&&(identical(other.xs, xs) || other.xs == xs)&&(identical(other.sm, sm) || other.sm == sm)&&(identical(other.md, md) || other.md == md)&&(identical(other.lg, lg) || other.lg == lg)&&(identical(other.xl, xl) || other.xl == xl)&&(identical(other.xxl, xxl) || other.xxl == xxl)&&(identical(other.huge, huge) || other.huge == huge)&&(identical(other.giant, giant) || other.giant == giant)&&(identical(other.massive, massive) || other.massive == massive));
}


@override
int get hashCode => Object.hash(runtimeType,xxs,xs,sm,md,lg,xl,xxl,huge,giant,massive);

@override
String toString() {
  return 'AppIconSize(xxs: $xxs, xs: $xs, sm: $sm, md: $md, lg: $lg, xl: $xl, xxl: $xxl, huge: $huge, giant: $giant, massive: $massive)';
}


}

/// @nodoc
abstract mixin class $AppIconSizeCopyWith<$Res>  {
  factory $AppIconSizeCopyWith(AppIconSize value, $Res Function(AppIconSize) _then) = _$AppIconSizeCopyWithImpl;
@useResult
$Res call({
 double xxs, double xs, double sm, double md, double lg, double xl, double xxl, double huge, double giant, double massive
});




}
/// @nodoc
class _$AppIconSizeCopyWithImpl<$Res>
    implements $AppIconSizeCopyWith<$Res> {
  _$AppIconSizeCopyWithImpl(this._self, this._then);

  final AppIconSize _self;
  final $Res Function(AppIconSize) _then;

/// Create a copy of AppIconSize
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? xxs = null,Object? xs = null,Object? sm = null,Object? md = null,Object? lg = null,Object? xl = null,Object? xxl = null,Object? huge = null,Object? giant = null,Object? massive = null,}) {
  return _then(_self.copyWith(
xxs: null == xxs ? _self.xxs : xxs // ignore: cast_nullable_to_non_nullable
as double,xs: null == xs ? _self.xs : xs // ignore: cast_nullable_to_non_nullable
as double,sm: null == sm ? _self.sm : sm // ignore: cast_nullable_to_non_nullable
as double,md: null == md ? _self.md : md // ignore: cast_nullable_to_non_nullable
as double,lg: null == lg ? _self.lg : lg // ignore: cast_nullable_to_non_nullable
as double,xl: null == xl ? _self.xl : xl // ignore: cast_nullable_to_non_nullable
as double,xxl: null == xxl ? _self.xxl : xxl // ignore: cast_nullable_to_non_nullable
as double,huge: null == huge ? _self.huge : huge // ignore: cast_nullable_to_non_nullable
as double,giant: null == giant ? _self.giant : giant // ignore: cast_nullable_to_non_nullable
as double,massive: null == massive ? _self.massive : massive // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [AppIconSize].
extension AppIconSizePatterns on AppIconSize {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppIconSize value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppIconSize() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppIconSize value)  $default,){
final _that = this;
switch (_that) {
case _AppIconSize():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppIconSize value)?  $default,){
final _that = this;
switch (_that) {
case _AppIconSize() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double xxs,  double xs,  double sm,  double md,  double lg,  double xl,  double xxl,  double huge,  double giant,  double massive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppIconSize() when $default != null:
return $default(_that.xxs,_that.xs,_that.sm,_that.md,_that.lg,_that.xl,_that.xxl,_that.huge,_that.giant,_that.massive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double xxs,  double xs,  double sm,  double md,  double lg,  double xl,  double xxl,  double huge,  double giant,  double massive)  $default,) {final _that = this;
switch (_that) {
case _AppIconSize():
return $default(_that.xxs,_that.xs,_that.sm,_that.md,_that.lg,_that.xl,_that.xxl,_that.huge,_that.giant,_that.massive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double xxs,  double xs,  double sm,  double md,  double lg,  double xl,  double xxl,  double huge,  double giant,  double massive)?  $default,) {final _that = this;
switch (_that) {
case _AppIconSize() when $default != null:
return $default(_that.xxs,_that.xs,_that.sm,_that.md,_that.lg,_that.xl,_that.xxl,_that.huge,_that.giant,_that.massive);case _:
  return null;

}
}

}

/// @nodoc


class _AppIconSize implements AppIconSize {
  const _AppIconSize({required this.xxs, required this.xs, required this.sm, required this.md, required this.lg, required this.xl, required this.xxl, required this.huge, required this.giant, required this.massive});
  

/// Indicadores
@override final  double xxs;
/// Pequenos
@override final  double xs;
/// Compactos
@override final  double sm;
/// Material padrão
@override final  double md;
/// AppBar
@override final  double lg;
/// Botões grandes
@override final  double xl;
/// Destaques
@override final  double xxl;
/// Hero
@override final  double huge;
/// Splash
@override final  double giant;
/// Ilustrações
@override final  double massive;

/// Create a copy of AppIconSize
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppIconSizeCopyWith<_AppIconSize> get copyWith => __$AppIconSizeCopyWithImpl<_AppIconSize>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppIconSize&&(identical(other.xxs, xxs) || other.xxs == xxs)&&(identical(other.xs, xs) || other.xs == xs)&&(identical(other.sm, sm) || other.sm == sm)&&(identical(other.md, md) || other.md == md)&&(identical(other.lg, lg) || other.lg == lg)&&(identical(other.xl, xl) || other.xl == xl)&&(identical(other.xxl, xxl) || other.xxl == xxl)&&(identical(other.huge, huge) || other.huge == huge)&&(identical(other.giant, giant) || other.giant == giant)&&(identical(other.massive, massive) || other.massive == massive));
}


@override
int get hashCode => Object.hash(runtimeType,xxs,xs,sm,md,lg,xl,xxl,huge,giant,massive);

@override
String toString() {
  return 'AppIconSize(xxs: $xxs, xs: $xs, sm: $sm, md: $md, lg: $lg, xl: $xl, xxl: $xxl, huge: $huge, giant: $giant, massive: $massive)';
}


}

/// @nodoc
abstract mixin class _$AppIconSizeCopyWith<$Res> implements $AppIconSizeCopyWith<$Res> {
  factory _$AppIconSizeCopyWith(_AppIconSize value, $Res Function(_AppIconSize) _then) = __$AppIconSizeCopyWithImpl;
@override @useResult
$Res call({
 double xxs, double xs, double sm, double md, double lg, double xl, double xxl, double huge, double giant, double massive
});




}
/// @nodoc
class __$AppIconSizeCopyWithImpl<$Res>
    implements _$AppIconSizeCopyWith<$Res> {
  __$AppIconSizeCopyWithImpl(this._self, this._then);

  final _AppIconSize _self;
  final $Res Function(_AppIconSize) _then;

/// Create a copy of AppIconSize
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? xxs = null,Object? xs = null,Object? sm = null,Object? md = null,Object? lg = null,Object? xl = null,Object? xxl = null,Object? huge = null,Object? giant = null,Object? massive = null,}) {
  return _then(_AppIconSize(
xxs: null == xxs ? _self.xxs : xxs // ignore: cast_nullable_to_non_nullable
as double,xs: null == xs ? _self.xs : xs // ignore: cast_nullable_to_non_nullable
as double,sm: null == sm ? _self.sm : sm // ignore: cast_nullable_to_non_nullable
as double,md: null == md ? _self.md : md // ignore: cast_nullable_to_non_nullable
as double,lg: null == lg ? _self.lg : lg // ignore: cast_nullable_to_non_nullable
as double,xl: null == xl ? _self.xl : xl // ignore: cast_nullable_to_non_nullable
as double,xxl: null == xxl ? _self.xxl : xxl // ignore: cast_nullable_to_non_nullable
as double,huge: null == huge ? _self.huge : huge // ignore: cast_nullable_to_non_nullable
as double,giant: null == giant ? _self.giant : giant // ignore: cast_nullable_to_non_nullable
as double,massive: null == massive ? _self.massive : massive // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on

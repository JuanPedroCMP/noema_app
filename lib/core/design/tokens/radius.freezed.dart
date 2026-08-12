// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'radius.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AppRadius {

 double get none; double get xxs; double get xs; double get sm; double get md; double get lg; double get xl; double get xxl;/// Botões arredondados
 double get button;/// Cards Material 3
 double get card;/// BottomSheets
 double get sheet;/// Dialogs
 double get dialog;/// Chips
 double get chip;/// FAB
 double get fab;/// Avatares
 double get avatar;/// Pills
 double get pill;
/// Create a copy of AppRadius
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppRadiusCopyWith<AppRadius> get copyWith => _$AppRadiusCopyWithImpl<AppRadius>(this as AppRadius, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppRadius&&(identical(other.none, none) || other.none == none)&&(identical(other.xxs, xxs) || other.xxs == xxs)&&(identical(other.xs, xs) || other.xs == xs)&&(identical(other.sm, sm) || other.sm == sm)&&(identical(other.md, md) || other.md == md)&&(identical(other.lg, lg) || other.lg == lg)&&(identical(other.xl, xl) || other.xl == xl)&&(identical(other.xxl, xxl) || other.xxl == xxl)&&(identical(other.button, button) || other.button == button)&&(identical(other.card, card) || other.card == card)&&(identical(other.sheet, sheet) || other.sheet == sheet)&&(identical(other.dialog, dialog) || other.dialog == dialog)&&(identical(other.chip, chip) || other.chip == chip)&&(identical(other.fab, fab) || other.fab == fab)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.pill, pill) || other.pill == pill));
}


@override
int get hashCode => Object.hash(runtimeType,none,xxs,xs,sm,md,lg,xl,xxl,button,card,sheet,dialog,chip,fab,avatar,pill);

@override
String toString() {
  return 'AppRadius(none: $none, xxs: $xxs, xs: $xs, sm: $sm, md: $md, lg: $lg, xl: $xl, xxl: $xxl, button: $button, card: $card, sheet: $sheet, dialog: $dialog, chip: $chip, fab: $fab, avatar: $avatar, pill: $pill)';
}


}

/// @nodoc
abstract mixin class $AppRadiusCopyWith<$Res>  {
  factory $AppRadiusCopyWith(AppRadius value, $Res Function(AppRadius) _then) = _$AppRadiusCopyWithImpl;
@useResult
$Res call({
 double none, double xxs, double xs, double sm, double md, double lg, double xl, double xxl, double button, double card, double sheet, double dialog, double chip, double fab, double avatar, double pill
});




}
/// @nodoc
class _$AppRadiusCopyWithImpl<$Res>
    implements $AppRadiusCopyWith<$Res> {
  _$AppRadiusCopyWithImpl(this._self, this._then);

  final AppRadius _self;
  final $Res Function(AppRadius) _then;

/// Create a copy of AppRadius
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? none = null,Object? xxs = null,Object? xs = null,Object? sm = null,Object? md = null,Object? lg = null,Object? xl = null,Object? xxl = null,Object? button = null,Object? card = null,Object? sheet = null,Object? dialog = null,Object? chip = null,Object? fab = null,Object? avatar = null,Object? pill = null,}) {
  return _then(_self.copyWith(
none: null == none ? _self.none : none // ignore: cast_nullable_to_non_nullable
as double,xxs: null == xxs ? _self.xxs : xxs // ignore: cast_nullable_to_non_nullable
as double,xs: null == xs ? _self.xs : xs // ignore: cast_nullable_to_non_nullable
as double,sm: null == sm ? _self.sm : sm // ignore: cast_nullable_to_non_nullable
as double,md: null == md ? _self.md : md // ignore: cast_nullable_to_non_nullable
as double,lg: null == lg ? _self.lg : lg // ignore: cast_nullable_to_non_nullable
as double,xl: null == xl ? _self.xl : xl // ignore: cast_nullable_to_non_nullable
as double,xxl: null == xxl ? _self.xxl : xxl // ignore: cast_nullable_to_non_nullable
as double,button: null == button ? _self.button : button // ignore: cast_nullable_to_non_nullable
as double,card: null == card ? _self.card : card // ignore: cast_nullable_to_non_nullable
as double,sheet: null == sheet ? _self.sheet : sheet // ignore: cast_nullable_to_non_nullable
as double,dialog: null == dialog ? _self.dialog : dialog // ignore: cast_nullable_to_non_nullable
as double,chip: null == chip ? _self.chip : chip // ignore: cast_nullable_to_non_nullable
as double,fab: null == fab ? _self.fab : fab // ignore: cast_nullable_to_non_nullable
as double,avatar: null == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as double,pill: null == pill ? _self.pill : pill // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [AppRadius].
extension AppRadiusPatterns on AppRadius {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppRadius value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppRadius() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppRadius value)  $default,){
final _that = this;
switch (_that) {
case _AppRadius():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppRadius value)?  $default,){
final _that = this;
switch (_that) {
case _AppRadius() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double none,  double xxs,  double xs,  double sm,  double md,  double lg,  double xl,  double xxl,  double button,  double card,  double sheet,  double dialog,  double chip,  double fab,  double avatar,  double pill)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppRadius() when $default != null:
return $default(_that.none,_that.xxs,_that.xs,_that.sm,_that.md,_that.lg,_that.xl,_that.xxl,_that.button,_that.card,_that.sheet,_that.dialog,_that.chip,_that.fab,_that.avatar,_that.pill);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double none,  double xxs,  double xs,  double sm,  double md,  double lg,  double xl,  double xxl,  double button,  double card,  double sheet,  double dialog,  double chip,  double fab,  double avatar,  double pill)  $default,) {final _that = this;
switch (_that) {
case _AppRadius():
return $default(_that.none,_that.xxs,_that.xs,_that.sm,_that.md,_that.lg,_that.xl,_that.xxl,_that.button,_that.card,_that.sheet,_that.dialog,_that.chip,_that.fab,_that.avatar,_that.pill);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double none,  double xxs,  double xs,  double sm,  double md,  double lg,  double xl,  double xxl,  double button,  double card,  double sheet,  double dialog,  double chip,  double fab,  double avatar,  double pill)?  $default,) {final _that = this;
switch (_that) {
case _AppRadius() when $default != null:
return $default(_that.none,_that.xxs,_that.xs,_that.sm,_that.md,_that.lg,_that.xl,_that.xxl,_that.button,_that.card,_that.sheet,_that.dialog,_that.chip,_that.fab,_that.avatar,_that.pill);case _:
  return null;

}
}

}

/// @nodoc


class _AppRadius implements AppRadius {
  const _AppRadius({required this.none, required this.xxs, required this.xs, required this.sm, required this.md, required this.lg, required this.xl, required this.xxl, required this.button, required this.card, required this.sheet, required this.dialog, required this.chip, required this.fab, required this.avatar, required this.pill});
  

@override final  double none;
@override final  double xxs;
@override final  double xs;
@override final  double sm;
@override final  double md;
@override final  double lg;
@override final  double xl;
@override final  double xxl;
/// Botões arredondados
@override final  double button;
/// Cards Material 3
@override final  double card;
/// BottomSheets
@override final  double sheet;
/// Dialogs
@override final  double dialog;
/// Chips
@override final  double chip;
/// FAB
@override final  double fab;
/// Avatares
@override final  double avatar;
/// Pills
@override final  double pill;

/// Create a copy of AppRadius
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppRadiusCopyWith<_AppRadius> get copyWith => __$AppRadiusCopyWithImpl<_AppRadius>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppRadius&&(identical(other.none, none) || other.none == none)&&(identical(other.xxs, xxs) || other.xxs == xxs)&&(identical(other.xs, xs) || other.xs == xs)&&(identical(other.sm, sm) || other.sm == sm)&&(identical(other.md, md) || other.md == md)&&(identical(other.lg, lg) || other.lg == lg)&&(identical(other.xl, xl) || other.xl == xl)&&(identical(other.xxl, xxl) || other.xxl == xxl)&&(identical(other.button, button) || other.button == button)&&(identical(other.card, card) || other.card == card)&&(identical(other.sheet, sheet) || other.sheet == sheet)&&(identical(other.dialog, dialog) || other.dialog == dialog)&&(identical(other.chip, chip) || other.chip == chip)&&(identical(other.fab, fab) || other.fab == fab)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.pill, pill) || other.pill == pill));
}


@override
int get hashCode => Object.hash(runtimeType,none,xxs,xs,sm,md,lg,xl,xxl,button,card,sheet,dialog,chip,fab,avatar,pill);

@override
String toString() {
  return 'AppRadius(none: $none, xxs: $xxs, xs: $xs, sm: $sm, md: $md, lg: $lg, xl: $xl, xxl: $xxl, button: $button, card: $card, sheet: $sheet, dialog: $dialog, chip: $chip, fab: $fab, avatar: $avatar, pill: $pill)';
}


}

/// @nodoc
abstract mixin class _$AppRadiusCopyWith<$Res> implements $AppRadiusCopyWith<$Res> {
  factory _$AppRadiusCopyWith(_AppRadius value, $Res Function(_AppRadius) _then) = __$AppRadiusCopyWithImpl;
@override @useResult
$Res call({
 double none, double xxs, double xs, double sm, double md, double lg, double xl, double xxl, double button, double card, double sheet, double dialog, double chip, double fab, double avatar, double pill
});




}
/// @nodoc
class __$AppRadiusCopyWithImpl<$Res>
    implements _$AppRadiusCopyWith<$Res> {
  __$AppRadiusCopyWithImpl(this._self, this._then);

  final _AppRadius _self;
  final $Res Function(_AppRadius) _then;

/// Create a copy of AppRadius
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? none = null,Object? xxs = null,Object? xs = null,Object? sm = null,Object? md = null,Object? lg = null,Object? xl = null,Object? xxl = null,Object? button = null,Object? card = null,Object? sheet = null,Object? dialog = null,Object? chip = null,Object? fab = null,Object? avatar = null,Object? pill = null,}) {
  return _then(_AppRadius(
none: null == none ? _self.none : none // ignore: cast_nullable_to_non_nullable
as double,xxs: null == xxs ? _self.xxs : xxs // ignore: cast_nullable_to_non_nullable
as double,xs: null == xs ? _self.xs : xs // ignore: cast_nullable_to_non_nullable
as double,sm: null == sm ? _self.sm : sm // ignore: cast_nullable_to_non_nullable
as double,md: null == md ? _self.md : md // ignore: cast_nullable_to_non_nullable
as double,lg: null == lg ? _self.lg : lg // ignore: cast_nullable_to_non_nullable
as double,xl: null == xl ? _self.xl : xl // ignore: cast_nullable_to_non_nullable
as double,xxl: null == xxl ? _self.xxl : xxl // ignore: cast_nullable_to_non_nullable
as double,button: null == button ? _self.button : button // ignore: cast_nullable_to_non_nullable
as double,card: null == card ? _self.card : card // ignore: cast_nullable_to_non_nullable
as double,sheet: null == sheet ? _self.sheet : sheet // ignore: cast_nullable_to_non_nullable
as double,dialog: null == dialog ? _self.dialog : dialog // ignore: cast_nullable_to_non_nullable
as double,chip: null == chip ? _self.chip : chip // ignore: cast_nullable_to_non_nullable
as double,fab: null == fab ? _self.fab : fab // ignore: cast_nullable_to_non_nullable
as double,avatar: null == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as double,pill: null == pill ? _self.pill : pill // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on

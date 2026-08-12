// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'durations.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AppDurations {

 Duration get instant; Duration get fast; Duration get normal; Duration get slow; Duration get page;
/// Create a copy of AppDurations
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppDurationsCopyWith<AppDurations> get copyWith => _$AppDurationsCopyWithImpl<AppDurations>(this as AppDurations, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppDurations&&(identical(other.instant, instant) || other.instant == instant)&&(identical(other.fast, fast) || other.fast == fast)&&(identical(other.normal, normal) || other.normal == normal)&&(identical(other.slow, slow) || other.slow == slow)&&(identical(other.page, page) || other.page == page));
}


@override
int get hashCode => Object.hash(runtimeType,instant,fast,normal,slow,page);

@override
String toString() {
  return 'AppDurations(instant: $instant, fast: $fast, normal: $normal, slow: $slow, page: $page)';
}


}

/// @nodoc
abstract mixin class $AppDurationsCopyWith<$Res>  {
  factory $AppDurationsCopyWith(AppDurations value, $Res Function(AppDurations) _then) = _$AppDurationsCopyWithImpl;
@useResult
$Res call({
 Duration instant, Duration fast, Duration normal, Duration slow, Duration page
});




}
/// @nodoc
class _$AppDurationsCopyWithImpl<$Res>
    implements $AppDurationsCopyWith<$Res> {
  _$AppDurationsCopyWithImpl(this._self, this._then);

  final AppDurations _self;
  final $Res Function(AppDurations) _then;

/// Create a copy of AppDurations
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? instant = null,Object? fast = null,Object? normal = null,Object? slow = null,Object? page = null,}) {
  return _then(_self.copyWith(
instant: null == instant ? _self.instant : instant // ignore: cast_nullable_to_non_nullable
as Duration,fast: null == fast ? _self.fast : fast // ignore: cast_nullable_to_non_nullable
as Duration,normal: null == normal ? _self.normal : normal // ignore: cast_nullable_to_non_nullable
as Duration,slow: null == slow ? _self.slow : slow // ignore: cast_nullable_to_non_nullable
as Duration,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as Duration,
  ));
}

}


/// Adds pattern-matching-related methods to [AppDurations].
extension AppDurationsPatterns on AppDurations {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppDurations value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppDurations() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppDurations value)  $default,){
final _that = this;
switch (_that) {
case _AppDurations():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppDurations value)?  $default,){
final _that = this;
switch (_that) {
case _AppDurations() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Duration instant,  Duration fast,  Duration normal,  Duration slow,  Duration page)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppDurations() when $default != null:
return $default(_that.instant,_that.fast,_that.normal,_that.slow,_that.page);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Duration instant,  Duration fast,  Duration normal,  Duration slow,  Duration page)  $default,) {final _that = this;
switch (_that) {
case _AppDurations():
return $default(_that.instant,_that.fast,_that.normal,_that.slow,_that.page);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Duration instant,  Duration fast,  Duration normal,  Duration slow,  Duration page)?  $default,) {final _that = this;
switch (_that) {
case _AppDurations() when $default != null:
return $default(_that.instant,_that.fast,_that.normal,_that.slow,_that.page);case _:
  return null;

}
}

}

/// @nodoc


class _AppDurations implements AppDurations {
  const _AppDurations({required this.instant, required this.fast, required this.normal, required this.slow, required this.page});
  

@override final  Duration instant;
@override final  Duration fast;
@override final  Duration normal;
@override final  Duration slow;
@override final  Duration page;

/// Create a copy of AppDurations
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppDurationsCopyWith<_AppDurations> get copyWith => __$AppDurationsCopyWithImpl<_AppDurations>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppDurations&&(identical(other.instant, instant) || other.instant == instant)&&(identical(other.fast, fast) || other.fast == fast)&&(identical(other.normal, normal) || other.normal == normal)&&(identical(other.slow, slow) || other.slow == slow)&&(identical(other.page, page) || other.page == page));
}


@override
int get hashCode => Object.hash(runtimeType,instant,fast,normal,slow,page);

@override
String toString() {
  return 'AppDurations(instant: $instant, fast: $fast, normal: $normal, slow: $slow, page: $page)';
}


}

/// @nodoc
abstract mixin class _$AppDurationsCopyWith<$Res> implements $AppDurationsCopyWith<$Res> {
  factory _$AppDurationsCopyWith(_AppDurations value, $Res Function(_AppDurations) _then) = __$AppDurationsCopyWithImpl;
@override @useResult
$Res call({
 Duration instant, Duration fast, Duration normal, Duration slow, Duration page
});




}
/// @nodoc
class __$AppDurationsCopyWithImpl<$Res>
    implements _$AppDurationsCopyWith<$Res> {
  __$AppDurationsCopyWithImpl(this._self, this._then);

  final _AppDurations _self;
  final $Res Function(_AppDurations) _then;

/// Create a copy of AppDurations
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? instant = null,Object? fast = null,Object? normal = null,Object? slow = null,Object? page = null,}) {
  return _then(_AppDurations(
instant: null == instant ? _self.instant : instant // ignore: cast_nullable_to_non_nullable
as Duration,fast: null == fast ? _self.fast : fast // ignore: cast_nullable_to_non_nullable
as Duration,normal: null == normal ? _self.normal : normal // ignore: cast_nullable_to_non_nullable
as Duration,slow: null == slow ? _self.slow : slow // ignore: cast_nullable_to_non_nullable
as Duration,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as Duration,
  ));
}


}

// dart format on

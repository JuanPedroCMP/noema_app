// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_side_bar_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AppSideBarState implements DiagnosticableTreeMixin {

 bool get isOpen; bool get isFixed;
/// Create a copy of AppSideBarState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppSideBarStateCopyWith<AppSideBarState> get copyWith => _$AppSideBarStateCopyWithImpl<AppSideBarState>(this as AppSideBarState, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'AppSideBarState'))
    ..add(DiagnosticsProperty('isOpen', isOpen))..add(DiagnosticsProperty('isFixed', isFixed));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppSideBarState&&(identical(other.isOpen, isOpen) || other.isOpen == isOpen)&&(identical(other.isFixed, isFixed) || other.isFixed == isFixed));
}


@override
int get hashCode => Object.hash(runtimeType,isOpen,isFixed);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'AppSideBarState(isOpen: $isOpen, isFixed: $isFixed)';
}


}

/// @nodoc
abstract mixin class $AppSideBarStateCopyWith<$Res>  {
  factory $AppSideBarStateCopyWith(AppSideBarState value, $Res Function(AppSideBarState) _then) = _$AppSideBarStateCopyWithImpl;
@useResult
$Res call({
 bool isOpen, bool isFixed
});




}
/// @nodoc
class _$AppSideBarStateCopyWithImpl<$Res>
    implements $AppSideBarStateCopyWith<$Res> {
  _$AppSideBarStateCopyWithImpl(this._self, this._then);

  final AppSideBarState _self;
  final $Res Function(AppSideBarState) _then;

/// Create a copy of AppSideBarState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isOpen = null,Object? isFixed = null,}) {
  return _then(_self.copyWith(
isOpen: null == isOpen ? _self.isOpen : isOpen // ignore: cast_nullable_to_non_nullable
as bool,isFixed: null == isFixed ? _self.isFixed : isFixed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AppSideBarState].
extension AppSideBarStatePatterns on AppSideBarState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppSideBarState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppSideBarState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppSideBarState value)  $default,){
final _that = this;
switch (_that) {
case _AppSideBarState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppSideBarState value)?  $default,){
final _that = this;
switch (_that) {
case _AppSideBarState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isOpen,  bool isFixed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppSideBarState() when $default != null:
return $default(_that.isOpen,_that.isFixed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isOpen,  bool isFixed)  $default,) {final _that = this;
switch (_that) {
case _AppSideBarState():
return $default(_that.isOpen,_that.isFixed);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isOpen,  bool isFixed)?  $default,) {final _that = this;
switch (_that) {
case _AppSideBarState() when $default != null:
return $default(_that.isOpen,_that.isFixed);case _:
  return null;

}
}

}

/// @nodoc


class _AppSideBarState with DiagnosticableTreeMixin implements AppSideBarState {
  const _AppSideBarState({this.isOpen = false, this.isFixed = false});
  

@override@JsonKey() final  bool isOpen;
@override@JsonKey() final  bool isFixed;

/// Create a copy of AppSideBarState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppSideBarStateCopyWith<_AppSideBarState> get copyWith => __$AppSideBarStateCopyWithImpl<_AppSideBarState>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'AppSideBarState'))
    ..add(DiagnosticsProperty('isOpen', isOpen))..add(DiagnosticsProperty('isFixed', isFixed));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppSideBarState&&(identical(other.isOpen, isOpen) || other.isOpen == isOpen)&&(identical(other.isFixed, isFixed) || other.isFixed == isFixed));
}


@override
int get hashCode => Object.hash(runtimeType,isOpen,isFixed);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'AppSideBarState(isOpen: $isOpen, isFixed: $isFixed)';
}


}

/// @nodoc
abstract mixin class _$AppSideBarStateCopyWith<$Res> implements $AppSideBarStateCopyWith<$Res> {
  factory _$AppSideBarStateCopyWith(_AppSideBarState value, $Res Function(_AppSideBarState) _then) = __$AppSideBarStateCopyWithImpl;
@override @useResult
$Res call({
 bool isOpen, bool isFixed
});




}
/// @nodoc
class __$AppSideBarStateCopyWithImpl<$Res>
    implements _$AppSideBarStateCopyWith<$Res> {
  __$AppSideBarStateCopyWithImpl(this._self, this._then);

  final _AppSideBarState _self;
  final $Res Function(_AppSideBarState) _then;

/// Create a copy of AppSideBarState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isOpen = null,Object? isFixed = null,}) {
  return _then(_AppSideBarState(
isOpen: null == isOpen ? _self.isOpen : isOpen // ignore: cast_nullable_to_non_nullable
as bool,isFixed: null == isFixed ? _self.isFixed : isFixed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on

// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'graph_form_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GraphFormState {

 String get userId; String get title; String get description; bool get isArchived; bool get synced;
/// Create a copy of GraphFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GraphFormStateCopyWith<GraphFormState> get copyWith => _$GraphFormStateCopyWithImpl<GraphFormState>(this as GraphFormState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GraphFormState&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.isArchived, isArchived) || other.isArchived == isArchived)&&(identical(other.synced, synced) || other.synced == synced));
}


@override
int get hashCode => Object.hash(runtimeType,userId,title,description,isArchived,synced);

@override
String toString() {
  return 'GraphFormState(userId: $userId, title: $title, description: $description, isArchived: $isArchived, synced: $synced)';
}


}

/// @nodoc
abstract mixin class $GraphFormStateCopyWith<$Res>  {
  factory $GraphFormStateCopyWith(GraphFormState value, $Res Function(GraphFormState) _then) = _$GraphFormStateCopyWithImpl;
@useResult
$Res call({
 String userId, String title, String description, bool isArchived, bool synced
});




}
/// @nodoc
class _$GraphFormStateCopyWithImpl<$Res>
    implements $GraphFormStateCopyWith<$Res> {
  _$GraphFormStateCopyWithImpl(this._self, this._then);

  final GraphFormState _self;
  final $Res Function(GraphFormState) _then;

/// Create a copy of GraphFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? title = null,Object? description = null,Object? isArchived = null,Object? synced = null,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,isArchived: null == isArchived ? _self.isArchived : isArchived // ignore: cast_nullable_to_non_nullable
as bool,synced: null == synced ? _self.synced : synced // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [GraphFormState].
extension GraphFormStatePatterns on GraphFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GraphFormState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GraphFormState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GraphFormState value)  $default,){
final _that = this;
switch (_that) {
case _GraphFormState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GraphFormState value)?  $default,){
final _that = this;
switch (_that) {
case _GraphFormState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  String title,  String description,  bool isArchived,  bool synced)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GraphFormState() when $default != null:
return $default(_that.userId,_that.title,_that.description,_that.isArchived,_that.synced);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  String title,  String description,  bool isArchived,  bool synced)  $default,) {final _that = this;
switch (_that) {
case _GraphFormState():
return $default(_that.userId,_that.title,_that.description,_that.isArchived,_that.synced);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  String title,  String description,  bool isArchived,  bool synced)?  $default,) {final _that = this;
switch (_that) {
case _GraphFormState() when $default != null:
return $default(_that.userId,_that.title,_that.description,_that.isArchived,_that.synced);case _:
  return null;

}
}

}

/// @nodoc


class _GraphFormState implements GraphFormState {
  const _GraphFormState({this.userId = "", this.title = "", this.description = "", this.isArchived = false, this.synced = false});
  

@override@JsonKey() final  String userId;
@override@JsonKey() final  String title;
@override@JsonKey() final  String description;
@override@JsonKey() final  bool isArchived;
@override@JsonKey() final  bool synced;

/// Create a copy of GraphFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GraphFormStateCopyWith<_GraphFormState> get copyWith => __$GraphFormStateCopyWithImpl<_GraphFormState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GraphFormState&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.isArchived, isArchived) || other.isArchived == isArchived)&&(identical(other.synced, synced) || other.synced == synced));
}


@override
int get hashCode => Object.hash(runtimeType,userId,title,description,isArchived,synced);

@override
String toString() {
  return 'GraphFormState(userId: $userId, title: $title, description: $description, isArchived: $isArchived, synced: $synced)';
}


}

/// @nodoc
abstract mixin class _$GraphFormStateCopyWith<$Res> implements $GraphFormStateCopyWith<$Res> {
  factory _$GraphFormStateCopyWith(_GraphFormState value, $Res Function(_GraphFormState) _then) = __$GraphFormStateCopyWithImpl;
@override @useResult
$Res call({
 String userId, String title, String description, bool isArchived, bool synced
});




}
/// @nodoc
class __$GraphFormStateCopyWithImpl<$Res>
    implements _$GraphFormStateCopyWith<$Res> {
  __$GraphFormStateCopyWithImpl(this._self, this._then);

  final _GraphFormState _self;
  final $Res Function(_GraphFormState) _then;

/// Create a copy of GraphFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? title = null,Object? description = null,Object? isArchived = null,Object? synced = null,}) {
  return _then(_GraphFormState(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,isArchived: null == isArchived ? _self.isArchived : isArchived // ignore: cast_nullable_to_non_nullable
as bool,synced: null == synced ? _self.synced : synced // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on

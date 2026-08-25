// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'graph_states_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GraphStatesSate {

 bool get isEditing; bool get isCreatingNode; bool get isCreatingEdge;
/// Create a copy of GraphStatesSate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GraphStatesSateCopyWith<GraphStatesSate> get copyWith => _$GraphStatesSateCopyWithImpl<GraphStatesSate>(this as GraphStatesSate, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GraphStatesSate&&(identical(other.isEditing, isEditing) || other.isEditing == isEditing)&&(identical(other.isCreatingNode, isCreatingNode) || other.isCreatingNode == isCreatingNode)&&(identical(other.isCreatingEdge, isCreatingEdge) || other.isCreatingEdge == isCreatingEdge));
}


@override
int get hashCode => Object.hash(runtimeType,isEditing,isCreatingNode,isCreatingEdge);

@override
String toString() {
  return 'GraphStatesSate(isEditing: $isEditing, isCreatingNode: $isCreatingNode, isCreatingEdge: $isCreatingEdge)';
}


}

/// @nodoc
abstract mixin class $GraphStatesSateCopyWith<$Res>  {
  factory $GraphStatesSateCopyWith(GraphStatesSate value, $Res Function(GraphStatesSate) _then) = _$GraphStatesSateCopyWithImpl;
@useResult
$Res call({
 bool isEditing, bool isCreatingNode, bool isCreatingEdge
});




}
/// @nodoc
class _$GraphStatesSateCopyWithImpl<$Res>
    implements $GraphStatesSateCopyWith<$Res> {
  _$GraphStatesSateCopyWithImpl(this._self, this._then);

  final GraphStatesSate _self;
  final $Res Function(GraphStatesSate) _then;

/// Create a copy of GraphStatesSate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isEditing = null,Object? isCreatingNode = null,Object? isCreatingEdge = null,}) {
  return _then(_self.copyWith(
isEditing: null == isEditing ? _self.isEditing : isEditing // ignore: cast_nullable_to_non_nullable
as bool,isCreatingNode: null == isCreatingNode ? _self.isCreatingNode : isCreatingNode // ignore: cast_nullable_to_non_nullable
as bool,isCreatingEdge: null == isCreatingEdge ? _self.isCreatingEdge : isCreatingEdge // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [GraphStatesSate].
extension GraphStatesSatePatterns on GraphStatesSate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GraphStatesSate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GraphStatesSate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GraphStatesSate value)  $default,){
final _that = this;
switch (_that) {
case _GraphStatesSate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GraphStatesSate value)?  $default,){
final _that = this;
switch (_that) {
case _GraphStatesSate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isEditing,  bool isCreatingNode,  bool isCreatingEdge)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GraphStatesSate() when $default != null:
return $default(_that.isEditing,_that.isCreatingNode,_that.isCreatingEdge);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isEditing,  bool isCreatingNode,  bool isCreatingEdge)  $default,) {final _that = this;
switch (_that) {
case _GraphStatesSate():
return $default(_that.isEditing,_that.isCreatingNode,_that.isCreatingEdge);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isEditing,  bool isCreatingNode,  bool isCreatingEdge)?  $default,) {final _that = this;
switch (_that) {
case _GraphStatesSate() when $default != null:
return $default(_that.isEditing,_that.isCreatingNode,_that.isCreatingEdge);case _:
  return null;

}
}

}

/// @nodoc


class _GraphStatesSate implements GraphStatesSate {
  const _GraphStatesSate({this.isEditing = false, this.isCreatingNode = false, this.isCreatingEdge = false});
  

@override@JsonKey() final  bool isEditing;
@override@JsonKey() final  bool isCreatingNode;
@override@JsonKey() final  bool isCreatingEdge;

/// Create a copy of GraphStatesSate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GraphStatesSateCopyWith<_GraphStatesSate> get copyWith => __$GraphStatesSateCopyWithImpl<_GraphStatesSate>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GraphStatesSate&&(identical(other.isEditing, isEditing) || other.isEditing == isEditing)&&(identical(other.isCreatingNode, isCreatingNode) || other.isCreatingNode == isCreatingNode)&&(identical(other.isCreatingEdge, isCreatingEdge) || other.isCreatingEdge == isCreatingEdge));
}


@override
int get hashCode => Object.hash(runtimeType,isEditing,isCreatingNode,isCreatingEdge);

@override
String toString() {
  return 'GraphStatesSate(isEditing: $isEditing, isCreatingNode: $isCreatingNode, isCreatingEdge: $isCreatingEdge)';
}


}

/// @nodoc
abstract mixin class _$GraphStatesSateCopyWith<$Res> implements $GraphStatesSateCopyWith<$Res> {
  factory _$GraphStatesSateCopyWith(_GraphStatesSate value, $Res Function(_GraphStatesSate) _then) = __$GraphStatesSateCopyWithImpl;
@override @useResult
$Res call({
 bool isEditing, bool isCreatingNode, bool isCreatingEdge
});




}
/// @nodoc
class __$GraphStatesSateCopyWithImpl<$Res>
    implements _$GraphStatesSateCopyWith<$Res> {
  __$GraphStatesSateCopyWithImpl(this._self, this._then);

  final _GraphStatesSate _self;
  final $Res Function(_GraphStatesSate) _then;

/// Create a copy of GraphStatesSate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isEditing = null,Object? isCreatingNode = null,Object? isCreatingEdge = null,}) {
  return _then(_GraphStatesSate(
isEditing: null == isEditing ? _self.isEditing : isEditing // ignore: cast_nullable_to_non_nullable
as bool,isCreatingNode: null == isCreatingNode ? _self.isCreatingNode : isCreatingNode // ignore: cast_nullable_to_non_nullable
as bool,isCreatingEdge: null == isCreatingEdge ? _self.isCreatingEdge : isCreatingEdge // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on

// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'edge_form_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EdgeformState {

 String get graphId; String get sourceNodeId; String get targetNodeId; String get type; double get weight;
/// Create a copy of EdgeformState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EdgeformStateCopyWith<EdgeformState> get copyWith => _$EdgeformStateCopyWithImpl<EdgeformState>(this as EdgeformState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EdgeformState&&(identical(other.graphId, graphId) || other.graphId == graphId)&&(identical(other.sourceNodeId, sourceNodeId) || other.sourceNodeId == sourceNodeId)&&(identical(other.targetNodeId, targetNodeId) || other.targetNodeId == targetNodeId)&&(identical(other.type, type) || other.type == type)&&(identical(other.weight, weight) || other.weight == weight));
}


@override
int get hashCode => Object.hash(runtimeType,graphId,sourceNodeId,targetNodeId,type,weight);

@override
String toString() {
  return 'EdgeformState(graphId: $graphId, sourceNodeId: $sourceNodeId, targetNodeId: $targetNodeId, type: $type, weight: $weight)';
}


}

/// @nodoc
abstract mixin class $EdgeformStateCopyWith<$Res>  {
  factory $EdgeformStateCopyWith(EdgeformState value, $Res Function(EdgeformState) _then) = _$EdgeformStateCopyWithImpl;
@useResult
$Res call({
 String graphId, String sourceNodeId, String targetNodeId, String type, double weight
});




}
/// @nodoc
class _$EdgeformStateCopyWithImpl<$Res>
    implements $EdgeformStateCopyWith<$Res> {
  _$EdgeformStateCopyWithImpl(this._self, this._then);

  final EdgeformState _self;
  final $Res Function(EdgeformState) _then;

/// Create a copy of EdgeformState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? graphId = null,Object? sourceNodeId = null,Object? targetNodeId = null,Object? type = null,Object? weight = null,}) {
  return _then(_self.copyWith(
graphId: null == graphId ? _self.graphId : graphId // ignore: cast_nullable_to_non_nullable
as String,sourceNodeId: null == sourceNodeId ? _self.sourceNodeId : sourceNodeId // ignore: cast_nullable_to_non_nullable
as String,targetNodeId: null == targetNodeId ? _self.targetNodeId : targetNodeId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [EdgeformState].
extension EdgeformStatePatterns on EdgeformState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EdgeformState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EdgeformState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EdgeformState value)  $default,){
final _that = this;
switch (_that) {
case _EdgeformState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EdgeformState value)?  $default,){
final _that = this;
switch (_that) {
case _EdgeformState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String graphId,  String sourceNodeId,  String targetNodeId,  String type,  double weight)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EdgeformState() when $default != null:
return $default(_that.graphId,_that.sourceNodeId,_that.targetNodeId,_that.type,_that.weight);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String graphId,  String sourceNodeId,  String targetNodeId,  String type,  double weight)  $default,) {final _that = this;
switch (_that) {
case _EdgeformState():
return $default(_that.graphId,_that.sourceNodeId,_that.targetNodeId,_that.type,_that.weight);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String graphId,  String sourceNodeId,  String targetNodeId,  String type,  double weight)?  $default,) {final _that = this;
switch (_that) {
case _EdgeformState() when $default != null:
return $default(_that.graphId,_that.sourceNodeId,_that.targetNodeId,_that.type,_that.weight);case _:
  return null;

}
}

}

/// @nodoc


class _EdgeformState implements EdgeformState {
  const _EdgeformState({this.graphId = "", this.sourceNodeId = "", this.targetNodeId = "", this.type = "", this.weight = 0});
  

@override@JsonKey() final  String graphId;
@override@JsonKey() final  String sourceNodeId;
@override@JsonKey() final  String targetNodeId;
@override@JsonKey() final  String type;
@override@JsonKey() final  double weight;

/// Create a copy of EdgeformState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EdgeformStateCopyWith<_EdgeformState> get copyWith => __$EdgeformStateCopyWithImpl<_EdgeformState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EdgeformState&&(identical(other.graphId, graphId) || other.graphId == graphId)&&(identical(other.sourceNodeId, sourceNodeId) || other.sourceNodeId == sourceNodeId)&&(identical(other.targetNodeId, targetNodeId) || other.targetNodeId == targetNodeId)&&(identical(other.type, type) || other.type == type)&&(identical(other.weight, weight) || other.weight == weight));
}


@override
int get hashCode => Object.hash(runtimeType,graphId,sourceNodeId,targetNodeId,type,weight);

@override
String toString() {
  return 'EdgeformState(graphId: $graphId, sourceNodeId: $sourceNodeId, targetNodeId: $targetNodeId, type: $type, weight: $weight)';
}


}

/// @nodoc
abstract mixin class _$EdgeformStateCopyWith<$Res> implements $EdgeformStateCopyWith<$Res> {
  factory _$EdgeformStateCopyWith(_EdgeformState value, $Res Function(_EdgeformState) _then) = __$EdgeformStateCopyWithImpl;
@override @useResult
$Res call({
 String graphId, String sourceNodeId, String targetNodeId, String type, double weight
});




}
/// @nodoc
class __$EdgeformStateCopyWithImpl<$Res>
    implements _$EdgeformStateCopyWith<$Res> {
  __$EdgeformStateCopyWithImpl(this._self, this._then);

  final _EdgeformState _self;
  final $Res Function(_EdgeformState) _then;

/// Create a copy of EdgeformState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? graphId = null,Object? sourceNodeId = null,Object? targetNodeId = null,Object? type = null,Object? weight = null,}) {
  return _then(_EdgeformState(
graphId: null == graphId ? _self.graphId : graphId // ignore: cast_nullable_to_non_nullable
as String,sourceNodeId: null == sourceNodeId ? _self.sourceNodeId : sourceNodeId // ignore: cast_nullable_to_non_nullable
as String,targetNodeId: null == targetNodeId ? _self.targetNodeId : targetNodeId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on

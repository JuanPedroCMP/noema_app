// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'node_form_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NodeformState {

 String get graphId; String get type; String get title; String get description; double get maesteryScore; bool get isSkipped; double get positionX; double get positionY; String get aiSynthesis;
/// Create a copy of NodeformState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NodeformStateCopyWith<NodeformState> get copyWith => _$NodeformStateCopyWithImpl<NodeformState>(this as NodeformState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NodeformState&&(identical(other.graphId, graphId) || other.graphId == graphId)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.maesteryScore, maesteryScore) || other.maesteryScore == maesteryScore)&&(identical(other.isSkipped, isSkipped) || other.isSkipped == isSkipped)&&(identical(other.positionX, positionX) || other.positionX == positionX)&&(identical(other.positionY, positionY) || other.positionY == positionY)&&(identical(other.aiSynthesis, aiSynthesis) || other.aiSynthesis == aiSynthesis));
}


@override
int get hashCode => Object.hash(runtimeType,graphId,type,title,description,maesteryScore,isSkipped,positionX,positionY,aiSynthesis);

@override
String toString() {
  return 'NodeformState(graphId: $graphId, type: $type, title: $title, description: $description, maesteryScore: $maesteryScore, isSkipped: $isSkipped, positionX: $positionX, positionY: $positionY, aiSynthesis: $aiSynthesis)';
}


}

/// @nodoc
abstract mixin class $NodeformStateCopyWith<$Res>  {
  factory $NodeformStateCopyWith(NodeformState value, $Res Function(NodeformState) _then) = _$NodeformStateCopyWithImpl;
@useResult
$Res call({
 String graphId, String type, String title, String description, double maesteryScore, bool isSkipped, double positionX, double positionY, String aiSynthesis
});




}
/// @nodoc
class _$NodeformStateCopyWithImpl<$Res>
    implements $NodeformStateCopyWith<$Res> {
  _$NodeformStateCopyWithImpl(this._self, this._then);

  final NodeformState _self;
  final $Res Function(NodeformState) _then;

/// Create a copy of NodeformState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? graphId = null,Object? type = null,Object? title = null,Object? description = null,Object? maesteryScore = null,Object? isSkipped = null,Object? positionX = null,Object? positionY = null,Object? aiSynthesis = null,}) {
  return _then(_self.copyWith(
graphId: null == graphId ? _self.graphId : graphId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,maesteryScore: null == maesteryScore ? _self.maesteryScore : maesteryScore // ignore: cast_nullable_to_non_nullable
as double,isSkipped: null == isSkipped ? _self.isSkipped : isSkipped // ignore: cast_nullable_to_non_nullable
as bool,positionX: null == positionX ? _self.positionX : positionX // ignore: cast_nullable_to_non_nullable
as double,positionY: null == positionY ? _self.positionY : positionY // ignore: cast_nullable_to_non_nullable
as double,aiSynthesis: null == aiSynthesis ? _self.aiSynthesis : aiSynthesis // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [NodeformState].
extension NodeformStatePatterns on NodeformState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NodeformState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NodeformState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NodeformState value)  $default,){
final _that = this;
switch (_that) {
case _NodeformState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NodeformState value)?  $default,){
final _that = this;
switch (_that) {
case _NodeformState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String graphId,  String type,  String title,  String description,  double maesteryScore,  bool isSkipped,  double positionX,  double positionY,  String aiSynthesis)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NodeformState() when $default != null:
return $default(_that.graphId,_that.type,_that.title,_that.description,_that.maesteryScore,_that.isSkipped,_that.positionX,_that.positionY,_that.aiSynthesis);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String graphId,  String type,  String title,  String description,  double maesteryScore,  bool isSkipped,  double positionX,  double positionY,  String aiSynthesis)  $default,) {final _that = this;
switch (_that) {
case _NodeformState():
return $default(_that.graphId,_that.type,_that.title,_that.description,_that.maesteryScore,_that.isSkipped,_that.positionX,_that.positionY,_that.aiSynthesis);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String graphId,  String type,  String title,  String description,  double maesteryScore,  bool isSkipped,  double positionX,  double positionY,  String aiSynthesis)?  $default,) {final _that = this;
switch (_that) {
case _NodeformState() when $default != null:
return $default(_that.graphId,_that.type,_that.title,_that.description,_that.maesteryScore,_that.isSkipped,_that.positionX,_that.positionY,_that.aiSynthesis);case _:
  return null;

}
}

}

/// @nodoc


class _NodeformState implements NodeformState {
  const _NodeformState({this.graphId = "", this.type = "", this.title = "", this.description = "", this.maesteryScore = 0, this.isSkipped = false, this.positionX = 0, this.positionY = 0, this.aiSynthesis = ""});
  

@override@JsonKey() final  String graphId;
@override@JsonKey() final  String type;
@override@JsonKey() final  String title;
@override@JsonKey() final  String description;
@override@JsonKey() final  double maesteryScore;
@override@JsonKey() final  bool isSkipped;
@override@JsonKey() final  double positionX;
@override@JsonKey() final  double positionY;
@override@JsonKey() final  String aiSynthesis;

/// Create a copy of NodeformState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NodeformStateCopyWith<_NodeformState> get copyWith => __$NodeformStateCopyWithImpl<_NodeformState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NodeformState&&(identical(other.graphId, graphId) || other.graphId == graphId)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.maesteryScore, maesteryScore) || other.maesteryScore == maesteryScore)&&(identical(other.isSkipped, isSkipped) || other.isSkipped == isSkipped)&&(identical(other.positionX, positionX) || other.positionX == positionX)&&(identical(other.positionY, positionY) || other.positionY == positionY)&&(identical(other.aiSynthesis, aiSynthesis) || other.aiSynthesis == aiSynthesis));
}


@override
int get hashCode => Object.hash(runtimeType,graphId,type,title,description,maesteryScore,isSkipped,positionX,positionY,aiSynthesis);

@override
String toString() {
  return 'NodeformState(graphId: $graphId, type: $type, title: $title, description: $description, maesteryScore: $maesteryScore, isSkipped: $isSkipped, positionX: $positionX, positionY: $positionY, aiSynthesis: $aiSynthesis)';
}


}

/// @nodoc
abstract mixin class _$NodeformStateCopyWith<$Res> implements $NodeformStateCopyWith<$Res> {
  factory _$NodeformStateCopyWith(_NodeformState value, $Res Function(_NodeformState) _then) = __$NodeformStateCopyWithImpl;
@override @useResult
$Res call({
 String graphId, String type, String title, String description, double maesteryScore, bool isSkipped, double positionX, double positionY, String aiSynthesis
});




}
/// @nodoc
class __$NodeformStateCopyWithImpl<$Res>
    implements _$NodeformStateCopyWith<$Res> {
  __$NodeformStateCopyWithImpl(this._self, this._then);

  final _NodeformState _self;
  final $Res Function(_NodeformState) _then;

/// Create a copy of NodeformState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? graphId = null,Object? type = null,Object? title = null,Object? description = null,Object? maesteryScore = null,Object? isSkipped = null,Object? positionX = null,Object? positionY = null,Object? aiSynthesis = null,}) {
  return _then(_NodeformState(
graphId: null == graphId ? _self.graphId : graphId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,maesteryScore: null == maesteryScore ? _self.maesteryScore : maesteryScore // ignore: cast_nullable_to_non_nullable
as double,isSkipped: null == isSkipped ? _self.isSkipped : isSkipped // ignore: cast_nullable_to_non_nullable
as bool,positionX: null == positionX ? _self.positionX : positionX // ignore: cast_nullable_to_non_nullable
as double,positionY: null == positionY ? _self.positionY : positionY // ignore: cast_nullable_to_non_nullable
as double,aiSynthesis: null == aiSynthesis ? _self.aiSynthesis : aiSynthesis // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on

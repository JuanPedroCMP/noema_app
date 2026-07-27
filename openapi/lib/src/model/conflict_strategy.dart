//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'conflict_strategy.g.dart';

class ConflictStrategy extends EnumClass {

  @BuiltValueEnumConst(wireName: r'keep_local')
  static const ConflictStrategy keepLocal = _$keepLocal;
  @BuiltValueEnumConst(wireName: r'keep_remote')
  static const ConflictStrategy keepRemote = _$keepRemote;
  @BuiltValueEnumConst(wireName: r'merge')
  static const ConflictStrategy merge = _$merge;
  @BuiltValueEnumConst(wireName: r'duplicate')
  static const ConflictStrategy duplicate = _$duplicate;

  static Serializer<ConflictStrategy> get serializer => _$conflictStrategySerializer;

  const ConflictStrategy._(String name): super(name);

  static BuiltSet<ConflictStrategy> get values => _$values;
  static ConflictStrategy valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class ConflictStrategyMixin = Object with _$ConflictStrategyMixin;


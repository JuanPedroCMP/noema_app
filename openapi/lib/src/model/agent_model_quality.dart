//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'agent_model_quality.g.dart';

class AgentModelQuality extends EnumClass {

  @BuiltValueEnumConst(wireName: r'unusable')
  static const AgentModelQuality unusable = _$unusable;
  @BuiltValueEnumConst(wireName: r'poor')
  static const AgentModelQuality poor = _$poor;
  @BuiltValueEnumConst(wireName: r'fair')
  static const AgentModelQuality fair = _$fair;
  @BuiltValueEnumConst(wireName: r'good')
  static const AgentModelQuality good = _$good;
  @BuiltValueEnumConst(wireName: r'very_good')
  static const AgentModelQuality veryGood = _$veryGood;
  @BuiltValueEnumConst(wireName: r'excellent')
  static const AgentModelQuality excellent = _$excellent;

  static Serializer<AgentModelQuality> get serializer => _$agentModelQualitySerializer;

  const AgentModelQuality._(String name): super(name);

  static BuiltSet<AgentModelQuality> get values => _$values;
  static AgentModelQuality valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class AgentModelQualityMixin = Object with _$AgentModelQualityMixin;


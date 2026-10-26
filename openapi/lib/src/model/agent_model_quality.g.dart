// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agent_model_quality.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AgentModelQuality _$unusable = const AgentModelQuality._('unusable');
const AgentModelQuality _$poor = const AgentModelQuality._('poor');
const AgentModelQuality _$fair = const AgentModelQuality._('fair');
const AgentModelQuality _$good = const AgentModelQuality._('good');
const AgentModelQuality _$veryGood = const AgentModelQuality._('veryGood');
const AgentModelQuality _$excellent = const AgentModelQuality._('excellent');

AgentModelQuality _$valueOf(String name) {
  switch (name) {
    case 'unusable':
      return _$unusable;
    case 'poor':
      return _$poor;
    case 'fair':
      return _$fair;
    case 'good':
      return _$good;
    case 'veryGood':
      return _$veryGood;
    case 'excellent':
      return _$excellent;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AgentModelQuality> _$values =
    BuiltSet<AgentModelQuality>(const <AgentModelQuality>[
  _$unusable,
  _$poor,
  _$fair,
  _$good,
  _$veryGood,
  _$excellent,
]);

class _$AgentModelQualityMeta {
  const _$AgentModelQualityMeta();
  AgentModelQuality get unusable => _$unusable;
  AgentModelQuality get poor => _$poor;
  AgentModelQuality get fair => _$fair;
  AgentModelQuality get good => _$good;
  AgentModelQuality get veryGood => _$veryGood;
  AgentModelQuality get excellent => _$excellent;
  AgentModelQuality valueOf(String name) => _$valueOf(name);
  BuiltSet<AgentModelQuality> get values => _$values;
}

abstract class _$AgentModelQualityMixin {
  // ignore: non_constant_identifier_names
  _$AgentModelQualityMeta get AgentModelQuality =>
      const _$AgentModelQualityMeta();
}

Serializer<AgentModelQuality> _$agentModelQualitySerializer =
    _$AgentModelQualitySerializer();

class _$AgentModelQualitySerializer
    implements PrimitiveSerializer<AgentModelQuality> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'unusable': 'unusable',
    'poor': 'poor',
    'fair': 'fair',
    'good': 'good',
    'veryGood': 'very_good',
    'excellent': 'excellent',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'unusable': 'unusable',
    'poor': 'poor',
    'fair': 'fair',
    'good': 'good',
    'very_good': 'veryGood',
    'excellent': 'excellent',
  };

  @override
  final Iterable<Type> types = const <Type>[AgentModelQuality];
  @override
  final String wireName = 'AgentModelQuality';

  @override
  Object serialize(Serializers serializers, AgentModelQuality object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AgentModelQuality deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AgentModelQuality.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

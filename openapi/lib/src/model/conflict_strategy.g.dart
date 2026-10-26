// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conflict_strategy.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ConflictStrategy _$keepLocal = const ConflictStrategy._('keepLocal');
const ConflictStrategy _$keepRemote = const ConflictStrategy._('keepRemote');
const ConflictStrategy _$merge = const ConflictStrategy._('merge');
const ConflictStrategy _$duplicate = const ConflictStrategy._('duplicate');

ConflictStrategy _$valueOf(String name) {
  switch (name) {
    case 'keepLocal':
      return _$keepLocal;
    case 'keepRemote':
      return _$keepRemote;
    case 'merge':
      return _$merge;
    case 'duplicate':
      return _$duplicate;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ConflictStrategy> _$values =
    BuiltSet<ConflictStrategy>(const <ConflictStrategy>[
  _$keepLocal,
  _$keepRemote,
  _$merge,
  _$duplicate,
]);

class _$ConflictStrategyMeta {
  const _$ConflictStrategyMeta();
  ConflictStrategy get keepLocal => _$keepLocal;
  ConflictStrategy get keepRemote => _$keepRemote;
  ConflictStrategy get merge => _$merge;
  ConflictStrategy get duplicate => _$duplicate;
  ConflictStrategy valueOf(String name) => _$valueOf(name);
  BuiltSet<ConflictStrategy> get values => _$values;
}

abstract class _$ConflictStrategyMixin {
  // ignore: non_constant_identifier_names
  _$ConflictStrategyMeta get ConflictStrategy => const _$ConflictStrategyMeta();
}

Serializer<ConflictStrategy> _$conflictStrategySerializer =
    _$ConflictStrategySerializer();

class _$ConflictStrategySerializer
    implements PrimitiveSerializer<ConflictStrategy> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'keepLocal': 'keep_local',
    'keepRemote': 'keep_remote',
    'merge': 'merge',
    'duplicate': 'duplicate',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'keep_local': 'keepLocal',
    'keep_remote': 'keepRemote',
    'merge': 'merge',
    'duplicate': 'duplicate',
  };

  @override
  final Iterable<Type> types = const <Type>[ConflictStrategy];
  @override
  final String wireName = 'ConflictStrategy';

  @override
  Object serialize(Serializers serializers, ConflictStrategy object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ConflictStrategy deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ConflictStrategy.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_result.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const SyncResult _$success = const SyncResult._('success');
const SyncResult _$failure = const SyncResult._('failure');
const SyncResult _$inConflict = const SyncResult._('inConflict');

SyncResult _$valueOf(String name) {
  switch (name) {
    case 'success':
      return _$success;
    case 'failure':
      return _$failure;
    case 'inConflict':
      return _$inConflict;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<SyncResult> _$values = BuiltSet<SyncResult>(const <SyncResult>[
  _$success,
  _$failure,
  _$inConflict,
]);

class _$SyncResultMeta {
  const _$SyncResultMeta();
  SyncResult get success => _$success;
  SyncResult get failure => _$failure;
  SyncResult get inConflict => _$inConflict;
  SyncResult valueOf(String name) => _$valueOf(name);
  BuiltSet<SyncResult> get values => _$values;
}

abstract class _$SyncResultMixin {
  // ignore: non_constant_identifier_names
  _$SyncResultMeta get SyncResult => const _$SyncResultMeta();
}

Serializer<SyncResult> _$syncResultSerializer = _$SyncResultSerializer();

class _$SyncResultSerializer implements PrimitiveSerializer<SyncResult> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'success': 'success',
    'failure': 'failure',
    'inConflict': 'in_conflict',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'success': 'success',
    'failure': 'failure',
    'in_conflict': 'inConflict',
  };

  @override
  final Iterable<Type> types = const <Type>[SyncResult];
  @override
  final String wireName = 'SyncResult';

  @override
  Object serialize(Serializers serializers, SyncResult object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  SyncResult deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      SyncResult.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backup_operation_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const BackupOperationState _$pending = const BackupOperationState._('pending');
const BackupOperationState _$completed =
    const BackupOperationState._('completed');
const BackupOperationState _$failed = const BackupOperationState._('failed');

BackupOperationState _$valueOf(String name) {
  switch (name) {
    case 'pending':
      return _$pending;
    case 'completed':
      return _$completed;
    case 'failed':
      return _$failed;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<BackupOperationState> _$values =
    BuiltSet<BackupOperationState>(const <BackupOperationState>[
  _$pending,
  _$completed,
  _$failed,
]);

class _$BackupOperationStateMeta {
  const _$BackupOperationStateMeta();
  BackupOperationState get pending => _$pending;
  BackupOperationState get completed => _$completed;
  BackupOperationState get failed => _$failed;
  BackupOperationState valueOf(String name) => _$valueOf(name);
  BuiltSet<BackupOperationState> get values => _$values;
}

abstract class _$BackupOperationStateMixin {
  // ignore: non_constant_identifier_names
  _$BackupOperationStateMeta get BackupOperationState =>
      const _$BackupOperationStateMeta();
}

Serializer<BackupOperationState> _$backupOperationStateSerializer =
    _$BackupOperationStateSerializer();

class _$BackupOperationStateSerializer
    implements PrimitiveSerializer<BackupOperationState> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'pending': 'pending',
    'completed': 'completed',
    'failed': 'failed',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'pending': 'pending',
    'completed': 'completed',
    'failed': 'failed',
  };

  @override
  final Iterable<Type> types = const <Type>[BackupOperationState];
  @override
  final String wireName = 'BackupOperationState';

  @override
  Object serialize(Serializers serializers, BackupOperationState object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  BackupOperationState deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      BackupOperationState.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

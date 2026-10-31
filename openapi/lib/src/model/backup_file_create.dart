//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/backup_operation_state.dart';
import 'package:openapi/src/model/snapshot_manifest.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'backup_file_create.g.dart';

/// Compatibility input for the original /backup_file/create contract.
///
/// Properties:
/// * [idGoogleAccount] 
/// * [driveFileId] 
/// * [localRef] 
/// * [driveVersion] 
/// * [contentHash] 
/// * [snapshotVersion] 
/// * [idDevice] 
/// * [sizeBytes] 
/// * [operationState] 
/// * [manifest] 
/// * [idempotencyKey] 
@BuiltValue()
abstract class BackupFileCreate implements Built<BackupFileCreate, BackupFileCreateBuilder> {
  @BuiltValueField(wireName: r'id_google_account')
  String get idGoogleAccount;

  @BuiltValueField(wireName: r'drive_file_id')
  String get driveFileId;

  @BuiltValueField(wireName: r'local_ref')
  String? get localRef;

  @BuiltValueField(wireName: r'drive_version')
  String get driveVersion;

  @BuiltValueField(wireName: r'content_hash')
  String get contentHash;

  @BuiltValueField(wireName: r'snapshot_version')
  String? get snapshotVersion;

  @BuiltValueField(wireName: r'id_device')
  String? get idDevice;

  @BuiltValueField(wireName: r'size_bytes')
  int? get sizeBytes;

  @BuiltValueField(wireName: r'operation_state')
  BackupOperationState? get operationState;
  // enum operationStateEnum {  pending,  completed,  failed,  };

  @BuiltValueField(wireName: r'manifest')
  SnapshotManifest? get manifest;

  @BuiltValueField(wireName: r'idempotency_key')
  String? get idempotencyKey;

  BackupFileCreate._();

  factory BackupFileCreate([void updates(BackupFileCreateBuilder b)]) = _$BackupFileCreate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BackupFileCreateBuilder b) => b
      ..snapshotVersion = 'legacy'
      ..sizeBytes = 0
      ..operationState = BackupOperationState.completed;

  @BuiltValueSerializer(custom: true)
  static Serializer<BackupFileCreate> get serializer => _$BackupFileCreateSerializer();
}

class _$BackupFileCreateSerializer implements PrimitiveSerializer<BackupFileCreate> {
  @override
  final Iterable<Type> types = const [BackupFileCreate, _$BackupFileCreate];

  @override
  final String wireName = r'BackupFileCreate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BackupFileCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id_google_account';
    yield serializers.serialize(
      object.idGoogleAccount,
      specifiedType: const FullType(String),
    );
    yield r'drive_file_id';
    yield serializers.serialize(
      object.driveFileId,
      specifiedType: const FullType(String),
    );
    if (object.localRef != null) {
      yield r'local_ref';
      yield serializers.serialize(
        object.localRef,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'drive_version';
    yield serializers.serialize(
      object.driveVersion,
      specifiedType: const FullType(String),
    );
    yield r'content_hash';
    yield serializers.serialize(
      object.contentHash,
      specifiedType: const FullType(String),
    );
    if (object.snapshotVersion != null) {
      yield r'snapshot_version';
      yield serializers.serialize(
        object.snapshotVersion,
        specifiedType: const FullType(String),
      );
    }
    if (object.idDevice != null) {
      yield r'id_device';
      yield serializers.serialize(
        object.idDevice,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.sizeBytes != null) {
      yield r'size_bytes';
      yield serializers.serialize(
        object.sizeBytes,
        specifiedType: const FullType(int),
      );
    }
    if (object.operationState != null) {
      yield r'operation_state';
      yield serializers.serialize(
        object.operationState,
        specifiedType: const FullType(BackupOperationState),
      );
    }
    if (object.manifest != null) {
      yield r'manifest';
      yield serializers.serialize(
        object.manifest,
        specifiedType: const FullType.nullable(SnapshotManifest),
      );
    }
    if (object.idempotencyKey != null) {
      yield r'idempotency_key';
      yield serializers.serialize(
        object.idempotencyKey,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    BackupFileCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BackupFileCreateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id_google_account':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.idGoogleAccount = valueDes;
          break;
        case r'drive_file_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.driveFileId = valueDes;
          break;
        case r'local_ref':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.localRef = valueDes;
          break;
        case r'drive_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.driveVersion = valueDes;
          break;
        case r'content_hash':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.contentHash = valueDes;
          break;
        case r'snapshot_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.snapshotVersion = valueDes;
          break;
        case r'id_device':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.idDevice = valueDes;
          break;
        case r'size_bytes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.sizeBytes = valueDes;
          break;
        case r'operation_state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BackupOperationState),
          ) as BackupOperationState?;
          if (valueDes == null) continue;
          result.operationState = valueDes;
          break;
        case r'manifest':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(SnapshotManifest),
          ) as SnapshotManifest?;
          if (valueDes == null) continue;
          result.manifest.replace(valueDes);
          break;
        case r'idempotency_key':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.idempotencyKey = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BackupFileCreate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BackupFileCreateBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}



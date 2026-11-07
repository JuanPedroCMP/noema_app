//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/backup_operation_state.dart';
import 'package:openapi/src/model/snapshot_manifest.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'backup_metadata_update.g.dart';

/// BackupMetadataUpdate
///
/// Properties:
/// * [expectedDriveVersion] 
/// * [expectedContentHash] 
/// * [idempotencyKey] 
/// * [driveVersion] 
/// * [snapshotVersion] 
/// * [contentHash] 
/// * [sizeBytes] 
/// * [operationState] 
/// * [manifest] 
@BuiltValue()
abstract class BackupMetadataUpdate implements Built<BackupMetadataUpdate, BackupMetadataUpdateBuilder> {
  @BuiltValueField(wireName: r'expected_drive_version')
  String? get expectedDriveVersion;

  @BuiltValueField(wireName: r'expected_content_hash')
  String? get expectedContentHash;

  @BuiltValueField(wireName: r'idempotency_key')
  String get idempotencyKey;

  @BuiltValueField(wireName: r'drive_version')
  String get driveVersion;

  @BuiltValueField(wireName: r'snapshot_version')
  String get snapshotVersion;

  @BuiltValueField(wireName: r'content_hash')
  String get contentHash;

  @BuiltValueField(wireName: r'size_bytes')
  int get sizeBytes;

  @BuiltValueField(wireName: r'operation_state')
  BackupOperationState get operationState;
  // enum operationStateEnum {  pending,  completed,  failed,  };

  @BuiltValueField(wireName: r'manifest')
  SnapshotManifest get manifest;

  BackupMetadataUpdate._();

  factory BackupMetadataUpdate([void updates(BackupMetadataUpdateBuilder b)]) = _$BackupMetadataUpdate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BackupMetadataUpdateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BackupMetadataUpdate> get serializer => _$BackupMetadataUpdateSerializer();
}

class _$BackupMetadataUpdateSerializer implements PrimitiveSerializer<BackupMetadataUpdate> {
  @override
  final Iterable<Type> types = const [BackupMetadataUpdate, _$BackupMetadataUpdate];

  @override
  final String wireName = r'BackupMetadataUpdate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BackupMetadataUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'expected_drive_version';
    yield object.expectedDriveVersion == null ? null : serializers.serialize(
      object.expectedDriveVersion,
      specifiedType: const FullType.nullable(String),
    );
    yield r'expected_content_hash';
    yield object.expectedContentHash == null ? null : serializers.serialize(
      object.expectedContentHash,
      specifiedType: const FullType.nullable(String),
    );
    yield r'idempotency_key';
    yield serializers.serialize(
      object.idempotencyKey,
      specifiedType: const FullType(String),
    );
    yield r'drive_version';
    yield serializers.serialize(
      object.driveVersion,
      specifiedType: const FullType(String),
    );
    yield r'snapshot_version';
    yield serializers.serialize(
      object.snapshotVersion,
      specifiedType: const FullType(String),
    );
    yield r'content_hash';
    yield serializers.serialize(
      object.contentHash,
      specifiedType: const FullType(String),
    );
    yield r'size_bytes';
    yield serializers.serialize(
      object.sizeBytes,
      specifiedType: const FullType(int),
    );
    yield r'operation_state';
    yield serializers.serialize(
      object.operationState,
      specifiedType: const FullType(BackupOperationState),
    );
    yield r'manifest';
    yield serializers.serialize(
      object.manifest,
      specifiedType: const FullType(SnapshotManifest),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    BackupMetadataUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BackupMetadataUpdateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'expected_drive_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.expectedDriveVersion = valueDes;
          break;
        case r'expected_content_hash':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.expectedContentHash = valueDes;
          break;
        case r'idempotency_key':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.idempotencyKey = valueDes;
          break;
        case r'drive_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.driveVersion = valueDes;
          break;
        case r'snapshot_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.snapshotVersion = valueDes;
          break;
        case r'content_hash':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.contentHash = valueDes;
          break;
        case r'size_bytes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.sizeBytes = valueDes;
          break;
        case r'operation_state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BackupOperationState),
          ) as BackupOperationState;
          result.operationState = valueDes;
          break;
        case r'manifest':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SnapshotManifest),
          ) as SnapshotManifest;
          result.manifest.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BackupMetadataUpdate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BackupMetadataUpdateBuilder();
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



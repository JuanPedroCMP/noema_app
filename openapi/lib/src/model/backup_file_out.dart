//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/backup_operation_state.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'backup_file_out.g.dart';

/// BackupFileOut
///
/// Properties:
/// * [id] 
/// * [idGoogleAccount] 
/// * [idDevice] 
/// * [driveFileId] 
/// * [localRef] 
/// * [driveVersion] 
/// * [snapshotVersion] 
/// * [contentHash] 
/// * [sizeBytes] 
/// * [operationState] 
/// * [manifest] 
/// * [createdAt] 
/// * [updatedAt] 
@BuiltValue()
abstract class BackupFileOut implements Built<BackupFileOut, BackupFileOutBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'id_google_account')
  String get idGoogleAccount;

  @BuiltValueField(wireName: r'id_device')
  String? get idDevice;

  @BuiltValueField(wireName: r'drive_file_id')
  String get driveFileId;

  @BuiltValueField(wireName: r'local_ref')
  String? get localRef;

  @BuiltValueField(wireName: r'drive_version')
  String? get driveVersion;

  @BuiltValueField(wireName: r'snapshot_version')
  String? get snapshotVersion;

  @BuiltValueField(wireName: r'content_hash')
  String? get contentHash;

  @BuiltValueField(wireName: r'size_bytes')
  int? get sizeBytes;

  @BuiltValueField(wireName: r'operation_state')
  BackupOperationState get operationState;
  // enum operationStateEnum {  pending,  completed,  failed,  };

  @BuiltValueField(wireName: r'manifest')
  BuiltMap<String, JsonObject?>? get manifest;

  @BuiltValueField(wireName: r'created_at')
  DateTime? get createdAt;

  @BuiltValueField(wireName: r'updated_at')
  DateTime? get updatedAt;

  BackupFileOut._();

  factory BackupFileOut([void updates(BackupFileOutBuilder b)]) = _$BackupFileOut;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BackupFileOutBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BackupFileOut> get serializer => _$BackupFileOutSerializer();
}

class _$BackupFileOutSerializer implements PrimitiveSerializer<BackupFileOut> {
  @override
  final Iterable<Type> types = const [BackupFileOut, _$BackupFileOut];

  @override
  final String wireName = r'BackupFileOut';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BackupFileOut object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'id_google_account';
    yield serializers.serialize(
      object.idGoogleAccount,
      specifiedType: const FullType(String),
    );
    yield r'id_device';
    yield object.idDevice == null ? null : serializers.serialize(
      object.idDevice,
      specifiedType: const FullType.nullable(String),
    );
    yield r'drive_file_id';
    yield serializers.serialize(
      object.driveFileId,
      specifiedType: const FullType(String),
    );
    yield r'local_ref';
    yield object.localRef == null ? null : serializers.serialize(
      object.localRef,
      specifiedType: const FullType.nullable(String),
    );
    yield r'drive_version';
    yield object.driveVersion == null ? null : serializers.serialize(
      object.driveVersion,
      specifiedType: const FullType.nullable(String),
    );
    yield r'snapshot_version';
    yield object.snapshotVersion == null ? null : serializers.serialize(
      object.snapshotVersion,
      specifiedType: const FullType.nullable(String),
    );
    yield r'content_hash';
    yield object.contentHash == null ? null : serializers.serialize(
      object.contentHash,
      specifiedType: const FullType.nullable(String),
    );
    yield r'size_bytes';
    yield object.sizeBytes == null ? null : serializers.serialize(
      object.sizeBytes,
      specifiedType: const FullType.nullable(int),
    );
    yield r'operation_state';
    yield serializers.serialize(
      object.operationState,
      specifiedType: const FullType(BackupOperationState),
    );
    yield r'manifest';
    yield object.manifest == null ? null : serializers.serialize(
      object.manifest,
      specifiedType: const FullType.nullable(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
    yield r'created_at';
    yield object.createdAt == null ? null : serializers.serialize(
      object.createdAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'updated_at';
    yield object.updatedAt == null ? null : serializers.serialize(
      object.updatedAt,
      specifiedType: const FullType.nullable(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    BackupFileOut object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BackupFileOutBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'id_google_account':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.idGoogleAccount = valueDes;
          break;
        case r'id_device':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.idDevice = valueDes;
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
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.driveVersion = valueDes;
          break;
        case r'snapshot_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.snapshotVersion = valueDes;
          break;
        case r'content_hash':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.contentHash = valueDes;
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
            specifiedType: const FullType(BackupOperationState),
          ) as BackupOperationState;
          result.operationState = valueDes;
          break;
        case r'manifest':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>?;
          if (valueDes == null) continue;
          result.manifest.replace(valueDes);
          break;
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.createdAt = valueDes;
          break;
        case r'updated_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.updatedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BackupFileOut deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BackupFileOutBuilder();
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



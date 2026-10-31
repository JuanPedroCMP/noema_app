//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/sync_result.dart';
import 'package:openapi/src/model/sync_direction.dart';
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/conflict_strategy.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'sync_log_create.g.dart';

/// SyncLogCreate
///
/// Properties:
/// * [idDevice] 
/// * [idBackupFile] 
/// * [idGoogleAccount] 
/// * [idempotencyKey] 
/// * [event] 
/// * [derection] 
/// * [result] 
/// * [conflictStrategy] 
/// * [errorDetails] 
/// * [metadata] 
@BuiltValue()
abstract class SyncLogCreate implements Built<SyncLogCreate, SyncLogCreateBuilder> {
  @BuiltValueField(wireName: r'id_device')
  String get idDevice;

  @BuiltValueField(wireName: r'id_backup_file')
  String? get idBackupFile;

  @BuiltValueField(wireName: r'id_google_account')
  String? get idGoogleAccount;

  @BuiltValueField(wireName: r'idempotency_key')
  String? get idempotencyKey;

  @BuiltValueField(wireName: r'event')
  SyncLogCreateEventEnum get event;
  // enum eventEnum {  sync_started,  sync_completed,  sync_failed,  conflict_detected,  authorization_refreshed,  backup_created,  backup_updated,  backup_deleted,  };

  @BuiltValueField(wireName: r'derection')
  SyncDirection get derection;
  // enum derectionEnum {  upload,  download,  };

  @BuiltValueField(wireName: r'result')
  SyncResult get result;
  // enum resultEnum {  success,  failure,  in_conflict,  };

  @BuiltValueField(wireName: r'conflict_strategy')
  ConflictStrategy? get conflictStrategy;
  // enum conflictStrategyEnum {  keep_local,  keep_remote,  merge,  duplicate,  };

  @BuiltValueField(wireName: r'error_details')
  SyncLogCreateErrorDetailsEnum? get errorDetails;
  // enum errorDetailsEnum {  google_authorization_revoked,  drive_appdata_scope_missing,  drive_revision_conflict,  drive_file_missing,  drive_quota_exceeded,  network_unavailable,  snapshot_validation_failed,  restore_failed,  unknown_error,  };

  @BuiltValueField(wireName: r'metadata')
  BuiltMap<String, JsonObject?>? get metadata;

  SyncLogCreate._();

  factory SyncLogCreate([void updates(SyncLogCreateBuilder b)]) = _$SyncLogCreate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SyncLogCreateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SyncLogCreate> get serializer => _$SyncLogCreateSerializer();
}

class _$SyncLogCreateSerializer implements PrimitiveSerializer<SyncLogCreate> {
  @override
  final Iterable<Type> types = const [SyncLogCreate, _$SyncLogCreate];

  @override
  final String wireName = r'SyncLogCreate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SyncLogCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id_device';
    yield serializers.serialize(
      object.idDevice,
      specifiedType: const FullType(String),
    );
    if (object.idBackupFile != null) {
      yield r'id_backup_file';
      yield serializers.serialize(
        object.idBackupFile,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.idGoogleAccount != null) {
      yield r'id_google_account';
      yield serializers.serialize(
        object.idGoogleAccount,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.idempotencyKey != null) {
      yield r'idempotency_key';
      yield serializers.serialize(
        object.idempotencyKey,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'event';
    yield serializers.serialize(
      object.event,
      specifiedType: const FullType(SyncLogCreateEventEnum),
    );
    yield r'derection';
    yield serializers.serialize(
      object.derection,
      specifiedType: const FullType(SyncDirection),
    );
    yield r'result';
    yield serializers.serialize(
      object.result,
      specifiedType: const FullType(SyncResult),
    );
    if (object.conflictStrategy != null) {
      yield r'conflict_strategy';
      yield serializers.serialize(
        object.conflictStrategy,
        specifiedType: const FullType.nullable(ConflictStrategy),
      );
    }
    if (object.errorDetails != null) {
      yield r'error_details';
      yield serializers.serialize(
        object.errorDetails,
        specifiedType: const FullType.nullable(SyncLogCreateErrorDetailsEnum),
      );
    }
    if (object.metadata != null) {
      yield r'metadata';
      yield serializers.serialize(
        object.metadata,
        specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    SyncLogCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SyncLogCreateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id_device':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.idDevice = valueDes;
          break;
        case r'id_backup_file':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.idBackupFile = valueDes;
          break;
        case r'id_google_account':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.idGoogleAccount = valueDes;
          break;
        case r'idempotency_key':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.idempotencyKey = valueDes;
          break;
        case r'event':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SyncLogCreateEventEnum),
          ) as SyncLogCreateEventEnum;
          result.event = valueDes;
          break;
        case r'derection':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SyncDirection),
          ) as SyncDirection;
          result.derection = valueDes;
          break;
        case r'result':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SyncResult),
          ) as SyncResult;
          result.result = valueDes;
          break;
        case r'conflict_strategy':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ConflictStrategy),
          ) as ConflictStrategy?;
          if (valueDes == null) continue;
          result.conflictStrategy = valueDes;
          break;
        case r'error_details':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(SyncLogCreateErrorDetailsEnum),
          ) as SyncLogCreateErrorDetailsEnum?;
          if (valueDes == null) continue;
          result.errorDetails = valueDes;
          break;
        case r'metadata':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>?;
          if (valueDes == null) continue;
          result.metadata.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SyncLogCreate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SyncLogCreateBuilder();
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


class SyncLogCreateEventEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'sync_started')
  static const SyncLogCreateEventEnum syncStarted = _$syncLogCreateEventEnum_syncStarted;
  @BuiltValueEnumConst(wireName: r'sync_completed')
  static const SyncLogCreateEventEnum syncCompleted = _$syncLogCreateEventEnum_syncCompleted;
  @BuiltValueEnumConst(wireName: r'sync_failed')
  static const SyncLogCreateEventEnum syncFailed = _$syncLogCreateEventEnum_syncFailed;
  @BuiltValueEnumConst(wireName: r'conflict_detected')
  static const SyncLogCreateEventEnum conflictDetected = _$syncLogCreateEventEnum_conflictDetected;
  @BuiltValueEnumConst(wireName: r'authorization_refreshed')
  static const SyncLogCreateEventEnum authorizationRefreshed = _$syncLogCreateEventEnum_authorizationRefreshed;
  @BuiltValueEnumConst(wireName: r'backup_created')
  static const SyncLogCreateEventEnum backupCreated = _$syncLogCreateEventEnum_backupCreated;
  @BuiltValueEnumConst(wireName: r'backup_updated')
  static const SyncLogCreateEventEnum backupUpdated = _$syncLogCreateEventEnum_backupUpdated;
  @BuiltValueEnumConst(wireName: r'backup_deleted')
  static const SyncLogCreateEventEnum backupDeleted = _$syncLogCreateEventEnum_backupDeleted;

  static Serializer<SyncLogCreateEventEnum> get serializer => _$syncLogCreateEventEnumSerializer;

  const SyncLogCreateEventEnum._(String name): super(name);

  static BuiltSet<SyncLogCreateEventEnum> get values => _$syncLogCreateEventEnumValues;
  static SyncLogCreateEventEnum valueOf(String name) => _$syncLogCreateEventEnumValueOf(name);
}

class SyncLogCreateErrorDetailsEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'google_authorization_revoked')
  static const SyncLogCreateErrorDetailsEnum googleAuthorizationRevoked = _$syncLogCreateErrorDetailsEnum_googleAuthorizationRevoked;
  @BuiltValueEnumConst(wireName: r'drive_appdata_scope_missing')
  static const SyncLogCreateErrorDetailsEnum driveAppdataScopeMissing = _$syncLogCreateErrorDetailsEnum_driveAppdataScopeMissing;
  @BuiltValueEnumConst(wireName: r'drive_revision_conflict')
  static const SyncLogCreateErrorDetailsEnum driveRevisionConflict = _$syncLogCreateErrorDetailsEnum_driveRevisionConflict;
  @BuiltValueEnumConst(wireName: r'drive_file_missing')
  static const SyncLogCreateErrorDetailsEnum driveFileMissing = _$syncLogCreateErrorDetailsEnum_driveFileMissing;
  @BuiltValueEnumConst(wireName: r'drive_quota_exceeded')
  static const SyncLogCreateErrorDetailsEnum driveQuotaExceeded = _$syncLogCreateErrorDetailsEnum_driveQuotaExceeded;
  @BuiltValueEnumConst(wireName: r'network_unavailable')
  static const SyncLogCreateErrorDetailsEnum networkUnavailable = _$syncLogCreateErrorDetailsEnum_networkUnavailable;
  @BuiltValueEnumConst(wireName: r'snapshot_validation_failed')
  static const SyncLogCreateErrorDetailsEnum snapshotValidationFailed = _$syncLogCreateErrorDetailsEnum_snapshotValidationFailed;
  @BuiltValueEnumConst(wireName: r'restore_failed')
  static const SyncLogCreateErrorDetailsEnum restoreFailed = _$syncLogCreateErrorDetailsEnum_restoreFailed;
  @BuiltValueEnumConst(wireName: r'unknown_error')
  static const SyncLogCreateErrorDetailsEnum unknownError = _$syncLogCreateErrorDetailsEnum_unknownError;

  static Serializer<SyncLogCreateErrorDetailsEnum> get serializer => _$syncLogCreateErrorDetailsEnumSerializer;

  const SyncLogCreateErrorDetailsEnum._(String name): super(name);

  static BuiltSet<SyncLogCreateErrorDetailsEnum> get values => _$syncLogCreateErrorDetailsEnumValues;
  static SyncLogCreateErrorDetailsEnum valueOf(String name) => _$syncLogCreateErrorDetailsEnumValueOf(name);
}


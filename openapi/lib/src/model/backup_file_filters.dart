//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/backup_operation_state.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'backup_file_filters.g.dart';

/// BackupFileFilters
///
/// Properties:
/// * [id] 
/// * [idGoogleAccount] 
/// * [idDevice] 
/// * [driveFileId] 
/// * [localRef] 
/// * [snapshotVersion] 
/// * [operationState] 
@BuiltValue()
abstract class BackupFileFilters implements Built<BackupFileFilters, BackupFileFiltersBuilder> {
  @BuiltValueField(wireName: r'id')
  String? get id;

  @BuiltValueField(wireName: r'id_google_account')
  String? get idGoogleAccount;

  @BuiltValueField(wireName: r'id_device')
  String? get idDevice;

  @BuiltValueField(wireName: r'drive_file_id')
  String? get driveFileId;

  @BuiltValueField(wireName: r'local_ref')
  String? get localRef;

  @BuiltValueField(wireName: r'snapshot_version')
  String? get snapshotVersion;

  @BuiltValueField(wireName: r'operation_state')
  BackupOperationState? get operationState;
  // enum operationStateEnum {  pending,  completed,  failed,  };

  BackupFileFilters._();

  factory BackupFileFilters([void updates(BackupFileFiltersBuilder b)]) = _$BackupFileFilters;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BackupFileFiltersBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BackupFileFilters> get serializer => _$BackupFileFiltersSerializer();
}

class _$BackupFileFiltersSerializer implements PrimitiveSerializer<BackupFileFilters> {
  @override
  final Iterable<Type> types = const [BackupFileFilters, _$BackupFileFilters];

  @override
  final String wireName = r'BackupFileFilters';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BackupFileFilters object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
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
    if (object.idDevice != null) {
      yield r'id_device';
      yield serializers.serialize(
        object.idDevice,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.driveFileId != null) {
      yield r'drive_file_id';
      yield serializers.serialize(
        object.driveFileId,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.localRef != null) {
      yield r'local_ref';
      yield serializers.serialize(
        object.localRef,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.snapshotVersion != null) {
      yield r'snapshot_version';
      yield serializers.serialize(
        object.snapshotVersion,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.operationState != null) {
      yield r'operation_state';
      yield serializers.serialize(
        object.operationState,
        specifiedType: const FullType.nullable(BackupOperationState),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    BackupFileFilters object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BackupFileFiltersBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.id = valueDes;
          break;
        case r'id_google_account':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
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
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
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
        case r'snapshot_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.snapshotVersion = valueDes;
          break;
        case r'operation_state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BackupOperationState),
          ) as BackupOperationState?;
          if (valueDes == null) continue;
          result.operationState = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BackupFileFilters deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BackupFileFiltersBuilder();
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



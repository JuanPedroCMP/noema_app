//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/sync_result.dart';
import 'package:openapi/src/model/sync_direction.dart';
import 'package:openapi/src/model/conflict_strategy.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'sync_log_create.g.dart';

/// SyncLogCreate
///
/// Properties:
/// * [idDevice] 
/// * [idBackupFile] 
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
  String get idBackupFile;

  @BuiltValueField(wireName: r'event')
  String get event;

  @BuiltValueField(wireName: r'derection')
  SyncDirection get derection;
  // enum derectionEnum {  upload,  download,  };

  @BuiltValueField(wireName: r'result')
  SyncResult get result;
  // enum resultEnum {  success,  failure,  in_conflict,  };

  @BuiltValueField(wireName: r'conflict_strategy')
  ConflictStrategy get conflictStrategy;
  // enum conflictStrategyEnum {  keep_local,  keep_remote,  merge,  duplicate,  };

  @BuiltValueField(wireName: r'error_details')
  String get errorDetails;

  @BuiltValueField(wireName: r'metadata')
  String get metadata;

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
    yield r'id_backup_file';
    yield serializers.serialize(
      object.idBackupFile,
      specifiedType: const FullType(String),
    );
    yield r'event';
    yield serializers.serialize(
      object.event,
      specifiedType: const FullType(String),
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
    yield r'conflict_strategy';
    yield serializers.serialize(
      object.conflictStrategy,
      specifiedType: const FullType(ConflictStrategy),
    );
    yield r'error_details';
    yield serializers.serialize(
      object.errorDetails,
      specifiedType: const FullType(String),
    );
    yield r'metadata';
    yield serializers.serialize(
      object.metadata,
      specifiedType: const FullType(String),
    );
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
            specifiedType: const FullType(String),
          ) as String;
          result.idBackupFile = valueDes;
          break;
        case r'event':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
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
            specifiedType: const FullType(ConflictStrategy),
          ) as ConflictStrategy;
          result.conflictStrategy = valueDes;
          break;
        case r'error_details':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.errorDetails = valueDes;
          break;
        case r'metadata':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.metadata = valueDes;
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


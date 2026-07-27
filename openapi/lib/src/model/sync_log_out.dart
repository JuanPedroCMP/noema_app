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

part 'sync_log_out.g.dart';

/// SyncLogOut
///
/// Properties:
/// * [id] 
/// * [idDevice] 
/// * [idBackupFile] 
/// * [event] 
/// * [derection] 
/// * [result] 
/// * [conflictStrategy] 
/// * [errorDetails] 
/// * [metadata] 
/// * [createdAt] 
@BuiltValue()
abstract class SyncLogOut implements Built<SyncLogOut, SyncLogOutBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'id_device')
  String get idDevice;

  @BuiltValueField(wireName: r'id_backup_file')
  String get idBackupFile;

  @BuiltValueField(wireName: r'event')
  String get event;

  @BuiltValueField(wireName: r'derection')
  SyncDirection? get derection;
  // enum derectionEnum {  upload,  download,  };

  @BuiltValueField(wireName: r'result')
  SyncResult? get result;
  // enum resultEnum {  success,  failure,  in_conflict,  };

  @BuiltValueField(wireName: r'conflict_strategy')
  ConflictStrategy? get conflictStrategy;
  // enum conflictStrategyEnum {  keep_local,  keep_remote,  merge,  duplicate,  };

  @BuiltValueField(wireName: r'error_details')
  String get errorDetails;

  @BuiltValueField(wireName: r'metadata')
  BuiltMap<String, JsonObject?> get metadata;

  @BuiltValueField(wireName: r'created_at')
  DateTime? get createdAt;

  SyncLogOut._();

  factory SyncLogOut([void updates(SyncLogOutBuilder b)]) = _$SyncLogOut;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SyncLogOutBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SyncLogOut> get serializer => _$SyncLogOutSerializer();
}

class _$SyncLogOutSerializer implements PrimitiveSerializer<SyncLogOut> {
  @override
  final Iterable<Type> types = const [SyncLogOut, _$SyncLogOut];

  @override
  final String wireName = r'SyncLogOut';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SyncLogOut object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
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
    yield object.derection == null ? null : serializers.serialize(
      object.derection,
      specifiedType: const FullType.nullable(SyncDirection),
    );
    yield r'result';
    yield object.result == null ? null : serializers.serialize(
      object.result,
      specifiedType: const FullType.nullable(SyncResult),
    );
    yield r'conflict_strategy';
    yield object.conflictStrategy == null ? null : serializers.serialize(
      object.conflictStrategy,
      specifiedType: const FullType.nullable(ConflictStrategy),
    );
    yield r'error_details';
    yield serializers.serialize(
      object.errorDetails,
      specifiedType: const FullType(String),
    );
    yield r'metadata';
    yield serializers.serialize(
      object.metadata,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
    yield r'created_at';
    yield object.createdAt == null ? null : serializers.serialize(
      object.createdAt,
      specifiedType: const FullType.nullable(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SyncLogOut object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SyncLogOutBuilder result,
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
            specifiedType: const FullType.nullable(SyncDirection),
          ) as SyncDirection?;
          if (valueDes == null) continue;
          result.derection = valueDes;
          break;
        case r'result':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(SyncResult),
          ) as SyncResult?;
          if (valueDes == null) continue;
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
            specifiedType: const FullType(String),
          ) as String;
          result.errorDetails = valueDes;
          break;
        case r'metadata':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.metadata.replace(valueDes);
          break;
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.createdAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SyncLogOut deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SyncLogOutBuilder();
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


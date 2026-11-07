//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/sync_result.dart';
import 'package:openapi/src/model/sync_direction.dart';
import 'package:openapi/src/model/conflict_strategy.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'sync_log_filters.g.dart';

/// SyncLogFilters
///
/// Properties:
/// * [id] 
/// * [idDevice] 
/// * [idBackupFile] 
/// * [idGoogleAccount] 
/// * [event] 
/// * [derection] 
/// * [result] 
/// * [conflictStrategy] 
@BuiltValue()
abstract class SyncLogFilters implements Built<SyncLogFilters, SyncLogFiltersBuilder> {
  @BuiltValueField(wireName: r'id')
  String? get id;

  @BuiltValueField(wireName: r'id_device')
  String? get idDevice;

  @BuiltValueField(wireName: r'id_backup_file')
  String? get idBackupFile;

  @BuiltValueField(wireName: r'id_google_account')
  String? get idGoogleAccount;

  @BuiltValueField(wireName: r'event')
  String? get event;

  @BuiltValueField(wireName: r'derection')
  SyncDirection? get derection;
  // enum derectionEnum {  upload,  download,  };

  @BuiltValueField(wireName: r'result')
  SyncResult? get result;
  // enum resultEnum {  success,  failure,  in_conflict,  };

  @BuiltValueField(wireName: r'conflict_strategy')
  ConflictStrategy? get conflictStrategy;
  // enum conflictStrategyEnum {  keep_local,  keep_remote,  merge,  duplicate,  };

  SyncLogFilters._();

  factory SyncLogFilters([void updates(SyncLogFiltersBuilder b)]) = _$SyncLogFilters;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SyncLogFiltersBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SyncLogFilters> get serializer => _$SyncLogFiltersSerializer();
}

class _$SyncLogFiltersSerializer implements PrimitiveSerializer<SyncLogFilters> {
  @override
  final Iterable<Type> types = const [SyncLogFilters, _$SyncLogFilters];

  @override
  final String wireName = r'SyncLogFilters';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SyncLogFilters object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
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
    if (object.event != null) {
      yield r'event';
      yield serializers.serialize(
        object.event,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.derection != null) {
      yield r'derection';
      yield serializers.serialize(
        object.derection,
        specifiedType: const FullType.nullable(SyncDirection),
      );
    }
    if (object.result != null) {
      yield r'result';
      yield serializers.serialize(
        object.result,
        specifiedType: const FullType.nullable(SyncResult),
      );
    }
    if (object.conflictStrategy != null) {
      yield r'conflict_strategy';
      yield serializers.serialize(
        object.conflictStrategy,
        specifiedType: const FullType.nullable(ConflictStrategy),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    SyncLogFilters object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SyncLogFiltersBuilder result,
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
        case r'id_device':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
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
        case r'event':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SyncLogFilters deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SyncLogFiltersBuilder();
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



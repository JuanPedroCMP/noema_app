//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'backup_file_out.g.dart';

/// BackupFileOut
///
/// Properties:
/// * [id] 
/// * [idGoogleAccount] 
/// * [driveFileId] 
/// * [localRef] 
/// * [driveVersion] 
/// * [contentHash] 
/// * [createdAt] 
@BuiltValue()
abstract class BackupFileOut implements Built<BackupFileOut, BackupFileOutBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'id_google_account')
  String get idGoogleAccount;

  @BuiltValueField(wireName: r'drive_file_id')
  String get driveFileId;

  @BuiltValueField(wireName: r'local_ref')
  String get localRef;

  @BuiltValueField(wireName: r'drive_version')
  String get driveVersion;

  @BuiltValueField(wireName: r'content_hash')
  String get contentHash;

  @BuiltValueField(wireName: r'created_at')
  DateTime? get createdAt;

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
    yield r'drive_file_id';
    yield serializers.serialize(
      object.driveFileId,
      specifiedType: const FullType(String),
    );
    yield r'local_ref';
    yield serializers.serialize(
      object.localRef,
      specifiedType: const FullType(String),
    );
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
    yield r'created_at';
    yield object.createdAt == null ? null : serializers.serialize(
      object.createdAt,
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
            specifiedType: const FullType(String),
          ) as String;
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


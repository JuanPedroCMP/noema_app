//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'backup_file_create.g.dart';

/// BackupFileCreate
///
/// Properties:
/// * [idGoogleAccount] 
/// * [driveFileId] 
/// * [localRef] 
/// * [driveVersion] 
/// * [contentHash] 
@BuiltValue()
abstract class BackupFileCreate implements Built<BackupFileCreate, BackupFileCreateBuilder> {
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

  BackupFileCreate._();

  factory BackupFileCreate([void updates(BackupFileCreateBuilder b)]) = _$BackupFileCreate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BackupFileCreateBuilder b) => b;

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


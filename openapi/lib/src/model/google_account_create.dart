//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'google_account_create.g.dart';

/// GoogleAccountCreate
///
/// Properties:
/// * [idUser] 
/// * [googleUserId] 
/// * [emailGoogle] 
/// * [accessTokenEnc] 
/// * [refreshTokenEnc] 
/// * [grantedScopes] 
/// * [isActive] 
/// * [expiresAt] 
@BuiltValue()
abstract class GoogleAccountCreate implements Built<GoogleAccountCreate, GoogleAccountCreateBuilder> {
  @BuiltValueField(wireName: r'id_user')
  String get idUser;

  @BuiltValueField(wireName: r'google_user_id')
  String? get googleUserId;

  @BuiltValueField(wireName: r'email_google')
  String get emailGoogle;

  @BuiltValueField(wireName: r'access_token_enc')
  String? get accessTokenEnc;

  @BuiltValueField(wireName: r'refresh_token_enc')
  String? get refreshTokenEnc;

  @BuiltValueField(wireName: r'granted_scopes')
  String? get grantedScopes;

  @BuiltValueField(wireName: r'is_active')
  bool get isActive;

  @BuiltValueField(wireName: r'expires_at')
  DateTime? get expiresAt;

  GoogleAccountCreate._();

  factory GoogleAccountCreate([void updates(GoogleAccountCreateBuilder b)]) = _$GoogleAccountCreate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GoogleAccountCreateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GoogleAccountCreate> get serializer => _$GoogleAccountCreateSerializer();
}

class _$GoogleAccountCreateSerializer implements PrimitiveSerializer<GoogleAccountCreate> {
  @override
  final Iterable<Type> types = const [GoogleAccountCreate, _$GoogleAccountCreate];

  @override
  final String wireName = r'GoogleAccountCreate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GoogleAccountCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id_user';
    yield serializers.serialize(
      object.idUser,
      specifiedType: const FullType(String),
    );
    yield r'google_user_id';
    yield object.googleUserId == null ? null : serializers.serialize(
      object.googleUserId,
      specifiedType: const FullType.nullable(String),
    );
    yield r'email_google';
    yield serializers.serialize(
      object.emailGoogle,
      specifiedType: const FullType(String),
    );
    yield r'access_token_enc';
    yield object.accessTokenEnc == null ? null : serializers.serialize(
      object.accessTokenEnc,
      specifiedType: const FullType.nullable(String),
    );
    yield r'refresh_token_enc';
    yield object.refreshTokenEnc == null ? null : serializers.serialize(
      object.refreshTokenEnc,
      specifiedType: const FullType.nullable(String),
    );
    yield r'granted_scopes';
    yield object.grantedScopes == null ? null : serializers.serialize(
      object.grantedScopes,
      specifiedType: const FullType.nullable(String),
    );
    yield r'is_active';
    yield serializers.serialize(
      object.isActive,
      specifiedType: const FullType(bool),
    );
    yield r'expires_at';
    yield object.expiresAt == null ? null : serializers.serialize(
      object.expiresAt,
      specifiedType: const FullType.nullable(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    GoogleAccountCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GoogleAccountCreateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id_user':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.idUser = valueDes;
          break;
        case r'google_user_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.googleUserId = valueDes;
          break;
        case r'email_google':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.emailGoogle = valueDes;
          break;
        case r'access_token_enc':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.accessTokenEnc = valueDes;
          break;
        case r'refresh_token_enc':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.refreshTokenEnc = valueDes;
          break;
        case r'granted_scopes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.grantedScopes = valueDes;
          break;
        case r'is_active':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isActive = valueDes;
          break;
        case r'expires_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.expiresAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GoogleAccountCreate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GoogleAccountCreateBuilder();
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


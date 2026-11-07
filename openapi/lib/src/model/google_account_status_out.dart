//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'google_account_status_out.g.dart';

/// GoogleAccountStatusOut
///
/// Properties:
/// * [accountId] 
/// * [googleEmail] 
/// * [state] 
/// * [driveAppdataGranted] 
/// * [syncAvailable] 
/// * [grantedScopes] 
/// * [checkedAt] 
/// * [error] 
@BuiltValue()
abstract class GoogleAccountStatusOut implements Built<GoogleAccountStatusOut, GoogleAccountStatusOutBuilder> {
  @BuiltValueField(wireName: r'account_id')
  String? get accountId;

  @BuiltValueField(wireName: r'google_email')
  String? get googleEmail;

  @BuiltValueField(wireName: r'state')
  GoogleAccountStatusOutStateEnum get state;
  // enum stateEnum {  not_linked,  granted,  missing,  revoked,  unknown,  };

  @BuiltValueField(wireName: r'drive_appdata_granted')
  bool get driveAppdataGranted;

  @BuiltValueField(wireName: r'sync_available')
  bool get syncAvailable;

  @BuiltValueField(wireName: r'granted_scopes')
  BuiltList<String> get grantedScopes;

  @BuiltValueField(wireName: r'checked_at')
  DateTime? get checkedAt;

  @BuiltValueField(wireName: r'error')
  GoogleAccountStatusOutErrorEnum? get error;
  // enum errorEnum {  google_account_not_linked,  drive_appdata_scope_missing,  google_authorization_revoked,  google_authorization_unverified,  };

  GoogleAccountStatusOut._();

  factory GoogleAccountStatusOut([void updates(GoogleAccountStatusOutBuilder b)]) = _$GoogleAccountStatusOut;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GoogleAccountStatusOutBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GoogleAccountStatusOut> get serializer => _$GoogleAccountStatusOutSerializer();
}

class _$GoogleAccountStatusOutSerializer implements PrimitiveSerializer<GoogleAccountStatusOut> {
  @override
  final Iterable<Type> types = const [GoogleAccountStatusOut, _$GoogleAccountStatusOut];

  @override
  final String wireName = r'GoogleAccountStatusOut';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GoogleAccountStatusOut object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'account_id';
    yield object.accountId == null ? null : serializers.serialize(
      object.accountId,
      specifiedType: const FullType.nullable(String),
    );
    yield r'google_email';
    yield object.googleEmail == null ? null : serializers.serialize(
      object.googleEmail,
      specifiedType: const FullType.nullable(String),
    );
    yield r'state';
    yield serializers.serialize(
      object.state,
      specifiedType: const FullType(GoogleAccountStatusOutStateEnum),
    );
    yield r'drive_appdata_granted';
    yield serializers.serialize(
      object.driveAppdataGranted,
      specifiedType: const FullType(bool),
    );
    yield r'sync_available';
    yield serializers.serialize(
      object.syncAvailable,
      specifiedType: const FullType(bool),
    );
    yield r'granted_scopes';
    yield serializers.serialize(
      object.grantedScopes,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'checked_at';
    yield object.checkedAt == null ? null : serializers.serialize(
      object.checkedAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'error';
    yield object.error == null ? null : serializers.serialize(
      object.error,
      specifiedType: const FullType.nullable(GoogleAccountStatusOutErrorEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    GoogleAccountStatusOut object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GoogleAccountStatusOutBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'account_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.accountId = valueDes;
          break;
        case r'google_email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.googleEmail = valueDes;
          break;
        case r'state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(GoogleAccountStatusOutStateEnum),
          ) as GoogleAccountStatusOutStateEnum;
          result.state = valueDes;
          break;
        case r'drive_appdata_granted':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.driveAppdataGranted = valueDes;
          break;
        case r'sync_available':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.syncAvailable = valueDes;
          break;
        case r'granted_scopes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.grantedScopes.replace(valueDes);
          break;
        case r'checked_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.checkedAt = valueDes;
          break;
        case r'error':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(GoogleAccountStatusOutErrorEnum),
          ) as GoogleAccountStatusOutErrorEnum?;
          if (valueDes == null) continue;
          result.error = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GoogleAccountStatusOut deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GoogleAccountStatusOutBuilder();
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


class GoogleAccountStatusOutStateEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'not_linked')
  static const GoogleAccountStatusOutStateEnum notLinked = _$googleAccountStatusOutStateEnum_notLinked;
  @BuiltValueEnumConst(wireName: r'granted')
  static const GoogleAccountStatusOutStateEnum granted = _$googleAccountStatusOutStateEnum_granted;
  @BuiltValueEnumConst(wireName: r'missing')
  static const GoogleAccountStatusOutStateEnum missing = _$googleAccountStatusOutStateEnum_missing;
  @BuiltValueEnumConst(wireName: r'revoked')
  static const GoogleAccountStatusOutStateEnum revoked = _$googleAccountStatusOutStateEnum_revoked;
  @BuiltValueEnumConst(wireName: r'unknown')
  static const GoogleAccountStatusOutStateEnum unknown = _$googleAccountStatusOutStateEnum_unknown;

  static Serializer<GoogleAccountStatusOutStateEnum> get serializer => _$googleAccountStatusOutStateEnumSerializer;

  const GoogleAccountStatusOutStateEnum._(String name): super(name);

  static BuiltSet<GoogleAccountStatusOutStateEnum> get values => _$googleAccountStatusOutStateEnumValues;
  static GoogleAccountStatusOutStateEnum valueOf(String name) => _$googleAccountStatusOutStateEnumValueOf(name);
}

class GoogleAccountStatusOutErrorEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'google_account_not_linked')
  static const GoogleAccountStatusOutErrorEnum googleAccountNotLinked = _$googleAccountStatusOutErrorEnum_googleAccountNotLinked;
  @BuiltValueEnumConst(wireName: r'drive_appdata_scope_missing')
  static const GoogleAccountStatusOutErrorEnum driveAppdataScopeMissing = _$googleAccountStatusOutErrorEnum_driveAppdataScopeMissing;
  @BuiltValueEnumConst(wireName: r'google_authorization_revoked')
  static const GoogleAccountStatusOutErrorEnum googleAuthorizationRevoked = _$googleAccountStatusOutErrorEnum_googleAuthorizationRevoked;
  @BuiltValueEnumConst(wireName: r'google_authorization_unverified')
  static const GoogleAccountStatusOutErrorEnum googleAuthorizationUnverified = _$googleAccountStatusOutErrorEnum_googleAuthorizationUnverified;

  static Serializer<GoogleAccountStatusOutErrorEnum> get serializer => _$googleAccountStatusOutErrorEnumSerializer;

  const GoogleAccountStatusOutErrorEnum._(String name): super(name);

  static BuiltSet<GoogleAccountStatusOutErrorEnum> get values => _$googleAccountStatusOutErrorEnumValues;
  static GoogleAccountStatusOutErrorEnum valueOf(String name) => _$googleAccountStatusOutErrorEnumValueOf(name);
}


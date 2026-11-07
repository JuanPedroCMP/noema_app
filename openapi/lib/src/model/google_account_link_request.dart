//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'google_account_link_request.g.dart';

/// GoogleAccountLinkRequest
///
/// Properties:
/// * [googleIdToken] 
/// * [googleAccessToken] 
@BuiltValue()
abstract class GoogleAccountLinkRequest implements Built<GoogleAccountLinkRequest, GoogleAccountLinkRequestBuilder> {
  @BuiltValueField(wireName: r'google_id_token')
  String get googleIdToken;

  @BuiltValueField(wireName: r'google_access_token')
  String get googleAccessToken;

  GoogleAccountLinkRequest._();

  factory GoogleAccountLinkRequest([void updates(GoogleAccountLinkRequestBuilder b)]) = _$GoogleAccountLinkRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GoogleAccountLinkRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GoogleAccountLinkRequest> get serializer => _$GoogleAccountLinkRequestSerializer();
}

class _$GoogleAccountLinkRequestSerializer implements PrimitiveSerializer<GoogleAccountLinkRequest> {
  @override
  final Iterable<Type> types = const [GoogleAccountLinkRequest, _$GoogleAccountLinkRequest];

  @override
  final String wireName = r'GoogleAccountLinkRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GoogleAccountLinkRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'google_id_token';
    yield serializers.serialize(
      object.googleIdToken,
      specifiedType: const FullType(String),
    );
    yield r'google_access_token';
    yield serializers.serialize(
      object.googleAccessToken,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    GoogleAccountLinkRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GoogleAccountLinkRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'google_id_token':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.googleIdToken = valueDes;
          break;
        case r'google_access_token':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.googleAccessToken = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GoogleAccountLinkRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GoogleAccountLinkRequestBuilder();
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



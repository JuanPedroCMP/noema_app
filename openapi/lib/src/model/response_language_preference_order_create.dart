//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'response_language_preference_order_create.g.dart';

/// ResponseLanguagePreferenceOrderCreate
///
/// Properties:
/// * [preferenceOrder] 
/// * [idUser] 
/// * [idLanguage] 
@BuiltValue()
abstract class ResponseLanguagePreferenceOrderCreate implements Built<ResponseLanguagePreferenceOrderCreate, ResponseLanguagePreferenceOrderCreateBuilder> {
  @BuiltValueField(wireName: r'preference_order')
  int get preferenceOrder;

  @BuiltValueField(wireName: r'id_user')
  String get idUser;

  @BuiltValueField(wireName: r'id_language')
  String get idLanguage;

  ResponseLanguagePreferenceOrderCreate._();

  factory ResponseLanguagePreferenceOrderCreate([void updates(ResponseLanguagePreferenceOrderCreateBuilder b)]) = _$ResponseLanguagePreferenceOrderCreate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ResponseLanguagePreferenceOrderCreateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ResponseLanguagePreferenceOrderCreate> get serializer => _$ResponseLanguagePreferenceOrderCreateSerializer();
}

class _$ResponseLanguagePreferenceOrderCreateSerializer implements PrimitiveSerializer<ResponseLanguagePreferenceOrderCreate> {
  @override
  final Iterable<Type> types = const [ResponseLanguagePreferenceOrderCreate, _$ResponseLanguagePreferenceOrderCreate];

  @override
  final String wireName = r'ResponseLanguagePreferenceOrderCreate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ResponseLanguagePreferenceOrderCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'preference_order';
    yield serializers.serialize(
      object.preferenceOrder,
      specifiedType: const FullType(int),
    );
    yield r'id_user';
    yield serializers.serialize(
      object.idUser,
      specifiedType: const FullType(String),
    );
    yield r'id_language';
    yield serializers.serialize(
      object.idLanguage,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ResponseLanguagePreferenceOrderCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ResponseLanguagePreferenceOrderCreateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'preference_order':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.preferenceOrder = valueDes;
          break;
        case r'id_user':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.idUser = valueDes;
          break;
        case r'id_language':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.idLanguage = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ResponseLanguagePreferenceOrderCreate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ResponseLanguagePreferenceOrderCreateBuilder();
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


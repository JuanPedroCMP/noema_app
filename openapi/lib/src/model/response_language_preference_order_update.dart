//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'response_language_preference_order_update.g.dart';

/// ResponseLanguagePreferenceOrderUpdate
///
/// Properties:
/// * [id] 
/// * [preferenceOrder] 
/// * [idUser] 
/// * [idLanguage] 
@BuiltValue()
abstract class ResponseLanguagePreferenceOrderUpdate implements Built<ResponseLanguagePreferenceOrderUpdate, ResponseLanguagePreferenceOrderUpdateBuilder> {
  @BuiltValueField(wireName: r'id')
  String? get id;

  @BuiltValueField(wireName: r'preference_order')
  int? get preferenceOrder;

  @BuiltValueField(wireName: r'id_user')
  String? get idUser;

  @BuiltValueField(wireName: r'id_language')
  String? get idLanguage;

  ResponseLanguagePreferenceOrderUpdate._();

  factory ResponseLanguagePreferenceOrderUpdate([void updates(ResponseLanguagePreferenceOrderUpdateBuilder b)]) = _$ResponseLanguagePreferenceOrderUpdate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ResponseLanguagePreferenceOrderUpdateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ResponseLanguagePreferenceOrderUpdate> get serializer => _$ResponseLanguagePreferenceOrderUpdateSerializer();
}

class _$ResponseLanguagePreferenceOrderUpdateSerializer implements PrimitiveSerializer<ResponseLanguagePreferenceOrderUpdate> {
  @override
  final Iterable<Type> types = const [ResponseLanguagePreferenceOrderUpdate, _$ResponseLanguagePreferenceOrderUpdate];

  @override
  final String wireName = r'ResponseLanguagePreferenceOrderUpdate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ResponseLanguagePreferenceOrderUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.preferenceOrder != null) {
      yield r'preference_order';
      yield serializers.serialize(
        object.preferenceOrder,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.idUser != null) {
      yield r'id_user';
      yield serializers.serialize(
        object.idUser,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.idLanguage != null) {
      yield r'id_language';
      yield serializers.serialize(
        object.idLanguage,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ResponseLanguagePreferenceOrderUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ResponseLanguagePreferenceOrderUpdateBuilder result,
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
        case r'preference_order':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.preferenceOrder = valueDes;
          break;
        case r'id_user':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.idUser = valueDes;
          break;
        case r'id_language':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
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
  ResponseLanguagePreferenceOrderUpdate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ResponseLanguagePreferenceOrderUpdateBuilder();
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


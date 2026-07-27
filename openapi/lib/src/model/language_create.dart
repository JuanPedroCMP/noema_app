//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'language_create.g.dart';

/// LanguageCreate
///
/// Properties:
/// * [name] 
/// * [percentageTranslated] 
/// * [verifiedTranslation] 
/// * [automaticTranslation] 
@BuiltValue()
abstract class LanguageCreate implements Built<LanguageCreate, LanguageCreateBuilder> {
  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'percentage_translated')
  int get percentageTranslated;

  @BuiltValueField(wireName: r'verified_translation')
  bool get verifiedTranslation;

  @BuiltValueField(wireName: r'automatic_translation')
  bool get automaticTranslation;

  LanguageCreate._();

  factory LanguageCreate([void updates(LanguageCreateBuilder b)]) = _$LanguageCreate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(LanguageCreateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<LanguageCreate> get serializer => _$LanguageCreateSerializer();
}

class _$LanguageCreateSerializer implements PrimitiveSerializer<LanguageCreate> {
  @override
  final Iterable<Type> types = const [LanguageCreate, _$LanguageCreate];

  @override
  final String wireName = r'LanguageCreate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    LanguageCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'percentage_translated';
    yield serializers.serialize(
      object.percentageTranslated,
      specifiedType: const FullType(int),
    );
    yield r'verified_translation';
    yield serializers.serialize(
      object.verifiedTranslation,
      specifiedType: const FullType(bool),
    );
    yield r'automatic_translation';
    yield serializers.serialize(
      object.automaticTranslation,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    LanguageCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required LanguageCreateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'percentage_translated':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.percentageTranslated = valueDes;
          break;
        case r'verified_translation':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.verifiedTranslation = valueDes;
          break;
        case r'automatic_translation':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.automaticTranslation = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  LanguageCreate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = LanguageCreateBuilder();
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


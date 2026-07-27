//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'language_update.g.dart';

/// LanguageUpdate
///
/// Properties:
/// * [name] 
/// * [percentageTranslated] 
/// * [verifiedTranslation] 
/// * [automaticTranslation] 
@BuiltValue()
abstract class LanguageUpdate implements Built<LanguageUpdate, LanguageUpdateBuilder> {
  @BuiltValueField(wireName: r'name')
  String? get name;

  @BuiltValueField(wireName: r'percentage_translated')
  int? get percentageTranslated;

  @BuiltValueField(wireName: r'verified_translation')
  bool? get verifiedTranslation;

  @BuiltValueField(wireName: r'automatic_translation')
  bool? get automaticTranslation;

  LanguageUpdate._();

  factory LanguageUpdate([void updates(LanguageUpdateBuilder b)]) = _$LanguageUpdate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(LanguageUpdateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<LanguageUpdate> get serializer => _$LanguageUpdateSerializer();
}

class _$LanguageUpdateSerializer implements PrimitiveSerializer<LanguageUpdate> {
  @override
  final Iterable<Type> types = const [LanguageUpdate, _$LanguageUpdate];

  @override
  final String wireName = r'LanguageUpdate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    LanguageUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.name != null) {
      yield r'name';
      yield serializers.serialize(
        object.name,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.percentageTranslated != null) {
      yield r'percentage_translated';
      yield serializers.serialize(
        object.percentageTranslated,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.verifiedTranslation != null) {
      yield r'verified_translation';
      yield serializers.serialize(
        object.verifiedTranslation,
        specifiedType: const FullType.nullable(bool),
      );
    }
    if (object.automaticTranslation != null) {
      yield r'automatic_translation';
      yield serializers.serialize(
        object.automaticTranslation,
        specifiedType: const FullType.nullable(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    LanguageUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required LanguageUpdateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.name = valueDes;
          break;
        case r'percentage_translated':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.percentageTranslated = valueDes;
          break;
        case r'verified_translation':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.verifiedTranslation = valueDes;
          break;
        case r'automatic_translation':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
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
  LanguageUpdate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = LanguageUpdateBuilder();
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


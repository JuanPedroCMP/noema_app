//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'language_out.g.dart';

/// LanguageOut
///
/// Properties:
/// * [id] 
/// * [name] 
/// * [percentageTranslated] 
/// * [verifiedTranslation] 
/// * [automaticTranslation] 
/// * [createdAt] 
/// * [updatedAt] 
@BuiltValue()
abstract class LanguageOut implements Built<LanguageOut, LanguageOutBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'percentage_translated')
  int get percentageTranslated;

  @BuiltValueField(wireName: r'verified_translation')
  bool get verifiedTranslation;

  @BuiltValueField(wireName: r'automatic_translation')
  bool get automaticTranslation;

  @BuiltValueField(wireName: r'created_at')
  DateTime? get createdAt;

  @BuiltValueField(wireName: r'updated_at')
  DateTime? get updatedAt;

  LanguageOut._();

  factory LanguageOut([void updates(LanguageOutBuilder b)]) = _$LanguageOut;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(LanguageOutBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<LanguageOut> get serializer => _$LanguageOutSerializer();
}

class _$LanguageOutSerializer implements PrimitiveSerializer<LanguageOut> {
  @override
  final Iterable<Type> types = const [LanguageOut, _$LanguageOut];

  @override
  final String wireName = r'LanguageOut';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    LanguageOut object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
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
    yield r'created_at';
    yield object.createdAt == null ? null : serializers.serialize(
      object.createdAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'updated_at';
    yield object.updatedAt == null ? null : serializers.serialize(
      object.updatedAt,
      specifiedType: const FullType.nullable(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    LanguageOut object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required LanguageOutBuilder result,
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
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.createdAt = valueDes;
          break;
        case r'updated_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.updatedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  LanguageOut deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = LanguageOutBuilder();
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


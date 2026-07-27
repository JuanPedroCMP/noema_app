//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'ai_model_create.g.dart';

/// AiModelCreate
///
/// Properties:
/// * [slug] 
/// * [idAiProvider] 
/// * [displayName] 
/// * [contextWindow] 
/// * [inputTokenLimit] 
/// * [outputTokenLimit] 
/// * [supportsVision] 
/// * [isActive] 
@BuiltValue()
abstract class AiModelCreate implements Built<AiModelCreate, AiModelCreateBuilder> {
  @BuiltValueField(wireName: r'slug')
  String get slug;

  @BuiltValueField(wireName: r'id_ai_provider')
  String get idAiProvider;

  @BuiltValueField(wireName: r'display_name')
  String get displayName;

  @BuiltValueField(wireName: r'context_window')
  int get contextWindow;

  @BuiltValueField(wireName: r'input_token_limit')
  int get inputTokenLimit;

  @BuiltValueField(wireName: r'output_token_limit')
  int get outputTokenLimit;

  @BuiltValueField(wireName: r'supports_vision')
  bool? get supportsVision;

  @BuiltValueField(wireName: r'is_active')
  bool? get isActive;

  AiModelCreate._();

  factory AiModelCreate([void updates(AiModelCreateBuilder b)]) = _$AiModelCreate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AiModelCreateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AiModelCreate> get serializer => _$AiModelCreateSerializer();
}

class _$AiModelCreateSerializer implements PrimitiveSerializer<AiModelCreate> {
  @override
  final Iterable<Type> types = const [AiModelCreate, _$AiModelCreate];

  @override
  final String wireName = r'AiModelCreate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AiModelCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'slug';
    yield serializers.serialize(
      object.slug,
      specifiedType: const FullType(String),
    );
    yield r'id_ai_provider';
    yield serializers.serialize(
      object.idAiProvider,
      specifiedType: const FullType(String),
    );
    yield r'display_name';
    yield serializers.serialize(
      object.displayName,
      specifiedType: const FullType(String),
    );
    yield r'context_window';
    yield serializers.serialize(
      object.contextWindow,
      specifiedType: const FullType(int),
    );
    yield r'input_token_limit';
    yield serializers.serialize(
      object.inputTokenLimit,
      specifiedType: const FullType(int),
    );
    yield r'output_token_limit';
    yield serializers.serialize(
      object.outputTokenLimit,
      specifiedType: const FullType(int),
    );
    yield r'supports_vision';
    yield object.supportsVision == null ? null : serializers.serialize(
      object.supportsVision,
      specifiedType: const FullType.nullable(bool),
    );
    yield r'is_active';
    yield object.isActive == null ? null : serializers.serialize(
      object.isActive,
      specifiedType: const FullType.nullable(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AiModelCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AiModelCreateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'slug':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.slug = valueDes;
          break;
        case r'id_ai_provider':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.idAiProvider = valueDes;
          break;
        case r'display_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.displayName = valueDes;
          break;
        case r'context_window':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.contextWindow = valueDes;
          break;
        case r'input_token_limit':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.inputTokenLimit = valueDes;
          break;
        case r'output_token_limit':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.outputTokenLimit = valueDes;
          break;
        case r'supports_vision':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.supportsVision = valueDes;
          break;
        case r'is_active':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.isActive = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AiModelCreate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AiModelCreateBuilder();
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


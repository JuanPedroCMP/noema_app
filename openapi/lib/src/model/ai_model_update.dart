//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'ai_model_update.g.dart';

/// AiModelUpdate
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
abstract class AiModelUpdate implements Built<AiModelUpdate, AiModelUpdateBuilder> {
  @BuiltValueField(wireName: r'slug')
  String? get slug;

  @BuiltValueField(wireName: r'id_ai_provider')
  String? get idAiProvider;

  @BuiltValueField(wireName: r'display_name')
  String? get displayName;

  @BuiltValueField(wireName: r'context_window')
  int? get contextWindow;

  @BuiltValueField(wireName: r'input_token_limit')
  int? get inputTokenLimit;

  @BuiltValueField(wireName: r'output_token_limit')
  int? get outputTokenLimit;

  @BuiltValueField(wireName: r'supports_vision')
  bool? get supportsVision;

  @BuiltValueField(wireName: r'is_active')
  bool? get isActive;

  AiModelUpdate._();

  factory AiModelUpdate([void updates(AiModelUpdateBuilder b)]) = _$AiModelUpdate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AiModelUpdateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AiModelUpdate> get serializer => _$AiModelUpdateSerializer();
}

class _$AiModelUpdateSerializer implements PrimitiveSerializer<AiModelUpdate> {
  @override
  final Iterable<Type> types = const [AiModelUpdate, _$AiModelUpdate];

  @override
  final String wireName = r'AiModelUpdate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AiModelUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.slug != null) {
      yield r'slug';
      yield serializers.serialize(
        object.slug,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.idAiProvider != null) {
      yield r'id_ai_provider';
      yield serializers.serialize(
        object.idAiProvider,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.displayName != null) {
      yield r'display_name';
      yield serializers.serialize(
        object.displayName,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.contextWindow != null) {
      yield r'context_window';
      yield serializers.serialize(
        object.contextWindow,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.inputTokenLimit != null) {
      yield r'input_token_limit';
      yield serializers.serialize(
        object.inputTokenLimit,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.outputTokenLimit != null) {
      yield r'output_token_limit';
      yield serializers.serialize(
        object.outputTokenLimit,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.supportsVision != null) {
      yield r'supports_vision';
      yield serializers.serialize(
        object.supportsVision,
        specifiedType: const FullType.nullable(bool),
      );
    }
    if (object.isActive != null) {
      yield r'is_active';
      yield serializers.serialize(
        object.isActive,
        specifiedType: const FullType.nullable(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    AiModelUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AiModelUpdateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'slug':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.slug = valueDes;
          break;
        case r'id_ai_provider':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.idAiProvider = valueDes;
          break;
        case r'display_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.displayName = valueDes;
          break;
        case r'context_window':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.contextWindow = valueDes;
          break;
        case r'input_token_limit':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.inputTokenLimit = valueDes;
          break;
        case r'output_token_limit':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
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
  AiModelUpdate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AiModelUpdateBuilder();
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


//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'provider_update.g.dart';

/// ProviderUpdate
///
/// Properties:
/// * [slug] 
/// * [displayName] 
/// * [baseUrl] 
/// * [isActive] 
@BuiltValue()
abstract class ProviderUpdate implements Built<ProviderUpdate, ProviderUpdateBuilder> {
  @BuiltValueField(wireName: r'slug')
  String? get slug;

  @BuiltValueField(wireName: r'display_name')
  String? get displayName;

  @BuiltValueField(wireName: r'base_url')
  String? get baseUrl;

  @BuiltValueField(wireName: r'is_active')
  bool? get isActive;

  ProviderUpdate._();

  factory ProviderUpdate([void updates(ProviderUpdateBuilder b)]) = _$ProviderUpdate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProviderUpdateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProviderUpdate> get serializer => _$ProviderUpdateSerializer();
}

class _$ProviderUpdateSerializer implements PrimitiveSerializer<ProviderUpdate> {
  @override
  final Iterable<Type> types = const [ProviderUpdate, _$ProviderUpdate];

  @override
  final String wireName = r'ProviderUpdate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProviderUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.slug != null) {
      yield r'slug';
      yield serializers.serialize(
        object.slug,
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
    if (object.baseUrl != null) {
      yield r'base_url';
      yield serializers.serialize(
        object.baseUrl,
        specifiedType: const FullType.nullable(String),
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
    ProviderUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProviderUpdateBuilder result,
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
        case r'display_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.displayName = valueDes;
          break;
        case r'base_url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.baseUrl = valueDes;
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
  ProviderUpdate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProviderUpdateBuilder();
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


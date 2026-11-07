//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'snapshot_manifest.g.dart';

/// SnapshotManifest
///
/// Properties:
/// * [format] 
/// * [schemaVersion] 
/// * [snapshotVersion] 
/// * [createdAt] 
/// * [installationId] 
/// * [includedCategories] 
/// * [excludedCategories] 
/// * [counts] 
/// * [hashes] 
@BuiltValue()
abstract class SnapshotManifest implements Built<SnapshotManifest, SnapshotManifestBuilder> {
  @BuiltValueField(wireName: r'format')
  String get format;

  @BuiltValueField(wireName: r'schema_version')
  int get schemaVersion;

  @BuiltValueField(wireName: r'snapshot_version')
  String get snapshotVersion;

  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'installation_id')
  String get installationId;

  @BuiltValueField(wireName: r'included_categories')
  BuiltList<String> get includedCategories;

  @BuiltValueField(wireName: r'excluded_categories')
  BuiltList<String> get excludedCategories;

  @BuiltValueField(wireName: r'counts')
  BuiltMap<String, int> get counts;

  @BuiltValueField(wireName: r'hashes')
  BuiltMap<String, String> get hashes;

  SnapshotManifest._();

  factory SnapshotManifest([void updates(SnapshotManifestBuilder b)]) = _$SnapshotManifest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SnapshotManifestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SnapshotManifest> get serializer => _$SnapshotManifestSerializer();
}

class _$SnapshotManifestSerializer implements PrimitiveSerializer<SnapshotManifest> {
  @override
  final Iterable<Type> types = const [SnapshotManifest, _$SnapshotManifest];

  @override
  final String wireName = r'SnapshotManifest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SnapshotManifest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'format';
    yield serializers.serialize(
      object.format,
      specifiedType: const FullType(String),
    );
    yield r'schema_version';
    yield serializers.serialize(
      object.schemaVersion,
      specifiedType: const FullType(int),
    );
    yield r'snapshot_version';
    yield serializers.serialize(
      object.snapshotVersion,
      specifiedType: const FullType(String),
    );
    yield r'created_at';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'installation_id';
    yield serializers.serialize(
      object.installationId,
      specifiedType: const FullType(String),
    );
    yield r'included_categories';
    yield serializers.serialize(
      object.includedCategories,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'excluded_categories';
    yield serializers.serialize(
      object.excludedCategories,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'counts';
    yield serializers.serialize(
      object.counts,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType(int)]),
    );
    yield r'hashes';
    yield serializers.serialize(
      object.hashes,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SnapshotManifest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SnapshotManifestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'format':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.format = valueDes;
          break;
        case r'schema_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.schemaVersion = valueDes;
          break;
        case r'snapshot_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.snapshotVersion = valueDes;
          break;
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'installation_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.installationId = valueDes;
          break;
        case r'included_categories':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.includedCategories.replace(valueDes);
          break;
        case r'excluded_categories':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.excludedCategories.replace(valueDes);
          break;
        case r'counts':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType(int)]),
          ) as BuiltMap<String, int>;
          result.counts.replace(valueDes);
          break;
        case r'hashes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType(String)]),
          ) as BuiltMap<String, String>;
          result.hashes.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SnapshotManifest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SnapshotManifestBuilder();
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



//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'sync_result.g.dart';

class SyncResult extends EnumClass {

  @BuiltValueEnumConst(wireName: r'success')
  static const SyncResult success = _$success;
  @BuiltValueEnumConst(wireName: r'failure')
  static const SyncResult failure = _$failure;
  @BuiltValueEnumConst(wireName: r'in_conflict')
  static const SyncResult inConflict = _$inConflict;

  static Serializer<SyncResult> get serializer => _$syncResultSerializer;

  const SyncResult._(String name): super(name);

  static BuiltSet<SyncResult> get values => _$values;
  static SyncResult valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class SyncResultMixin = Object with _$SyncResultMixin;


//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'backup_operation_state.g.dart';

class BackupOperationState extends EnumClass {

  @BuiltValueEnumConst(wireName: r'pending')
  static const BackupOperationState pending = _$pending;
  @BuiltValueEnumConst(wireName: r'completed')
  static const BackupOperationState completed = _$completed;
  @BuiltValueEnumConst(wireName: r'failed')
  static const BackupOperationState failed = _$failed;

  static Serializer<BackupOperationState> get serializer => _$backupOperationStateSerializer;

  const BackupOperationState._(String name): super(name);

  static BuiltSet<BackupOperationState> get values => _$values;
  static BackupOperationState valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class BackupOperationStateMixin = Object with _$BackupOperationStateMixin;


//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

enum ConflictStrategy {
  @JsonValue(r'keep_local')
  keepLocal(r'keep_local'),
  @JsonValue(r'keep_remote')
  keepRemote(r'keep_remote'),
  @JsonValue(r'merge')
  merge(r'merge'),
  @JsonValue(r'duplicate')
  duplicate(r'duplicate');

  const ConflictStrategy(this.value);

  final String value;

  @override
  String toString() => value;
}

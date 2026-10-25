//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

enum SyncResult {
  @JsonValue(r'success')
  success(r'success'),
  @JsonValue(r'failure')
  failure(r'failure'),
  @JsonValue(r'in_conflict')
  inConflict(r'in_conflict');

  const SyncResult(this.value);

  final String value;

  @override
  String toString() => value;
}

//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

enum AgentModelQuality {
  @JsonValue(r'unusable')
  unusable(r'unusable'),
  @JsonValue(r'poor')
  poor(r'poor'),
  @JsonValue(r'fair')
  fair(r'fair'),
  @JsonValue(r'good')
  good(r'good'),
  @JsonValue(r'very_good')
  veryGood(r'very_good'),
  @JsonValue(r'excellent')
  excellent(r'excellent');

  const AgentModelQuality(this.value);

  final String value;

  @override
  String toString() => value;
}

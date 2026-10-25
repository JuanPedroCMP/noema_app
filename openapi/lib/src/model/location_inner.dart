// AUTO-GENERATED FILE, DO NOT MODIFY!

// ignore_for_file: unused_element

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'location_inner.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class LocationInner {
  const LocationInner();

  factory LocationInner.fromJson(Map<String, dynamic> json) =>
      _$LocationInnerFromJson(json);

  Map<String, dynamic> toJson() => _$LocationInnerToJson(this);

  @override
  bool operator ==(Object other) => other is LocationInner;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() => toJson().toString();
}
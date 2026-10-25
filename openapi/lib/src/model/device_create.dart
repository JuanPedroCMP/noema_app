//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'device_create.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DeviceCreate {
  /// Returns a new [DeviceCreate] instance.
  DeviceCreate({

    required  this.idUser,

    required  this.deviceName,

    required  this.deviceFingerprint,

    required  this.platform,
  });

  @JsonKey(
    
    name: r'id_user',
    required: true,
    includeIfNull: false,
  )


  final String idUser;



  @JsonKey(
    
    name: r'device_name',
    required: true,
    includeIfNull: false,
  )


  final String deviceName;



  @JsonKey(
    
    name: r'device_fingerprint',
    required: true,
    includeIfNull: false,
  )


  final String deviceFingerprint;



  @JsonKey(
    
    name: r'platform',
    required: true,
    includeIfNull: false,
  )


  final String platform;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DeviceCreate &&
      other.idUser == idUser &&
      other.deviceName == deviceName &&
      other.deviceFingerprint == deviceFingerprint &&
      other.platform == platform;

    @override
    int get hashCode =>
        idUser.hashCode +
        deviceName.hashCode +
        deviceFingerprint.hashCode +
        platform.hashCode;

  factory DeviceCreate.fromJson(Map<String, dynamic> json) => _$DeviceCreateFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceCreateToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


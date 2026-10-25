//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'device_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DeviceOut {
  /// Returns a new [DeviceOut] instance.
  DeviceOut({

    required  this.id,

    required  this.idUser,

    required  this.deviceName,

    required  this.deviceFingerprint,

    required  this.platform,

    required  this.lastSeenAt,

    required  this.createdAt,

    required  this.updatedAt,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



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



  @JsonKey(
    
    name: r'last_seen_at',
    required: true,
    includeIfNull: true,
  )


  final DateTime? lastSeenAt;



  @JsonKey(
    
    name: r'created_at',
    required: true,
    includeIfNull: true,
  )


  final DateTime? createdAt;



  @JsonKey(
    
    name: r'updated_at',
    required: true,
    includeIfNull: true,
  )


  final DateTime? updatedAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DeviceOut &&
      other.id == id &&
      other.idUser == idUser &&
      other.deviceName == deviceName &&
      other.deviceFingerprint == deviceFingerprint &&
      other.platform == platform &&
      other.lastSeenAt == lastSeenAt &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt;

    @override
    int get hashCode =>
        id.hashCode +
        idUser.hashCode +
        deviceName.hashCode +
        deviceFingerprint.hashCode +
        platform.hashCode +
        (lastSeenAt == null ? 0 : lastSeenAt.hashCode) +
        (createdAt == null ? 0 : createdAt.hashCode) +
        (updatedAt == null ? 0 : updatedAt.hashCode);

  factory DeviceOut.fromJson(Map<String, dynamic> json) => _$DeviceOutFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


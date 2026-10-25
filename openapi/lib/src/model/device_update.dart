//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'device_update.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DeviceUpdate {
  /// Returns a new [DeviceUpdate] instance.
  DeviceUpdate({

     this.idUser,

     this.deviceName,

     this.deviceFingerprint,

     this.platform,

     this.lastSeenAt,
  });

  @JsonKey(
    
    name: r'id_user',
    required: false,
    includeIfNull: false,
  )


  final String? idUser;



  @JsonKey(
    
    name: r'device_name',
    required: false,
    includeIfNull: false,
  )


  final String? deviceName;



  @JsonKey(
    
    name: r'device_fingerprint',
    required: false,
    includeIfNull: false,
  )


  final String? deviceFingerprint;



  @JsonKey(
    
    name: r'platform',
    required: false,
    includeIfNull: false,
  )


  final String? platform;



  @JsonKey(
    
    name: r'last_seen_at',
    required: false,
    includeIfNull: false,
  )


  final DateTime? lastSeenAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DeviceUpdate &&
      other.idUser == idUser &&
      other.deviceName == deviceName &&
      other.deviceFingerprint == deviceFingerprint &&
      other.platform == platform &&
      other.lastSeenAt == lastSeenAt;

    @override
    int get hashCode =>
        (idUser == null ? 0 : idUser.hashCode) +
        (deviceName == null ? 0 : deviceName.hashCode) +
        (deviceFingerprint == null ? 0 : deviceFingerprint.hashCode) +
        (platform == null ? 0 : platform.hashCode) +
        (lastSeenAt == null ? 0 : lastSeenAt.hashCode);

  factory DeviceUpdate.fromJson(Map<String, dynamic> json) => _$DeviceUpdateFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceUpdateToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


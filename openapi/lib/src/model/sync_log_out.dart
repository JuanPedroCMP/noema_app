//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/sync_result.dart';
import 'package:openapi/src/model/sync_direction.dart';
import 'package:openapi/src/model/conflict_strategy.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sync_log_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class SyncLogOut {
  /// Returns a new [SyncLogOut] instance.
  SyncLogOut({

    required  this.id,

    required  this.idDevice,

    required  this.idBackupFile,

    required  this.event,

    required  this.derection,

    required  this.result,

    required  this.conflictStrategy,

    required  this.errorDetails,

    required  this.metadata,

    required  this.createdAt,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'id_device',
    required: true,
    includeIfNull: false,
  )


  final String idDevice;



  @JsonKey(
    
    name: r'id_backup_file',
    required: true,
    includeIfNull: false,
  )


  final String idBackupFile;



  @JsonKey(
    
    name: r'event',
    required: true,
    includeIfNull: false,
  )


  final String event;



  @JsonKey(
    
    name: r'derection',
    required: true,
    includeIfNull: false,
  )


  final SyncDirection derection;



  @JsonKey(
    
    name: r'result',
    required: true,
    includeIfNull: false,
  )


  final SyncResult result;



  @JsonKey(
    
    name: r'conflict_strategy',
    required: true,
    includeIfNull: false,
  )


  final ConflictStrategy conflictStrategy;



  @JsonKey(
    
    name: r'error_details',
    required: true,
    includeIfNull: false,
  )


  final String errorDetails;



  @JsonKey(
    
    name: r'metadata',
    required: true,
    includeIfNull: false,
  )


  final Map<String, Object> metadata;



  @JsonKey(
    
    name: r'created_at',
    required: true,
    includeIfNull: true,
  )


  final DateTime? createdAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is SyncLogOut &&
      other.id == id &&
      other.idDevice == idDevice &&
      other.idBackupFile == idBackupFile &&
      other.event == event &&
      other.derection == derection &&
      other.result == result &&
      other.conflictStrategy == conflictStrategy &&
      other.errorDetails == errorDetails &&
      other.metadata == metadata &&
      other.createdAt == createdAt;

    @override
    int get hashCode =>
        id.hashCode +
        idDevice.hashCode +
        idBackupFile.hashCode +
        event.hashCode +
        derection.hashCode +
        result.hashCode +
        conflictStrategy.hashCode +
        errorDetails.hashCode +
        metadata.hashCode +
        (createdAt == null ? 0 : createdAt.hashCode);

  factory SyncLogOut.fromJson(Map<String, dynamic> json) => _$SyncLogOutFromJson(json);

  Map<String, dynamic> toJson() => _$SyncLogOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


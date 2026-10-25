//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'backup_file_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class BackupFileOut {
  /// Returns a new [BackupFileOut] instance.
  BackupFileOut({

    required  this.id,

    required  this.idGoogleAccount,

    required  this.driveFileId,

    required  this.localRef,

    required  this.driveVersion,

    required  this.contentHash,

    required  this.createdAt,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'id_google_account',
    required: true,
    includeIfNull: false,
  )


  final String idGoogleAccount;



  @JsonKey(
    
    name: r'drive_file_id',
    required: true,
    includeIfNull: false,
  )


  final String driveFileId;



  @JsonKey(
    
    name: r'local_ref',
    required: true,
    includeIfNull: false,
  )


  final String localRef;



  @JsonKey(
    
    name: r'drive_version',
    required: true,
    includeIfNull: false,
  )


  final String driveVersion;



  @JsonKey(
    
    name: r'content_hash',
    required: true,
    includeIfNull: false,
  )


  final String contentHash;



  @JsonKey(
    
    name: r'created_at',
    required: true,
    includeIfNull: true,
  )


  final DateTime? createdAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is BackupFileOut &&
      other.id == id &&
      other.idGoogleAccount == idGoogleAccount &&
      other.driveFileId == driveFileId &&
      other.localRef == localRef &&
      other.driveVersion == driveVersion &&
      other.contentHash == contentHash &&
      other.createdAt == createdAt;

    @override
    int get hashCode =>
        id.hashCode +
        idGoogleAccount.hashCode +
        driveFileId.hashCode +
        localRef.hashCode +
        driveVersion.hashCode +
        contentHash.hashCode +
        (createdAt == null ? 0 : createdAt.hashCode);

  factory BackupFileOut.fromJson(Map<String, dynamic> json) => _$BackupFileOutFromJson(json);

  Map<String, dynamic> toJson() => _$BackupFileOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


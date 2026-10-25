//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'backup_file_create.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class BackupFileCreate {
  /// Returns a new [BackupFileCreate] instance.
  BackupFileCreate({

    required  this.idGoogleAccount,

    required  this.driveFileId,

    required  this.localRef,

    required  this.driveVersion,

    required  this.contentHash,
  });

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





    @override
    bool operator ==(Object other) => identical(this, other) || other is BackupFileCreate &&
      other.idGoogleAccount == idGoogleAccount &&
      other.driveFileId == driveFileId &&
      other.localRef == localRef &&
      other.driveVersion == driveVersion &&
      other.contentHash == contentHash;

    @override
    int get hashCode =>
        idGoogleAccount.hashCode +
        driveFileId.hashCode +
        localRef.hashCode +
        driveVersion.hashCode +
        contentHash.hashCode;

  factory BackupFileCreate.fromJson(Map<String, dynamic> json) => _$BackupFileCreateFromJson(json);

  Map<String, dynamic> toJson() => _$BackupFileCreateToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


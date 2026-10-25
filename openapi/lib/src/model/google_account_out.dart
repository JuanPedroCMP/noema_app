//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'google_account_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class GoogleAccountOut {
  /// Returns a new [GoogleAccountOut] instance.
  GoogleAccountOut({

    required  this.id,

    required  this.idUser,

    required  this.googleUserId,

    required  this.emailGoogle,

    required  this.grantedScopes,

    required  this.isActive,

    required  this.expiresAt,

    required  this.lastRefreshAt,

    required  this.updatedAt,

    required  this.createdAt,
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
    
    name: r'google_user_id',
    required: true,
    includeIfNull: true,
  )


  final String? googleUserId;



  @JsonKey(
    
    name: r'email_google',
    required: true,
    includeIfNull: false,
  )


  final String emailGoogle;



  @JsonKey(
    
    name: r'granted_scopes',
    required: true,
    includeIfNull: true,
  )


  final String? grantedScopes;



  @JsonKey(
    
    name: r'is_active',
    required: true,
    includeIfNull: false,
  )


  final bool isActive;



  @JsonKey(
    
    name: r'expires_at',
    required: true,
    includeIfNull: true,
  )


  final DateTime? expiresAt;



  @JsonKey(
    
    name: r'last_refresh_at',
    required: true,
    includeIfNull: true,
  )


  final DateTime? lastRefreshAt;



  @JsonKey(
    
    name: r'updated_at',
    required: true,
    includeIfNull: true,
  )


  final DateTime? updatedAt;



  @JsonKey(
    
    name: r'created_at',
    required: true,
    includeIfNull: true,
  )


  final DateTime? createdAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is GoogleAccountOut &&
      other.id == id &&
      other.idUser == idUser &&
      other.googleUserId == googleUserId &&
      other.emailGoogle == emailGoogle &&
      other.grantedScopes == grantedScopes &&
      other.isActive == isActive &&
      other.expiresAt == expiresAt &&
      other.lastRefreshAt == lastRefreshAt &&
      other.updatedAt == updatedAt &&
      other.createdAt == createdAt;

    @override
    int get hashCode =>
        id.hashCode +
        idUser.hashCode +
        (googleUserId == null ? 0 : googleUserId.hashCode) +
        emailGoogle.hashCode +
        (grantedScopes == null ? 0 : grantedScopes.hashCode) +
        isActive.hashCode +
        (expiresAt == null ? 0 : expiresAt.hashCode) +
        (lastRefreshAt == null ? 0 : lastRefreshAt.hashCode) +
        (updatedAt == null ? 0 : updatedAt.hashCode) +
        (createdAt == null ? 0 : createdAt.hashCode);

  factory GoogleAccountOut.fromJson(Map<String, dynamic> json) => _$GoogleAccountOutFromJson(json);

  Map<String, dynamic> toJson() => _$GoogleAccountOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


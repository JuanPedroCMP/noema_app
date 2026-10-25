//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'google_account_update.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class GoogleAccountUpdate {
  /// Returns a new [GoogleAccountUpdate] instance.
  GoogleAccountUpdate({

    required  this.idUser,

    required  this.googleUserId,

    required  this.emailGoogle,

    required  this.accessTokenEnc,

    required  this.refreshTokenEnc,

    required  this.grantedScopes,

    required  this.isActive,

    required  this.expiresAt,

    required  this.lastRefreshAt,
  });

  @JsonKey(
    
    name: r'id_user',
    required: true,
    includeIfNull: true,
  )


  final String? idUser;



  @JsonKey(
    
    name: r'google_user_id',
    required: true,
    includeIfNull: true,
  )


  final String? googleUserId;



  @JsonKey(
    
    name: r'email_google',
    required: true,
    includeIfNull: true,
  )


  final String? emailGoogle;



  @JsonKey(
    
    name: r'access_token_enc',
    required: true,
    includeIfNull: true,
  )


  final String? accessTokenEnc;



  @JsonKey(
    
    name: r'refresh_token_enc',
    required: true,
    includeIfNull: true,
  )


  final String? refreshTokenEnc;



  @JsonKey(
    
    name: r'granted_scopes',
    required: true,
    includeIfNull: true,
  )


  final String? grantedScopes;



  @JsonKey(
    
    name: r'is_active',
    required: true,
    includeIfNull: true,
  )


  final bool? isActive;



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





    @override
    bool operator ==(Object other) => identical(this, other) || other is GoogleAccountUpdate &&
      other.idUser == idUser &&
      other.googleUserId == googleUserId &&
      other.emailGoogle == emailGoogle &&
      other.accessTokenEnc == accessTokenEnc &&
      other.refreshTokenEnc == refreshTokenEnc &&
      other.grantedScopes == grantedScopes &&
      other.isActive == isActive &&
      other.expiresAt == expiresAt &&
      other.lastRefreshAt == lastRefreshAt;

    @override
    int get hashCode =>
        (idUser == null ? 0 : idUser.hashCode) +
        (googleUserId == null ? 0 : googleUserId.hashCode) +
        (emailGoogle == null ? 0 : emailGoogle.hashCode) +
        (accessTokenEnc == null ? 0 : accessTokenEnc.hashCode) +
        (refreshTokenEnc == null ? 0 : refreshTokenEnc.hashCode) +
        (grantedScopes == null ? 0 : grantedScopes.hashCode) +
        (isActive == null ? 0 : isActive.hashCode) +
        (expiresAt == null ? 0 : expiresAt.hashCode) +
        (lastRefreshAt == null ? 0 : lastRefreshAt.hashCode);

  factory GoogleAccountUpdate.fromJson(Map<String, dynamic> json) => _$GoogleAccountUpdateFromJson(json);

  Map<String, dynamic> toJson() => _$GoogleAccountUpdateToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


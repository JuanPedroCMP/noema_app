//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'google_account_create.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class GoogleAccountCreate {
  /// Returns a new [GoogleAccountCreate] instance.
  GoogleAccountCreate({

    required  this.idUser,

    required  this.googleUserId,

    required  this.emailGoogle,

    required  this.accessTokenEnc,

    required  this.refreshTokenEnc,

    required  this.grantedScopes,

    required  this.isActive,

    required  this.expiresAt,
  });

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
    includeIfNull: false,
  )


  final bool isActive;



  @JsonKey(
    
    name: r'expires_at',
    required: true,
    includeIfNull: true,
  )


  final DateTime? expiresAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is GoogleAccountCreate &&
      other.idUser == idUser &&
      other.googleUserId == googleUserId &&
      other.emailGoogle == emailGoogle &&
      other.accessTokenEnc == accessTokenEnc &&
      other.refreshTokenEnc == refreshTokenEnc &&
      other.grantedScopes == grantedScopes &&
      other.isActive == isActive &&
      other.expiresAt == expiresAt;

    @override
    int get hashCode =>
        idUser.hashCode +
        (googleUserId == null ? 0 : googleUserId.hashCode) +
        emailGoogle.hashCode +
        (accessTokenEnc == null ? 0 : accessTokenEnc.hashCode) +
        (refreshTokenEnc == null ? 0 : refreshTokenEnc.hashCode) +
        (grantedScopes == null ? 0 : grantedScopes.hashCode) +
        isActive.hashCode +
        (expiresAt == null ? 0 : expiresAt.hashCode);

  factory GoogleAccountCreate.fromJson(Map<String, dynamic> json) => _$GoogleAccountCreateFromJson(json);

  Map<String, dynamic> toJson() => _$GoogleAccountCreateToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


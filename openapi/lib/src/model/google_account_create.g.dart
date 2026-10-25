// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'google_account_create.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$GoogleAccountCreateCWProxy {
  GoogleAccountCreate idUser(String idUser);

  GoogleAccountCreate googleUserId(String? googleUserId);

  GoogleAccountCreate emailGoogle(String emailGoogle);

  GoogleAccountCreate accessTokenEnc(String? accessTokenEnc);

  GoogleAccountCreate refreshTokenEnc(String? refreshTokenEnc);

  GoogleAccountCreate grantedScopes(String? grantedScopes);

  GoogleAccountCreate isActive(bool isActive);

  GoogleAccountCreate expiresAt(DateTime? expiresAt);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `GoogleAccountCreate(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// GoogleAccountCreate(...).copyWith(id: 12, name: "My name")
  /// ```
  GoogleAccountCreate call({
    String idUser,
    String? googleUserId,
    String emailGoogle,
    String? accessTokenEnc,
    String? refreshTokenEnc,
    String? grantedScopes,
    bool isActive,
    DateTime? expiresAt,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfGoogleAccountCreate.copyWith(...)` or call `instanceOfGoogleAccountCreate.copyWith.fieldName(value)` for a single field.
class _$GoogleAccountCreateCWProxyImpl implements _$GoogleAccountCreateCWProxy {
  const _$GoogleAccountCreateCWProxyImpl(this._value);

  final GoogleAccountCreate _value;

  @override
  GoogleAccountCreate idUser(String idUser) => call(idUser: idUser);

  @override
  GoogleAccountCreate googleUserId(String? googleUserId) =>
      call(googleUserId: googleUserId);

  @override
  GoogleAccountCreate emailGoogle(String emailGoogle) =>
      call(emailGoogle: emailGoogle);

  @override
  GoogleAccountCreate accessTokenEnc(String? accessTokenEnc) =>
      call(accessTokenEnc: accessTokenEnc);

  @override
  GoogleAccountCreate refreshTokenEnc(String? refreshTokenEnc) =>
      call(refreshTokenEnc: refreshTokenEnc);

  @override
  GoogleAccountCreate grantedScopes(String? grantedScopes) =>
      call(grantedScopes: grantedScopes);

  @override
  GoogleAccountCreate isActive(bool isActive) => call(isActive: isActive);

  @override
  GoogleAccountCreate expiresAt(DateTime? expiresAt) =>
      call(expiresAt: expiresAt);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `GoogleAccountCreate(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// GoogleAccountCreate(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  GoogleAccountCreate call({
    Object? idUser = const $CopyWithPlaceholder(),
    Object? googleUserId = const $CopyWithPlaceholder(),
    Object? emailGoogle = const $CopyWithPlaceholder(),
    Object? accessTokenEnc = const $CopyWithPlaceholder(),
    Object? refreshTokenEnc = const $CopyWithPlaceholder(),
    Object? grantedScopes = const $CopyWithPlaceholder(),
    Object? isActive = const $CopyWithPlaceholder(),
    Object? expiresAt = const $CopyWithPlaceholder(),
  }) {
    return GoogleAccountCreate(
      idUser: idUser == const $CopyWithPlaceholder() || idUser == null
          ? _value.idUser
          // ignore: cast_nullable_to_non_nullable
          : idUser as String,
      googleUserId: googleUserId == const $CopyWithPlaceholder()
          ? _value.googleUserId
          // ignore: cast_nullable_to_non_nullable
          : googleUserId as String?,
      emailGoogle:
          emailGoogle == const $CopyWithPlaceholder() || emailGoogle == null
          ? _value.emailGoogle
          // ignore: cast_nullable_to_non_nullable
          : emailGoogle as String,
      accessTokenEnc: accessTokenEnc == const $CopyWithPlaceholder()
          ? _value.accessTokenEnc
          // ignore: cast_nullable_to_non_nullable
          : accessTokenEnc as String?,
      refreshTokenEnc: refreshTokenEnc == const $CopyWithPlaceholder()
          ? _value.refreshTokenEnc
          // ignore: cast_nullable_to_non_nullable
          : refreshTokenEnc as String?,
      grantedScopes: grantedScopes == const $CopyWithPlaceholder()
          ? _value.grantedScopes
          // ignore: cast_nullable_to_non_nullable
          : grantedScopes as String?,
      isActive: isActive == const $CopyWithPlaceholder() || isActive == null
          ? _value.isActive
          // ignore: cast_nullable_to_non_nullable
          : isActive as bool,
      expiresAt: expiresAt == const $CopyWithPlaceholder()
          ? _value.expiresAt
          // ignore: cast_nullable_to_non_nullable
          : expiresAt as DateTime?,
    );
  }
}

extension $GoogleAccountCreateCopyWith on GoogleAccountCreate {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfGoogleAccountCreate.copyWith(...)` or `instanceOfGoogleAccountCreate.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$GoogleAccountCreateCWProxy get copyWith =>
      _$GoogleAccountCreateCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoogleAccountCreate _$GoogleAccountCreateFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'GoogleAccountCreate',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const [
            'id_user',
            'google_user_id',
            'email_google',
            'access_token_enc',
            'refresh_token_enc',
            'granted_scopes',
            'is_active',
            'expires_at',
          ],
        );
        final val = GoogleAccountCreate(
          idUser: $checkedConvert('id_user', (v) => v as String),
          googleUserId: $checkedConvert('google_user_id', (v) => v as String?),
          emailGoogle: $checkedConvert('email_google', (v) => v as String),
          accessTokenEnc: $checkedConvert(
            'access_token_enc',
            (v) => v as String?,
          ),
          refreshTokenEnc: $checkedConvert(
            'refresh_token_enc',
            (v) => v as String?,
          ),
          grantedScopes: $checkedConvert('granted_scopes', (v) => v as String?),
          isActive: $checkedConvert('is_active', (v) => v as bool),
          expiresAt: $checkedConvert(
            'expires_at',
            (v) => v == null ? null : DateTime.parse(v as String),
          ),
        );
        return val;
      },
      fieldKeyMap: const {
        'idUser': 'id_user',
        'googleUserId': 'google_user_id',
        'emailGoogle': 'email_google',
        'accessTokenEnc': 'access_token_enc',
        'refreshTokenEnc': 'refresh_token_enc',
        'grantedScopes': 'granted_scopes',
        'isActive': 'is_active',
        'expiresAt': 'expires_at',
      },
    );

Map<String, dynamic> _$GoogleAccountCreateToJson(
  GoogleAccountCreate instance,
) => <String, dynamic>{
  'id_user': instance.idUser,
  'google_user_id': instance.googleUserId,
  'email_google': instance.emailGoogle,
  'access_token_enc': instance.accessTokenEnc,
  'refresh_token_enc': instance.refreshTokenEnc,
  'granted_scopes': instance.grantedScopes,
  'is_active': instance.isActive,
  'expires_at': instance.expiresAt?.toIso8601String(),
};

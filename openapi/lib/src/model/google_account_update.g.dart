// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'google_account_update.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$GoogleAccountUpdateCWProxy {
  GoogleAccountUpdate idUser(String? idUser);

  GoogleAccountUpdate googleUserId(String? googleUserId);

  GoogleAccountUpdate emailGoogle(String? emailGoogle);

  GoogleAccountUpdate accessTokenEnc(String? accessTokenEnc);

  GoogleAccountUpdate refreshTokenEnc(String? refreshTokenEnc);

  GoogleAccountUpdate grantedScopes(String? grantedScopes);

  GoogleAccountUpdate isActive(bool? isActive);

  GoogleAccountUpdate expiresAt(DateTime? expiresAt);

  GoogleAccountUpdate lastRefreshAt(DateTime? lastRefreshAt);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `GoogleAccountUpdate(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// GoogleAccountUpdate(...).copyWith(id: 12, name: "My name")
  /// ```
  GoogleAccountUpdate call({
    String? idUser,
    String? googleUserId,
    String? emailGoogle,
    String? accessTokenEnc,
    String? refreshTokenEnc,
    String? grantedScopes,
    bool? isActive,
    DateTime? expiresAt,
    DateTime? lastRefreshAt,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfGoogleAccountUpdate.copyWith(...)` or call `instanceOfGoogleAccountUpdate.copyWith.fieldName(value)` for a single field.
class _$GoogleAccountUpdateCWProxyImpl implements _$GoogleAccountUpdateCWProxy {
  const _$GoogleAccountUpdateCWProxyImpl(this._value);

  final GoogleAccountUpdate _value;

  @override
  GoogleAccountUpdate idUser(String? idUser) => call(idUser: idUser);

  @override
  GoogleAccountUpdate googleUserId(String? googleUserId) =>
      call(googleUserId: googleUserId);

  @override
  GoogleAccountUpdate emailGoogle(String? emailGoogle) =>
      call(emailGoogle: emailGoogle);

  @override
  GoogleAccountUpdate accessTokenEnc(String? accessTokenEnc) =>
      call(accessTokenEnc: accessTokenEnc);

  @override
  GoogleAccountUpdate refreshTokenEnc(String? refreshTokenEnc) =>
      call(refreshTokenEnc: refreshTokenEnc);

  @override
  GoogleAccountUpdate grantedScopes(String? grantedScopes) =>
      call(grantedScopes: grantedScopes);

  @override
  GoogleAccountUpdate isActive(bool? isActive) => call(isActive: isActive);

  @override
  GoogleAccountUpdate expiresAt(DateTime? expiresAt) =>
      call(expiresAt: expiresAt);

  @override
  GoogleAccountUpdate lastRefreshAt(DateTime? lastRefreshAt) =>
      call(lastRefreshAt: lastRefreshAt);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `GoogleAccountUpdate(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// GoogleAccountUpdate(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  GoogleAccountUpdate call({
    Object? idUser = const $CopyWithPlaceholder(),
    Object? googleUserId = const $CopyWithPlaceholder(),
    Object? emailGoogle = const $CopyWithPlaceholder(),
    Object? accessTokenEnc = const $CopyWithPlaceholder(),
    Object? refreshTokenEnc = const $CopyWithPlaceholder(),
    Object? grantedScopes = const $CopyWithPlaceholder(),
    Object? isActive = const $CopyWithPlaceholder(),
    Object? expiresAt = const $CopyWithPlaceholder(),
    Object? lastRefreshAt = const $CopyWithPlaceholder(),
  }) {
    return GoogleAccountUpdate(
      idUser: idUser == const $CopyWithPlaceholder()
          ? _value.idUser
          // ignore: cast_nullable_to_non_nullable
          : idUser as String?,
      googleUserId: googleUserId == const $CopyWithPlaceholder()
          ? _value.googleUserId
          // ignore: cast_nullable_to_non_nullable
          : googleUserId as String?,
      emailGoogle: emailGoogle == const $CopyWithPlaceholder()
          ? _value.emailGoogle
          // ignore: cast_nullable_to_non_nullable
          : emailGoogle as String?,
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
      isActive: isActive == const $CopyWithPlaceholder()
          ? _value.isActive
          // ignore: cast_nullable_to_non_nullable
          : isActive as bool?,
      expiresAt: expiresAt == const $CopyWithPlaceholder()
          ? _value.expiresAt
          // ignore: cast_nullable_to_non_nullable
          : expiresAt as DateTime?,
      lastRefreshAt: lastRefreshAt == const $CopyWithPlaceholder()
          ? _value.lastRefreshAt
          // ignore: cast_nullable_to_non_nullable
          : lastRefreshAt as DateTime?,
    );
  }
}

extension $GoogleAccountUpdateCopyWith on GoogleAccountUpdate {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfGoogleAccountUpdate.copyWith(...)` or `instanceOfGoogleAccountUpdate.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$GoogleAccountUpdateCWProxy get copyWith =>
      _$GoogleAccountUpdateCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoogleAccountUpdate _$GoogleAccountUpdateFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'GoogleAccountUpdate',
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
            'last_refresh_at',
          ],
        );
        final val = GoogleAccountUpdate(
          idUser: $checkedConvert('id_user', (v) => v as String?),
          googleUserId: $checkedConvert('google_user_id', (v) => v as String?),
          emailGoogle: $checkedConvert('email_google', (v) => v as String?),
          accessTokenEnc: $checkedConvert(
            'access_token_enc',
            (v) => v as String?,
          ),
          refreshTokenEnc: $checkedConvert(
            'refresh_token_enc',
            (v) => v as String?,
          ),
          grantedScopes: $checkedConvert('granted_scopes', (v) => v as String?),
          isActive: $checkedConvert('is_active', (v) => v as bool?),
          expiresAt: $checkedConvert(
            'expires_at',
            (v) => v == null ? null : DateTime.parse(v as String),
          ),
          lastRefreshAt: $checkedConvert(
            'last_refresh_at',
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
        'lastRefreshAt': 'last_refresh_at',
      },
    );

Map<String, dynamic> _$GoogleAccountUpdateToJson(
  GoogleAccountUpdate instance,
) => <String, dynamic>{
  'id_user': instance.idUser,
  'google_user_id': instance.googleUserId,
  'email_google': instance.emailGoogle,
  'access_token_enc': instance.accessTokenEnc,
  'refresh_token_enc': instance.refreshTokenEnc,
  'granted_scopes': instance.grantedScopes,
  'is_active': instance.isActive,
  'expires_at': instance.expiresAt?.toIso8601String(),
  'last_refresh_at': instance.lastRefreshAt?.toIso8601String(),
};

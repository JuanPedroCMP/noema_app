// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'google_account_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$GoogleAccountOutCWProxy {
  GoogleAccountOut id(String id);

  GoogleAccountOut idUser(String idUser);

  GoogleAccountOut googleUserId(String? googleUserId);

  GoogleAccountOut emailGoogle(String emailGoogle);

  GoogleAccountOut grantedScopes(String? grantedScopes);

  GoogleAccountOut isActive(bool isActive);

  GoogleAccountOut expiresAt(DateTime? expiresAt);

  GoogleAccountOut lastRefreshAt(DateTime? lastRefreshAt);

  GoogleAccountOut updatedAt(DateTime? updatedAt);

  GoogleAccountOut createdAt(DateTime? createdAt);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `GoogleAccountOut(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// GoogleAccountOut(...).copyWith(id: 12, name: "My name")
  /// ```
  GoogleAccountOut call({
    String id,
    String idUser,
    String? googleUserId,
    String emailGoogle,
    String? grantedScopes,
    bool isActive,
    DateTime? expiresAt,
    DateTime? lastRefreshAt,
    DateTime? updatedAt,
    DateTime? createdAt,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfGoogleAccountOut.copyWith(...)` or call `instanceOfGoogleAccountOut.copyWith.fieldName(value)` for a single field.
class _$GoogleAccountOutCWProxyImpl implements _$GoogleAccountOutCWProxy {
  const _$GoogleAccountOutCWProxyImpl(this._value);

  final GoogleAccountOut _value;

  @override
  GoogleAccountOut id(String id) => call(id: id);

  @override
  GoogleAccountOut idUser(String idUser) => call(idUser: idUser);

  @override
  GoogleAccountOut googleUserId(String? googleUserId) =>
      call(googleUserId: googleUserId);

  @override
  GoogleAccountOut emailGoogle(String emailGoogle) =>
      call(emailGoogle: emailGoogle);

  @override
  GoogleAccountOut grantedScopes(String? grantedScopes) =>
      call(grantedScopes: grantedScopes);

  @override
  GoogleAccountOut isActive(bool isActive) => call(isActive: isActive);

  @override
  GoogleAccountOut expiresAt(DateTime? expiresAt) => call(expiresAt: expiresAt);

  @override
  GoogleAccountOut lastRefreshAt(DateTime? lastRefreshAt) =>
      call(lastRefreshAt: lastRefreshAt);

  @override
  GoogleAccountOut updatedAt(DateTime? updatedAt) => call(updatedAt: updatedAt);

  @override
  GoogleAccountOut createdAt(DateTime? createdAt) => call(createdAt: createdAt);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `GoogleAccountOut(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// GoogleAccountOut(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  GoogleAccountOut call({
    Object? id = const $CopyWithPlaceholder(),
    Object? idUser = const $CopyWithPlaceholder(),
    Object? googleUserId = const $CopyWithPlaceholder(),
    Object? emailGoogle = const $CopyWithPlaceholder(),
    Object? grantedScopes = const $CopyWithPlaceholder(),
    Object? isActive = const $CopyWithPlaceholder(),
    Object? expiresAt = const $CopyWithPlaceholder(),
    Object? lastRefreshAt = const $CopyWithPlaceholder(),
    Object? updatedAt = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
  }) {
    return GoogleAccountOut(
      id: id == const $CopyWithPlaceholder() || id == null
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
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
      lastRefreshAt: lastRefreshAt == const $CopyWithPlaceholder()
          ? _value.lastRefreshAt
          // ignore: cast_nullable_to_non_nullable
          : lastRefreshAt as DateTime?,
      updatedAt: updatedAt == const $CopyWithPlaceholder()
          ? _value.updatedAt
          // ignore: cast_nullable_to_non_nullable
          : updatedAt as DateTime?,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime?,
    );
  }
}

extension $GoogleAccountOutCopyWith on GoogleAccountOut {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfGoogleAccountOut.copyWith(...)` or `instanceOfGoogleAccountOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$GoogleAccountOutCWProxy get copyWith => _$GoogleAccountOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoogleAccountOut _$GoogleAccountOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'GoogleAccountOut',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const [
            'id',
            'id_user',
            'google_user_id',
            'email_google',
            'granted_scopes',
            'is_active',
            'expires_at',
            'last_refresh_at',
            'updated_at',
            'created_at',
          ],
        );
        final val = GoogleAccountOut(
          id: $checkedConvert('id', (v) => v as String),
          idUser: $checkedConvert('id_user', (v) => v as String),
          googleUserId: $checkedConvert('google_user_id', (v) => v as String?),
          emailGoogle: $checkedConvert('email_google', (v) => v as String),
          grantedScopes: $checkedConvert('granted_scopes', (v) => v as String?),
          isActive: $checkedConvert('is_active', (v) => v as bool),
          expiresAt: $checkedConvert(
            'expires_at',
            (v) => v == null ? null : DateTime.parse(v as String),
          ),
          lastRefreshAt: $checkedConvert(
            'last_refresh_at',
            (v) => v == null ? null : DateTime.parse(v as String),
          ),
          updatedAt: $checkedConvert(
            'updated_at',
            (v) => v == null ? null : DateTime.parse(v as String),
          ),
          createdAt: $checkedConvert(
            'created_at',
            (v) => v == null ? null : DateTime.parse(v as String),
          ),
        );
        return val;
      },
      fieldKeyMap: const {
        'idUser': 'id_user',
        'googleUserId': 'google_user_id',
        'emailGoogle': 'email_google',
        'grantedScopes': 'granted_scopes',
        'isActive': 'is_active',
        'expiresAt': 'expires_at',
        'lastRefreshAt': 'last_refresh_at',
        'updatedAt': 'updated_at',
        'createdAt': 'created_at',
      },
    );

Map<String, dynamic> _$GoogleAccountOutToJson(GoogleAccountOut instance) =>
    <String, dynamic>{
      'id': instance.id,
      'id_user': instance.idUser,
      'google_user_id': instance.googleUserId,
      'email_google': instance.emailGoogle,
      'granted_scopes': instance.grantedScopes,
      'is_active': instance.isActive,
      'expires_at': instance.expiresAt?.toIso8601String(),
      'last_refresh_at': instance.lastRefreshAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
    };

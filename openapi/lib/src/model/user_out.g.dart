// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$UserOutCWProxy {
  UserOut id(String id);

  UserOut userName(String userName);

  UserOut primaryEmail(String primaryEmail);

  UserOut userDisplayName(String? userDisplayName);

  UserOut createdAt(DateTime? createdAt);

  UserOut updatedAt(DateTime? updatedAt);

  UserOut isActive(bool? isActive);

  UserOut isVerified(bool? isVerified);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `UserOut(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// UserOut(...).copyWith(id: 12, name: "My name")
  /// ```
  UserOut call({
    String id,
    String userName,
    String primaryEmail,
    String? userDisplayName,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    bool? isVerified,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfUserOut.copyWith(...)` or call `instanceOfUserOut.copyWith.fieldName(value)` for a single field.
class _$UserOutCWProxyImpl implements _$UserOutCWProxy {
  const _$UserOutCWProxyImpl(this._value);

  final UserOut _value;

  @override
  UserOut id(String id) => call(id: id);

  @override
  UserOut userName(String userName) => call(userName: userName);

  @override
  UserOut primaryEmail(String primaryEmail) => call(primaryEmail: primaryEmail);

  @override
  UserOut userDisplayName(String? userDisplayName) =>
      call(userDisplayName: userDisplayName);

  @override
  UserOut createdAt(DateTime? createdAt) => call(createdAt: createdAt);

  @override
  UserOut updatedAt(DateTime? updatedAt) => call(updatedAt: updatedAt);

  @override
  UserOut isActive(bool? isActive) => call(isActive: isActive);

  @override
  UserOut isVerified(bool? isVerified) => call(isVerified: isVerified);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `UserOut(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// UserOut(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  UserOut call({
    Object? id = const $CopyWithPlaceholder(),
    Object? userName = const $CopyWithPlaceholder(),
    Object? primaryEmail = const $CopyWithPlaceholder(),
    Object? userDisplayName = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? updatedAt = const $CopyWithPlaceholder(),
    Object? isActive = const $CopyWithPlaceholder(),
    Object? isVerified = const $CopyWithPlaceholder(),
  }) {
    return UserOut(
      id: id == const $CopyWithPlaceholder() || id == null
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      userName: userName == const $CopyWithPlaceholder() || userName == null
          ? _value.userName
          // ignore: cast_nullable_to_non_nullable
          : userName as String,
      primaryEmail:
          primaryEmail == const $CopyWithPlaceholder() || primaryEmail == null
          ? _value.primaryEmail
          // ignore: cast_nullable_to_non_nullable
          : primaryEmail as String,
      userDisplayName: userDisplayName == const $CopyWithPlaceholder()
          ? _value.userDisplayName
          // ignore: cast_nullable_to_non_nullable
          : userDisplayName as String?,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime?,
      updatedAt: updatedAt == const $CopyWithPlaceholder()
          ? _value.updatedAt
          // ignore: cast_nullable_to_non_nullable
          : updatedAt as DateTime?,
      isActive: isActive == const $CopyWithPlaceholder()
          ? _value.isActive
          // ignore: cast_nullable_to_non_nullable
          : isActive as bool?,
      isVerified: isVerified == const $CopyWithPlaceholder()
          ? _value.isVerified
          // ignore: cast_nullable_to_non_nullable
          : isVerified as bool?,
    );
  }
}

extension $UserOutCopyWith on UserOut {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfUserOut.copyWith(...)` or `instanceOfUserOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$UserOutCWProxy get copyWith => _$UserOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserOut _$UserOutFromJson(Map<String, dynamic> json) => $checkedCreate(
  'UserOut',
  json,
  ($checkedConvert) {
    $checkKeys(
      json,
      requiredKeys: const [
        'id',
        'user_name',
        'primary_email',
        'user_display_name',
        'created_at',
        'updated_at',
        'is_active',
        'is_verified',
      ],
    );
    final val = UserOut(
      id: $checkedConvert('id', (v) => v as String),
      userName: $checkedConvert('user_name', (v) => v as String),
      primaryEmail: $checkedConvert('primary_email', (v) => v as String),
      userDisplayName: $checkedConvert(
        'user_display_name',
        (v) => v as String?,
      ),
      createdAt: $checkedConvert(
        'created_at',
        (v) => v == null ? null : DateTime.parse(v as String),
      ),
      updatedAt: $checkedConvert(
        'updated_at',
        (v) => v == null ? null : DateTime.parse(v as String),
      ),
      isActive: $checkedConvert('is_active', (v) => v as bool?),
      isVerified: $checkedConvert('is_verified', (v) => v as bool?),
    );
    return val;
  },
  fieldKeyMap: const {
    'userName': 'user_name',
    'primaryEmail': 'primary_email',
    'userDisplayName': 'user_display_name',
    'createdAt': 'created_at',
    'updatedAt': 'updated_at',
    'isActive': 'is_active',
    'isVerified': 'is_verified',
  },
);

Map<String, dynamic> _$UserOutToJson(UserOut instance) => <String, dynamic>{
  'id': instance.id,
  'user_name': instance.userName,
  'primary_email': instance.primaryEmail,
  'user_display_name': instance.userDisplayName,
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
  'is_active': instance.isActive,
  'is_verified': instance.isVerified,
};

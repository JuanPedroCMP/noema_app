// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_update.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$UserUpdateCWProxy {
  UserUpdate userName(String? userName);

  UserUpdate primaryEmail(String? primaryEmail);

  UserUpdate userDisplayName(String? userDisplayName);

  UserUpdate password(String? password);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `UserUpdate(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// UserUpdate(...).copyWith(id: 12, name: "My name")
  /// ```
  UserUpdate call({
    String? userName,
    String? primaryEmail,
    String? userDisplayName,
    String? password,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfUserUpdate.copyWith(...)` or call `instanceOfUserUpdate.copyWith.fieldName(value)` for a single field.
class _$UserUpdateCWProxyImpl implements _$UserUpdateCWProxy {
  const _$UserUpdateCWProxyImpl(this._value);

  final UserUpdate _value;

  @override
  UserUpdate userName(String? userName) => call(userName: userName);

  @override
  UserUpdate primaryEmail(String? primaryEmail) =>
      call(primaryEmail: primaryEmail);

  @override
  UserUpdate userDisplayName(String? userDisplayName) =>
      call(userDisplayName: userDisplayName);

  @override
  UserUpdate password(String? password) => call(password: password);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `UserUpdate(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// UserUpdate(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  UserUpdate call({
    Object? userName = const $CopyWithPlaceholder(),
    Object? primaryEmail = const $CopyWithPlaceholder(),
    Object? userDisplayName = const $CopyWithPlaceholder(),
    Object? password = const $CopyWithPlaceholder(),
  }) {
    return UserUpdate(
      userName: userName == const $CopyWithPlaceholder()
          ? _value.userName
          // ignore: cast_nullable_to_non_nullable
          : userName as String?,
      primaryEmail: primaryEmail == const $CopyWithPlaceholder()
          ? _value.primaryEmail
          // ignore: cast_nullable_to_non_nullable
          : primaryEmail as String?,
      userDisplayName: userDisplayName == const $CopyWithPlaceholder()
          ? _value.userDisplayName
          // ignore: cast_nullable_to_non_nullable
          : userDisplayName as String?,
      password: password == const $CopyWithPlaceholder()
          ? _value.password
          // ignore: cast_nullable_to_non_nullable
          : password as String?,
    );
  }
}

extension $UserUpdateCopyWith on UserUpdate {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfUserUpdate.copyWith(...)` or `instanceOfUserUpdate.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$UserUpdateCWProxy get copyWith => _$UserUpdateCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserUpdate _$UserUpdateFromJson(Map<String, dynamic> json) => $checkedCreate(
  'UserUpdate',
  json,
  ($checkedConvert) {
    final val = UserUpdate(
      userName: $checkedConvert('user_name', (v) => v as String?),
      primaryEmail: $checkedConvert('primary_email', (v) => v as String?),
      userDisplayName: $checkedConvert(
        'user_display_name',
        (v) => v as String?,
      ),
      password: $checkedConvert('password', (v) => v as String?),
    );
    return val;
  },
  fieldKeyMap: const {
    'userName': 'user_name',
    'primaryEmail': 'primary_email',
    'userDisplayName': 'user_display_name',
  },
);

Map<String, dynamic> _$UserUpdateToJson(UserUpdate instance) =>
    <String, dynamic>{
      'user_name': ?instance.userName,
      'primary_email': ?instance.primaryEmail,
      'user_display_name': ?instance.userDisplayName,
      'password': ?instance.password,
    };

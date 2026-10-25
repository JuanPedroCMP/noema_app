// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_create.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$UserCreateCWProxy {
  UserCreate userName(String? userName);

  UserCreate primaryEmail(String primaryEmail);

  UserCreate userDisplayName(String? userDisplayName);

  UserCreate password(String? password);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `UserCreate(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// UserCreate(...).copyWith(id: 12, name: "My name")
  /// ```
  UserCreate call({
    String? userName,
    String primaryEmail,
    String? userDisplayName,
    String? password,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfUserCreate.copyWith(...)` or call `instanceOfUserCreate.copyWith.fieldName(value)` for a single field.
class _$UserCreateCWProxyImpl implements _$UserCreateCWProxy {
  const _$UserCreateCWProxyImpl(this._value);

  final UserCreate _value;

  @override
  UserCreate userName(String? userName) => call(userName: userName);

  @override
  UserCreate primaryEmail(String primaryEmail) =>
      call(primaryEmail: primaryEmail);

  @override
  UserCreate userDisplayName(String? userDisplayName) =>
      call(userDisplayName: userDisplayName);

  @override
  UserCreate password(String? password) => call(password: password);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `UserCreate(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// UserCreate(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  UserCreate call({
    Object? userName = const $CopyWithPlaceholder(),
    Object? primaryEmail = const $CopyWithPlaceholder(),
    Object? userDisplayName = const $CopyWithPlaceholder(),
    Object? password = const $CopyWithPlaceholder(),
  }) {
    return UserCreate(
      userName: userName == const $CopyWithPlaceholder()
          ? _value.userName
          // ignore: cast_nullable_to_non_nullable
          : userName as String?,
      primaryEmail:
          primaryEmail == const $CopyWithPlaceholder() || primaryEmail == null
          ? _value.primaryEmail
          // ignore: cast_nullable_to_non_nullable
          : primaryEmail as String,
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

extension $UserCreateCopyWith on UserCreate {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfUserCreate.copyWith(...)` or `instanceOfUserCreate.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$UserCreateCWProxy get copyWith => _$UserCreateCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserCreate _$UserCreateFromJson(Map<String, dynamic> json) => $checkedCreate(
  'UserCreate',
  json,
  ($checkedConvert) {
    $checkKeys(json, requiredKeys: const ['primary_email']);
    final val = UserCreate(
      userName: $checkedConvert('user_name', (v) => v as String? ?? ''),
      primaryEmail: $checkedConvert('primary_email', (v) => v as String),
      userDisplayName: $checkedConvert(
        'user_display_name',
        (v) => v as String?,
      ),
      password: $checkedConvert('password', (v) => v as String? ?? ''),
    );
    return val;
  },
  fieldKeyMap: const {
    'userName': 'user_name',
    'primaryEmail': 'primary_email',
    'userDisplayName': 'user_display_name',
  },
);

Map<String, dynamic> _$UserCreateToJson(UserCreate instance) =>
    <String, dynamic>{
      'user_name': ?instance.userName,
      'primary_email': instance.primaryEmail,
      'user_display_name': ?instance.userDisplayName,
      'password': ?instance.password,
    };

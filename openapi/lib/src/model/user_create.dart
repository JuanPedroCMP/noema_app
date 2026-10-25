//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_create.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class UserCreate {
  /// Returns a new [UserCreate] instance.
  UserCreate({

     this.userName = '',

    required  this.primaryEmail,

     this.userDisplayName,

     this.password = '',
  });

  @JsonKey(
    defaultValue: '',
    name: r'user_name',
    required: false,
    includeIfNull: false,
  )


  final String? userName;



  @JsonKey(
    
    name: r'primary_email',
    required: true,
    includeIfNull: false,
  )


  final String primaryEmail;



  @JsonKey(
    
    name: r'user_display_name',
    required: false,
    includeIfNull: false,
  )


  final String? userDisplayName;



  @JsonKey(
    defaultValue: '',
    name: r'password',
    required: false,
    includeIfNull: false,
  )


  final String? password;





    @override
    bool operator ==(Object other) => identical(this, other) || other is UserCreate &&
      other.userName == userName &&
      other.primaryEmail == primaryEmail &&
      other.userDisplayName == userDisplayName &&
      other.password == password;

    @override
    int get hashCode =>
        userName.hashCode +
        primaryEmail.hashCode +
        (userDisplayName == null ? 0 : userDisplayName.hashCode) +
        password.hashCode;

  factory UserCreate.fromJson(Map<String, dynamic> json) => _$UserCreateFromJson(json);

  Map<String, dynamic> toJson() => _$UserCreateToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


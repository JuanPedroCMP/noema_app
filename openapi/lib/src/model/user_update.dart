//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_update.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class UserUpdate {
  /// Returns a new [UserUpdate] instance.
  UserUpdate({

     this.userName,

     this.primaryEmail,

     this.userDisplayName,

     this.password,
  });

  @JsonKey(
    
    name: r'user_name',
    required: false,
    includeIfNull: false,
  )


  final String? userName;



  @JsonKey(
    
    name: r'primary_email',
    required: false,
    includeIfNull: false,
  )


  final String? primaryEmail;



  @JsonKey(
    
    name: r'user_display_name',
    required: false,
    includeIfNull: false,
  )


  final String? userDisplayName;



  @JsonKey(
    
    name: r'password',
    required: false,
    includeIfNull: false,
  )


  final String? password;





    @override
    bool operator ==(Object other) => identical(this, other) || other is UserUpdate &&
      other.userName == userName &&
      other.primaryEmail == primaryEmail &&
      other.userDisplayName == userDisplayName &&
      other.password == password;

    @override
    int get hashCode =>
        (userName == null ? 0 : userName.hashCode) +
        (primaryEmail == null ? 0 : primaryEmail.hashCode) +
        (userDisplayName == null ? 0 : userDisplayName.hashCode) +
        (password == null ? 0 : password.hashCode);

  factory UserUpdate.fromJson(Map<String, dynamic> json) => _$UserUpdateFromJson(json);

  Map<String, dynamic> toJson() => _$UserUpdateToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


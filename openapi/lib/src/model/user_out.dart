//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class UserOut {
  /// Returns a new [UserOut] instance.
  UserOut({

    required  this.id,

    required  this.userName,

    required  this.primaryEmail,

    required  this.userDisplayName,

    required  this.createdAt,

    required  this.updatedAt,

    required  this.isActive,

    required  this.isVerified,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'user_name',
    required: true,
    includeIfNull: false,
  )


  final String userName;



  @JsonKey(
    
    name: r'primary_email',
    required: true,
    includeIfNull: false,
  )


  final String primaryEmail;



  @JsonKey(
    
    name: r'user_display_name',
    required: true,
    includeIfNull: true,
  )


  final String? userDisplayName;



  @JsonKey(
    
    name: r'created_at',
    required: true,
    includeIfNull: true,
  )


  final DateTime? createdAt;



  @JsonKey(
    
    name: r'updated_at',
    required: true,
    includeIfNull: true,
  )


  final DateTime? updatedAt;



  @JsonKey(
    
    name: r'is_active',
    required: true,
    includeIfNull: true,
  )


  final bool? isActive;



  @JsonKey(
    
    name: r'is_verified',
    required: true,
    includeIfNull: true,
  )


  final bool? isVerified;





    @override
    bool operator ==(Object other) => identical(this, other) || other is UserOut &&
      other.id == id &&
      other.userName == userName &&
      other.primaryEmail == primaryEmail &&
      other.userDisplayName == userDisplayName &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt &&
      other.isActive == isActive &&
      other.isVerified == isVerified;

    @override
    int get hashCode =>
        id.hashCode +
        userName.hashCode +
        primaryEmail.hashCode +
        (userDisplayName == null ? 0 : userDisplayName.hashCode) +
        (createdAt == null ? 0 : createdAt.hashCode) +
        (updatedAt == null ? 0 : updatedAt.hashCode) +
        (isActive == null ? 0 : isActive.hashCode) +
        (isVerified == null ? 0 : isVerified.hashCode);

  factory UserOut.fromJson(Map<String, dynamic> json) => _$UserOutFromJson(json);

  Map<String, dynamic> toJson() => _$UserOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


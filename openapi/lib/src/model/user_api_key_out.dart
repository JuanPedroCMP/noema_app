//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_api_key_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class UserApiKeyOut {
  /// Returns a new [UserApiKeyOut] instance.
  UserApiKeyOut({

    required  this.id,

    required  this.idAiProvider,

    required  this.idUser,

    required  this.name,

    required  this.isActive,

    required  this.createdAt,

    required  this.updatedAt,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'id_ai_provider',
    required: true,
    includeIfNull: false,
  )


  final String idAiProvider;



  @JsonKey(
    
    name: r'id_user',
    required: true,
    includeIfNull: false,
  )


  final String idUser;



  @JsonKey(
    
    name: r'name',
    required: true,
    includeIfNull: false,
  )


  final String name;



  @JsonKey(
    
    name: r'is_active',
    required: true,
    includeIfNull: false,
  )


  final bool isActive;



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





    @override
    bool operator ==(Object other) => identical(this, other) || other is UserApiKeyOut &&
      other.id == id &&
      other.idAiProvider == idAiProvider &&
      other.idUser == idUser &&
      other.name == name &&
      other.isActive == isActive &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt;

    @override
    int get hashCode =>
        id.hashCode +
        idAiProvider.hashCode +
        idUser.hashCode +
        name.hashCode +
        isActive.hashCode +
        (createdAt == null ? 0 : createdAt.hashCode) +
        (updatedAt == null ? 0 : updatedAt.hashCode);

  factory UserApiKeyOut.fromJson(Map<String, dynamic> json) => _$UserApiKeyOutFromJson(json);

  Map<String, dynamic> toJson() => _$UserApiKeyOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


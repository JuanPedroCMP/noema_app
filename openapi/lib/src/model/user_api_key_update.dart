//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_api_key_update.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class UserApiKeyUpdate {
  /// Returns a new [UserApiKeyUpdate] instance.
  UserApiKeyUpdate({

     this.idAiProvider,

     this.idUser,

     this.name,

     this.apiKey,

     this.isActive,
  });

  @JsonKey(
    
    name: r'id_ai_provider',
    required: false,
    includeIfNull: false,
  )


  final String? idAiProvider;



  @JsonKey(
    
    name: r'id_user',
    required: false,
    includeIfNull: false,
  )


  final String? idUser;



  @JsonKey(
    
    name: r'name',
    required: false,
    includeIfNull: false,
  )


  final String? name;



  @JsonKey(
    
    name: r'api_key',
    required: false,
    includeIfNull: false,
  )


  final String? apiKey;



  @JsonKey(
    
    name: r'is_active',
    required: false,
    includeIfNull: false,
  )


  final bool? isActive;





    @override
    bool operator ==(Object other) => identical(this, other) || other is UserApiKeyUpdate &&
      other.idAiProvider == idAiProvider &&
      other.idUser == idUser &&
      other.name == name &&
      other.apiKey == apiKey &&
      other.isActive == isActive;

    @override
    int get hashCode =>
        (idAiProvider == null ? 0 : idAiProvider.hashCode) +
        (idUser == null ? 0 : idUser.hashCode) +
        (name == null ? 0 : name.hashCode) +
        (apiKey == null ? 0 : apiKey.hashCode) +
        (isActive == null ? 0 : isActive.hashCode);

  factory UserApiKeyUpdate.fromJson(Map<String, dynamic> json) => _$UserApiKeyUpdateFromJson(json);

  Map<String, dynamic> toJson() => _$UserApiKeyUpdateToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


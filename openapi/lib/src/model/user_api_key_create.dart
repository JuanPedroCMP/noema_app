//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_api_key_create.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class UserApiKeyCreate {
  /// Returns a new [UserApiKeyCreate] instance.
  UserApiKeyCreate({

    required  this.idAiProvider,

    required  this.name,

    required  this.apiKey,

     this.isActive = true,
  });

  @JsonKey(
    
    name: r'id_ai_provider',
    required: true,
    includeIfNull: false,
  )


  final String idAiProvider;



  @JsonKey(
    
    name: r'name',
    required: true,
    includeIfNull: false,
  )


  final String name;



  @JsonKey(
    
    name: r'api_key',
    required: true,
    includeIfNull: false,
  )


  final String apiKey;



  @JsonKey(
    defaultValue: true,
    name: r'is_active',
    required: false,
    includeIfNull: false,
  )


  final bool? isActive;





    @override
    bool operator ==(Object other) => identical(this, other) || other is UserApiKeyCreate &&
      other.idAiProvider == idAiProvider &&
      other.name == name &&
      other.apiKey == apiKey &&
      other.isActive == isActive;

    @override
    int get hashCode =>
        idAiProvider.hashCode +
        name.hashCode +
        apiKey.hashCode +
        isActive.hashCode;

  factory UserApiKeyCreate.fromJson(Map<String, dynamic> json) => _$UserApiKeyCreateFromJson(json);

  Map<String, dynamic> toJson() => _$UserApiKeyCreateToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


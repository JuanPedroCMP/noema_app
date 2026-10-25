//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_api_key_can_use_ia_model_create.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class UserApiKeyCanUseIaModelCreate {
  /// Returns a new [UserApiKeyCanUseIaModelCreate] instance.
  UserApiKeyCanUseIaModelCreate({

    required  this.idAiModel,

    required  this.idUserApiKey,
  });

  @JsonKey(
    
    name: r'id_ai_model',
    required: true,
    includeIfNull: false,
  )


  final String idAiModel;



  @JsonKey(
    
    name: r'id_user_api_key',
    required: true,
    includeIfNull: false,
  )


  final String idUserApiKey;





    @override
    bool operator ==(Object other) => identical(this, other) || other is UserApiKeyCanUseIaModelCreate &&
      other.idAiModel == idAiModel &&
      other.idUserApiKey == idUserApiKey;

    @override
    int get hashCode =>
        idAiModel.hashCode +
        idUserApiKey.hashCode;

  factory UserApiKeyCanUseIaModelCreate.fromJson(Map<String, dynamic> json) => _$UserApiKeyCanUseIaModelCreateFromJson(json);

  Map<String, dynamic> toJson() => _$UserApiKeyCanUseIaModelCreateToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


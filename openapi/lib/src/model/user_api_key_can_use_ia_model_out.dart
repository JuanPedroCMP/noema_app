//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_api_key_can_use_ia_model_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class UserApiKeyCanUseIaModelOut {
  /// Returns a new [UserApiKeyCanUseIaModelOut] instance.
  UserApiKeyCanUseIaModelOut({

    required  this.id,

    required  this.idAiModel,

    required  this.idUserApiKey,

    required  this.createdAt,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



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



  @JsonKey(
    
    name: r'created_at',
    required: true,
    includeIfNull: true,
  )


  final DateTime? createdAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is UserApiKeyCanUseIaModelOut &&
      other.id == id &&
      other.idAiModel == idAiModel &&
      other.idUserApiKey == idUserApiKey &&
      other.createdAt == createdAt;

    @override
    int get hashCode =>
        id.hashCode +
        idAiModel.hashCode +
        idUserApiKey.hashCode +
        (createdAt == null ? 0 : createdAt.hashCode);

  factory UserApiKeyCanUseIaModelOut.fromJson(Map<String, dynamic> json) => _$UserApiKeyCanUseIaModelOutFromJson(json);

  Map<String, dynamic> toJson() => _$UserApiKeyCanUseIaModelOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


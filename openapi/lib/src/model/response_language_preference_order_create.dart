//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'response_language_preference_order_create.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ResponseLanguagePreferenceOrderCreate {
  /// Returns a new [ResponseLanguagePreferenceOrderCreate] instance.
  ResponseLanguagePreferenceOrderCreate({

    required  this.preferenceOrder,

    required  this.idUser,

    required  this.idLanguage,
  });

  @JsonKey(
    
    name: r'preference_order',
    required: true,
    includeIfNull: false,
  )


  final int preferenceOrder;



  @JsonKey(
    
    name: r'id_user',
    required: true,
    includeIfNull: false,
  )


  final String idUser;



  @JsonKey(
    
    name: r'id_language',
    required: true,
    includeIfNull: false,
  )


  final String idLanguage;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ResponseLanguagePreferenceOrderCreate &&
      other.preferenceOrder == preferenceOrder &&
      other.idUser == idUser &&
      other.idLanguage == idLanguage;

    @override
    int get hashCode =>
        preferenceOrder.hashCode +
        idUser.hashCode +
        idLanguage.hashCode;

  factory ResponseLanguagePreferenceOrderCreate.fromJson(Map<String, dynamic> json) => _$ResponseLanguagePreferenceOrderCreateFromJson(json);

  Map<String, dynamic> toJson() => _$ResponseLanguagePreferenceOrderCreateToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


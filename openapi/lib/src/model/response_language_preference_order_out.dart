//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'response_language_preference_order_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ResponseLanguagePreferenceOrderOut {
  /// Returns a new [ResponseLanguagePreferenceOrderOut] instance.
  ResponseLanguagePreferenceOrderOut({

    required  this.id,

    required  this.preferenceOrder,

    required  this.idUser,

    required  this.idLanguage,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



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
    bool operator ==(Object other) => identical(this, other) || other is ResponseLanguagePreferenceOrderOut &&
      other.id == id &&
      other.preferenceOrder == preferenceOrder &&
      other.idUser == idUser &&
      other.idLanguage == idLanguage;

    @override
    int get hashCode =>
        id.hashCode +
        preferenceOrder.hashCode +
        idUser.hashCode +
        idLanguage.hashCode;

  factory ResponseLanguagePreferenceOrderOut.fromJson(Map<String, dynamic> json) => _$ResponseLanguagePreferenceOrderOutFromJson(json);

  Map<String, dynamic> toJson() => _$ResponseLanguagePreferenceOrderOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


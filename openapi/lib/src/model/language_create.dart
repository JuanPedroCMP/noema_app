//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'language_create.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class LanguageCreate {
  /// Returns a new [LanguageCreate] instance.
  LanguageCreate({

    required  this.name,

    required  this.percentageTranslated,

    required  this.verifiedTranslation,

    required  this.automaticTranslation,
  });

  @JsonKey(
    
    name: r'name',
    required: true,
    includeIfNull: false,
  )


  final String name;



  @JsonKey(
    
    name: r'percentage_translated',
    required: true,
    includeIfNull: false,
  )


  final int percentageTranslated;



  @JsonKey(
    
    name: r'verified_translation',
    required: true,
    includeIfNull: false,
  )


  final bool verifiedTranslation;



  @JsonKey(
    
    name: r'automatic_translation',
    required: true,
    includeIfNull: false,
  )


  final bool automaticTranslation;





    @override
    bool operator ==(Object other) => identical(this, other) || other is LanguageCreate &&
      other.name == name &&
      other.percentageTranslated == percentageTranslated &&
      other.verifiedTranslation == verifiedTranslation &&
      other.automaticTranslation == automaticTranslation;

    @override
    int get hashCode =>
        name.hashCode +
        percentageTranslated.hashCode +
        verifiedTranslation.hashCode +
        automaticTranslation.hashCode;

  factory LanguageCreate.fromJson(Map<String, dynamic> json) => _$LanguageCreateFromJson(json);

  Map<String, dynamic> toJson() => _$LanguageCreateToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


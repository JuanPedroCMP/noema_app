import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for LanguageApi
void main() {
  final instance = Openapi().getLanguageApi();

  group(LanguageApi, () {
    // Create Language
    //
    //Future<LanguageOut> createLanguageApiV1UserConfigLanguageCreatePost(LanguageCreate languageCreate) async
    test('test createLanguageApiV1UserConfigLanguageCreatePost', () async {
      // TODO
    });

    // Get Language
    //
    //Future<LanguageOut> getLanguageApiV1UserConfigLanguageGetIdentificatorGet(String identificator) async
    test('test getLanguageApiV1UserConfigLanguageGetIdentificatorGet', () async {
      // TODO
    });

    // List Languages
    //
    //Future<BuiltList<LanguageOut>> listLanguagesApiV1UserConfigLanguageListGet({ String id, String name, int percentageTranslated, bool verifiedTranslation, bool automaticTranslation, DateTime createdAt, DateTime updatedAt }) async
    test('test listLanguagesApiV1UserConfigLanguageListGet', () async {
      // TODO
    });

    // Update Language
    //
    //Future<LanguageOut> updateLanguageApiV1UserConfigLanguageUpdateIdentificatorPut(String identificator, LanguageUpdate languageUpdate) async
    test('test updateLanguageApiV1UserConfigLanguageUpdateIdentificatorPut', () async {
      // TODO
    });

  });
}

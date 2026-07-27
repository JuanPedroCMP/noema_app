import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for TypographyThemeApi
void main() {
  final instance = Openapi().getTypographyThemeApi();

  group(TypographyThemeApi, () {
    // Create Typography Theme
    //
    //Future<UserTypographyThemeOut> createTypographyThemeApiV1UserThemeTypographyThemeCreatePost(UserTypographyThemeCreate userTypographyThemeCreate) async
    test('test createTypographyThemeApiV1UserThemeTypographyThemeCreatePost', () async {
      // TODO
    });

    // Delete Typography Theme
    //
    //Future<JsonObject> deleteTypographyThemeApiV1UserThemeTypographyThemeDeleteIdentificatorDelete(String identificator) async
    test('test deleteTypographyThemeApiV1UserThemeTypographyThemeDeleteIdentificatorDelete', () async {
      // TODO
    });

    // Get Typography Theme
    //
    //Future<UserTypographyThemeOut> getTypographyThemeApiV1UserThemeTypographyThemeGetIdentificatorGet(String identificator) async
    test('test getTypographyThemeApiV1UserThemeTypographyThemeGetIdentificatorGet', () async {
      // TODO
    });

    // List Typography Theme
    //
    //Future<BuiltList<UserTypographyThemeOut>> listTypographyThemeApiV1UserThemeTypographyThemeListGet({ String id, String idUser, String name, String displayFont, String bodyFont, String monoFont, String overrideJson, DateTime createdAt, DateTime updatedAt }) async
    test('test listTypographyThemeApiV1UserThemeTypographyThemeListGet', () async {
      // TODO
    });

    // Update Typography Theme
    //
    //Future<UserTypographyThemeOut> updateTypographyThemeApiV1UserThemeTypographyThemeUpdateIdentificatorPut(String identificator, UserTypographyThemeUpdate userTypographyThemeUpdate) async
    test('test updateTypographyThemeApiV1UserThemeTypographyThemeUpdateIdentificatorPut', () async {
      // TODO
    });

  });
}

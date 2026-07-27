import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for ColorThemeApi
void main() {
  final instance = Openapi().getColorThemeApi();

  group(ColorThemeApi, () {
    // Create Color Theme
    //
    //Future<UserColorThemeOut> createColorThemeApiV1UserThemeColorThemeCreatePost(UserColorThemeCreate userColorThemeCreate) async
    test('test createColorThemeApiV1UserThemeColorThemeCreatePost', () async {
      // TODO
    });

    // Delete Color Theme
    //
    //Future<JsonObject> deleteColorThemeApiV1UserThemeColorThemeDeleteIdentificatorDelete(String identificator) async
    test('test deleteColorThemeApiV1UserThemeColorThemeDeleteIdentificatorDelete', () async {
      // TODO
    });

    // Get Color Theme
    //
    //Future<UserColorThemeOut> getColorThemeApiV1UserThemeColorThemeGetIdentificatorGet(String identificator) async
    test('test getColorThemeApiV1UserThemeColorThemeGetIdentificatorGet', () async {
      // TODO
    });

    // List Color Theme
    //
    //Future<BuiltList<UserColorThemeOut>> listColorThemeApiV1UserThemeColorThemeListGet({ String id, String idUser, String name, int seedColor, String overrideJson, DateTime createdAt, DateTime updatedAt }) async
    test('test listColorThemeApiV1UserThemeColorThemeListGet', () async {
      // TODO
    });

    // Update Color Theme
    //
    //Future<UserColorThemeOut> updateColorThemeApiV1UserThemeColorThemeUpdateIdentificatorPut(String identificator, UserColorThemeUpdate userColorThemeUpdate) async
    test('test updateColorThemeApiV1UserThemeColorThemeUpdateIdentificatorPut', () async {
      // TODO
    });

  });
}

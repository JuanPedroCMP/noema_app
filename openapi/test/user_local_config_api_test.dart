import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for UserLocalConfigApi
void main() {
  final instance = Openapi().getUserLocalConfigApi();

  group(UserLocalConfigApi, () {
    // Create User Local Config
    //
    //Future<UserLocalConfigOut> createUserLocalConfigApiV1UserConfigUserLocalConfigCreatePost(UserLocalConfigCreate userLocalConfigCreate) async
    test('test createUserLocalConfigApiV1UserConfigUserLocalConfigCreatePost', () async {
      // TODO
    });

    // Get User Local Config
    //
    //Future<UserLocalConfigOut> getUserLocalConfigApiV1UserConfigUserLocalConfigGetIdentificatorGet(String identificator) async
    test('test getUserLocalConfigApiV1UserConfigUserLocalConfigGetIdentificatorGet', () async {
      // TODO
    });

    // List User Local Configs
    //
    //Future<BuiltList<UserLocalConfigOut>> listUserLocalConfigsApiV1UserConfigUserLocalConfigListGet(String preferences, { String id, String idUser, String idDevice, String idLanguage, String idUserColorTheme, String idUserTypographyTheme, DateTime createdAt, DateTime updatedAt }) async
    test('test listUserLocalConfigsApiV1UserConfigUserLocalConfigListGet', () async {
      // TODO
    });

    // Update User Local Config
    //
    //Future<UserLocalConfigOut> updateUserLocalConfigApiV1UserConfigUserLocalConfigUpdateIdentificatorPut(String identificator, UserLocalConfigUpdate userLocalConfigUpdate) async
    test('test updateUserLocalConfigApiV1UserConfigUserLocalConfigUpdateIdentificatorPut', () async {
      // TODO
    });

  });
}

import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for UserGlobalConfigApi
void main() {
  final instance = Openapi().getUserGlobalConfigApi();

  group(UserGlobalConfigApi, () {
    // Create User Global Config
    //
    //Future<UserGlobalConfigOut> createUserGlobalConfigApiV1UserConfigUserGlobalConfigCreatePost(UserGlobalConfigCreate userGlobalConfigCreate) async
    test('test createUserGlobalConfigApiV1UserConfigUserGlobalConfigCreatePost', () async {
      // TODO
    });

    // Get User Global Config
    //
    //Future<UserGlobalConfigOut> getUserGlobalConfigApiV1UserConfigUserGlobalConfigGetIdentificatorGet(String identificator) async
    test('test getUserGlobalConfigApiV1UserConfigUserGlobalConfigGetIdentificatorGet', () async {
      // TODO
    });

    // Update User Global Config
    //
    //Future<UserGlobalConfigOut> updateUserGlobalConfigApiV1UserConfigUserGlobalConfigUpdateIdentificatorPut(String identificator, UserGlobalConfigUpdate userGlobalConfigUpdate) async
    test('test updateUserGlobalConfigApiV1UserConfigUserGlobalConfigUpdateIdentificatorPut', () async {
      // TODO
    });

  });
}

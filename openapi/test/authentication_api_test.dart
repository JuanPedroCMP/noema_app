import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for AuthenticationApi
void main() {
  final instance = Openapi().getAuthenticationApi();

  group(AuthenticationApi, () {
    // Authenticate
    //
    //Future<Object> authenticateApiV1AuthLoginPost(String username, String password, { String grantType, String scope, String clientId, String clientSecret }) async
    test('test authenticateApiV1AuthLoginPost', () async {
      // TODO
    });

    // Confirm Pwd Reset
    //
    //Future<Object> confirmPwdResetApiV1AuthConfirmPasswordRestPost(String identificator, String newPassword, String code) async
    test('test confirmPwdResetApiV1AuthConfirmPasswordRestPost', () async {
      // TODO
    });

    // Create Google Account
    //
    //Future<GoogleAccountOut> createGoogleAccountApiV1AuthGoogleCreatePost(GoogleAccountCreate googleAccountCreate) async
    test('test createGoogleAccountApiV1AuthGoogleCreatePost', () async {
      // TODO
    });

    // Delete Google Account
    //
    //Future<Object> deleteGoogleAccountApiV1AuthGoogleDeleteIdentificatorDelete(String identificator) async
    test('test deleteGoogleAccountApiV1AuthGoogleDeleteIdentificatorDelete', () async {
      // TODO
    });

    // Get Google Account
    //
    //Future<GoogleAccountOut> getGoogleAccountApiV1AuthGoogleGetIdentificatorGet(String identificator) async
    test('test getGoogleAccountApiV1AuthGoogleGetIdentificatorGet', () async {
      // TODO
    });

    // Send Pwd Reset
    //
    //Future<Object> sendPwdResetApiV1AuthCallPasswordRestPost(String identificator) async
    test('test sendPwdResetApiV1AuthCallPasswordRestPost', () async {
      // TODO
    });

    // Update Google Account
    //
    //Future<GoogleAccountOut> updateGoogleAccountApiV1AuthGoogleUpdateIdentificatorPut(String identificator, GoogleAccountUpdate googleAccountUpdate) async
    test('test updateGoogleAccountApiV1AuthGoogleUpdateIdentificatorPut', () async {
      // TODO
    });

  });
}

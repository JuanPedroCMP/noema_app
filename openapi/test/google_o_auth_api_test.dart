import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for GoogleOAuthApi
void main() {
  final instance = Openapi().getGoogleOAuthApi();

  group(GoogleOAuthApi, () {
    // Google Oauth Callback
    //
    //Future<JsonObject> googleOauthCallbackApiV1AuthGoogleCallbackGet() async
    test('test googleOauthCallbackApiV1AuthGoogleCallbackGet', () async {
      // TODO
    });

    // Link Google Account
    //
    //Future<JsonObject> linkGoogleAccountApiV1AuthGoogleLinkGet() async
    test('test linkGoogleAccountApiV1AuthGoogleLinkGet', () async {
      // TODO
    });

  });
}

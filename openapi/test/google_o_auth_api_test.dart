import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for GoogleOAuthApi
void main() {
  final instance = Openapi().getGoogleOAuthApi();

  group(GoogleOAuthApi, () {
    // Retired Google Oauth Callback
    //
    //Future<JsonObject> retiredGoogleOauthCallbackApiV1AuthGoogleCallbackGet() async
    test('test retiredGoogleOauthCallbackApiV1AuthGoogleCallbackGet', () async {
      // TODO
    });

    // Retired Server Side Google Oauth
    //
    //Future<JsonObject> retiredServerSideGoogleOauthApiV1AuthGoogleLinkGet() async
    test('test retiredServerSideGoogleOauthApiV1AuthGoogleLinkGet', () async {
      // TODO
    });

  });
}

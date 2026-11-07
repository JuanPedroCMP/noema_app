import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for GoogleDriveOAuthApi
void main() {
  final instance = Openapi().getGoogleDriveOAuthApi();

  group(GoogleDriveOAuthApi, () {
    // Link a native Google authorization without storing its tokens
    //
    //Future<GoogleAccountStatusOut> googleAccountLinkApiV1GoogleDriveAccountLinkPost(GoogleAccountLinkRequest googleAccountLinkRequest) async
    test('test googleAccountLinkApiV1GoogleDriveAccountLinkPost', () async {
      // TODO
    });

    // Get Google account and Drive app-data authorization state
    //
    //Future<GoogleAccountStatusOut> googleAccountStatusApiV1GoogleDriveAccountStatusGet() async
    test('test googleAccountStatusApiV1GoogleDriveAccountStatusGet', () async {
      // TODO
    });

    // Re-check the currently linked Google authorization
    //
    //Future<GoogleAccountStatusOut> refreshGoogleStatusApiV1GoogleDriveAccountStatusRefreshPost(GoogleAccountLinkRequest googleAccountLinkRequest) async
    test('test refreshGoogleStatusApiV1GoogleDriveAccountStatusRefreshPost', () async {
      // TODO
    });

  });
}

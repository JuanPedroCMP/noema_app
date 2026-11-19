import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noema/feature/config/data/google_drive/google_android_oauth.dart';
import 'package:noema/feature/config/data/google_drive/google_drive_oauth.dart';

void main() {
  test('requires a Web server client ID before Android sign-in', () async {
    final client = GoogleAndroidOAuthClient(serverClientId: '');

    await expectLater(
      client.authorize(interactive: true),
      throwsA(
        isA<GoogleDriveOAuthException>().having(
          (error) => error.code,
          'code',
          'google_oauth_server_client_id_missing',
        ),
      ),
    );
  });

  test(
    'clears the cached Android token before forced scope authorization',
    () async {
      const scope = 'https://www.googleapis.com/auth/drive.appdata';
      final authorizationClient = _FakeAuthorizationClient();
      final client = GoogleAndroidOAuthClient(
        serverClientId: 'web-client-id',
        googleSignIn: _FakeGoogleSignIn(
          _FakeGoogleSignInAccount(authorizationClient),
        ),
      );

      final session = await client.authorize(
        interactive: true,
        forceInteractive: true,
      );

      expect(authorizationClient.clearedAccessToken, 'cached-access-token');
      expect(authorizationClient.requestedScopes, [scope]);
      expect(session.accessToken, 'fresh-access-token');
    },
  );
}

class _FakeGoogleSignIn extends Fake implements GoogleSignIn {
  _FakeGoogleSignIn(this.account);

  final GoogleSignInAccount account;

  @override
  Future<void> initialize({
    String? clientId,
    String? serverClientId,
    String? nonce,
    String? hostedDomain,
  }) async {}

  @override
  Future<GoogleSignInAccount> authenticate({
    List<String> scopeHint = const [],
  }) async => account;
}

class _FakeGoogleSignInAccount extends Fake implements GoogleSignInAccount {
  _FakeGoogleSignInAccount(this.authorizationClient);

  @override
  final GoogleSignInAuthorizationClient authorizationClient;

  @override
  String get email => 'reader@example.com';

  @override
  GoogleSignInAuthentication get authentication =>
      const GoogleSignInAuthentication(idToken: 'id-token');
}

class _FakeAuthorizationClient extends Fake
    implements GoogleSignInAuthorizationClient {
  String? clearedAccessToken;
  List<String>? requestedScopes;

  @override
  Future<GoogleSignInClientAuthorization?> authorizationForScopes(
    List<String> scopes,
  ) async =>
      const GoogleSignInClientAuthorization(accessToken: 'cached-access-token');

  @override
  Future<void> clearAuthorizationToken({required String accessToken}) async {
    clearedAccessToken = accessToken;
  }

  @override
  Future<GoogleSignInClientAuthorization> authorizeScopes(
    List<String> scopes,
  ) async {
    requestedScopes = scopes;
    return const GoogleSignInClientAuthorization(
      accessToken: 'fresh-access-token',
    );
  }
}

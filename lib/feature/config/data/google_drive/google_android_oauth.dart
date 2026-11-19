import 'package:google_sign_in/google_sign_in.dart';
import 'package:noema/feature/config/data/google_drive/google_drive_oauth.dart';

const _driveAppDataScope = 'https://www.googleapis.com/auth/drive.appdata';

class GoogleAndroidOAuthClient implements GoogleDriveOAuthClient {
  GoogleAndroidOAuthClient({
    required this.serverClientId,
    GoogleSignIn? googleSignIn,
  }) : _googleSignIn = googleSignIn ?? GoogleSignIn.instance;

  final String serverClientId;
  final GoogleSignIn _googleSignIn;
  Future<void>? _initialization;
  GoogleSignInAccount? _account;

  Future<void> _ensureInitialized() {
    if (serverClientId.isEmpty) {
      throw const GoogleDriveOAuthException(
        'Configure GOOGLE_OAUTH_SERVER_CLIENT_ID com o ID do cliente OAuth Web.',
        code: 'google_oauth_server_client_id_missing',
      );
    }
    return _initialization ??= _googleSignIn.initialize(
      serverClientId: serverClientId,
    );
  }

  @override
  Future<GoogleDriveOAuthSession> authorize({
    required bool interactive,
    bool forceInteractive = false,
  }) async {
    await _ensureInitialized();

    try {
      final account = interactive
          ? await _googleSignIn.authenticate()
          : _account ?? await _googleSignIn.attemptLightweightAuthentication();
      if (account == null) {
        throw const GoogleDriveOAuthException(
          'Conecte a conta Google neste dispositivo para sincronizar.',
          code: 'google_authorization_required',
        );
      }
      _account = account;

      GoogleSignInClientAuthorization? authorization;
      if (forceInteractive) {
        try {
          final previousAuthorization = await account.authorizationClient
              .authorizationForScopes(const [_driveAppDataScope]);
          if (previousAuthorization != null) {
            await account.authorizationClient.clearAuthorizationToken(
              accessToken: previousAuthorization.accessToken,
            );
          }
        } on GoogleSignInException {
          if (!interactive) rethrow;
        }
      } else {
        try {
          authorization = await account.authorizationClient
              .authorizationForScopes(const [_driveAppDataScope]);
        } on GoogleSignInException {
          if (!interactive) rethrow;
        }
      }
      authorization ??= interactive
          ? await account.authorizationClient.authorizeScopes(const [
              _driveAppDataScope,
            ])
          : null;
      if (authorization == null) {
        throw const GoogleDriveOAuthException(
          'A conta Google precisa autorizar o acesso privado do Noema. '
          'Conecte a conta novamente.',
          code: 'google_drive_scope_authorization_required',
        );
      }

      return GoogleDriveOAuthSession(
        email: account.email,
        idToken: account.authentication.idToken,
        accessToken: authorization.accessToken,
        expiresAt: DateTime.now().add(const Duration(hours: 1)),
      );
    } on GoogleDriveOAuthException {
      rethrow;
    } on GoogleSignInException catch (error) {
      throw _translateSignInError(error);
    }
  }

  @override
  Future<bool> revokeAndClear() async {
    await _ensureInitialized();
    try {
      _account ??= await _googleSignIn.attemptLightweightAuthentication();
      if (_account == null) return false;
      await _googleSignIn.disconnect();
      _account = null;
      return true;
    } on GoogleSignInException catch (error) {
      _account = null;
      throw _translateSignInError(error);
    }
  }

  GoogleDriveOAuthException _translateSignInError(GoogleSignInException error) {
    if (error.code == GoogleSignInExceptionCode.canceled) {
      return const GoogleDriveOAuthException(
        'A autorização Google foi cancelada.',
        code: 'google_sign_in_canceled',
      );
    }
    return GoogleDriveOAuthException(
      'O Google Sign-In falhou (${error.code.name}). '
      'Confira os IDs OAuth, o nome do pacote Android e o certificado SHA-1.',
      code: 'google_sign_in_failed',
    );
  }
}

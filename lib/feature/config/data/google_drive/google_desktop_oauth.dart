import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';
import 'dart:math';

import 'package:app_links/app_links.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:win32_registry/win32_registry.dart';

const _googleAuthorizationEndpoint =
    'https://accounts.google.com/o/oauth2/v2/auth';
const _googleTokenEndpoint = 'https://oauth2.googleapis.com/token';
const _googleRevokeEndpoint = 'https://oauth2.googleapis.com/revoke';
const _driveAppDataScope = 'https://www.googleapis.com/auth/drive.appdata';
const _desktopOAuthRedirectPath = '/oauth2redirect';
const _desktopRefreshTokenKey = 'google_drive_desktop_refresh_token';
const _desktopAccessTokenKey = 'google_drive_desktop_access_token';

void _logGoogleDesktopOAuth(
  String message, {
  Object? error,
  StackTrace? stackTrace,
}) {
  developer.log(
    message,
    name: 'GoogleDesktopOAuth',
    error: error,
    stackTrace: stackTrace,
  );
}

Uri googleDesktopOAuthRedirectUri(String clientId) => Uri(
  scheme:
      'com.googleusercontent.apps.${clientId.replaceFirst('.apps.googleusercontent.com', '')}',
  path: _desktopOAuthRedirectPath,
);

Future<String> resolveGoogleOAuthLinuxHandlerExecutable(
  String executablePath,
) async {
  const deletedSuffix = ' (deleted)';
  var resolvedPath = executablePath;
  if (resolvedPath.endsWith(deletedSuffix)) {
    final replacementPath = resolvedPath.substring(
      0,
      resolvedPath.length - deletedSuffix.length,
    );
    if (await File(replacementPath).exists()) {
      resolvedPath = replacementPath;
    }
  }
  if (!await File(resolvedPath).exists()) {
    throw const GoogleDesktopOAuthException(
      'O executável atual do Noema não está disponível para receber o retorno '
      'do navegador. Feche todas as instâncias, abra o Noema novamente e tente '
      'conectar a conta.',
      code: 'desktop_protocol_executable_unavailable',
    );
  }
  return resolvedPath;
}

class GoogleDesktopOAuthException implements Exception {
  const GoogleDesktopOAuthException(this.message, {this.code});

  final String message;
  final String? code;

  @override
  String toString() => message;
}

class GoogleDesktopOAuthSession {
  const GoogleDesktopOAuthSession({
    required this.email,
    required this.idToken,
    required this.accessToken,
    required this.expiresAt,
  });

  final String email;
  final String idToken;
  final String accessToken;
  final DateTime expiresAt;
}

class GoogleDesktopOAuthClient {
  GoogleDesktopOAuthClient({
    required this.clientId,
    required this.clientSecret,
    FlutterSecureStorage? storage,
    Dio? dio,
  }) : _storage = storage ?? const FlutterSecureStorage(),
       _dio = dio ?? Dio();

  final String clientId;
  final String clientSecret;
  final FlutterSecureStorage _storage;
  final Dio _dio;
  GoogleDesktopOAuthSession? _session;

  Future<GoogleDesktopOAuthSession> authorize({
    required bool interactive,
    bool forceInteractive = false,
  }) async {
    _logGoogleDesktopOAuth(
      'Authorization started (interactive=$interactive, '
      'forceInteractive=$forceInteractive, clientIdConfigured=${clientId.isNotEmpty}, '
      'clientSecretConfigured=${clientSecret.isNotEmpty}).',
    );
    if (clientSecret.isEmpty) {
      _logGoogleDesktopOAuth(
        'Authorization stopped: client secret is missing.',
      );
      throw const GoogleDesktopOAuthException(
        'Este build não tem o client_secret do cliente OAuth desktop. '
        'Configure GOOGLE_OAUTH_DESKTOP_CLIENT_SECRET em '
        'config/google_oauth_desktop.json e reinicie o app.',
        code: 'google_oauth_desktop_client_secret_missing',
      );
    }

    final session = _session;
    if (!forceInteractive &&
        session != null &&
        session.expiresAt.isAfter(
          DateTime.now().add(const Duration(seconds: 30)),
        )) {
      _logGoogleDesktopOAuth('Using an unexpired in-memory session.');
      return session;
    }

    if (!forceInteractive) {
      final refreshToken = await _storage.read(key: _desktopRefreshTokenKey);
      _logGoogleDesktopOAuth(
        'Stored refresh token ${refreshToken == null || refreshToken.isEmpty ? "not found" : "found"}.',
      );
      if (refreshToken != null && refreshToken.isNotEmpty) {
        try {
          final refreshed = await _refresh(refreshToken);
          _session = refreshed;
          _logGoogleDesktopOAuth('Authorization refreshed successfully.');
          return refreshed;
        } on GoogleDesktopOAuthException catch (error) {
          _logGoogleDesktopOAuth(
            'Refresh failed (code=${error.code ?? "unknown"}): ${error.message}',
            error: error,
          );
          if (error.code != 'invalid_grant' &&
              error.code != 'id_token_missing') {
            rethrow;
          }
          if (error.code == 'invalid_grant') {
            await _storage.delete(key: _desktopRefreshTokenKey);
          }
        }
      }
    }

    if (!interactive) {
      _logGoogleDesktopOAuth(
        'No usable session or refresh token; interactive authorization is disabled.',
      );
      throw const GoogleDesktopOAuthException(
        'Conecte a conta Google para autorizar o acesso privado do Noema.',
        code: 'desktop_authorization_required',
      );
    }
    return _authorizeInBrowser();
  }

  Future<void> revokeAndClear() async {
    final token =
        await _storage.read(key: _desktopRefreshTokenKey) ??
        await _storage.read(key: _desktopAccessTokenKey);
    try {
      if (token != null && token.isNotEmpty) {
        await _dio.post<void>(
          _googleRevokeEndpoint,
          data: <String, String>{'token': token},
          options: Options(
            contentType: Headers.formUrlEncodedContentType,
            responseType: ResponseType.plain,
          ),
        );
      }
    } on DioException {
      throw const GoogleDesktopOAuthException(
        'O Google não confirmou a revogação da autorização. O token local '
        'foi removido; se necessário, remova o acesso do Noema na sua Conta Google.',
        code: 'desktop_token_revoke_failed',
      );
    } finally {
      _session = null;
      await Future.wait([
        _storage.delete(key: _desktopRefreshTokenKey),
        _storage.delete(key: _desktopAccessTokenKey),
      ]);
    }
  }

  Future<GoogleDesktopOAuthSession> _authorizeInBrowser() async {
    _logGoogleDesktopOAuth('Starting browser authorization.');
    await _ensureProtocolRegistered();
    final redirectUri = googleDesktopOAuthRedirectUri(clientId);
    final scheme = redirectUri.scheme;
    final state = _randomUrlSafe(32);
    final nonce = _randomUrlSafe(32);
    final verifier = _randomUrlSafe(64);
    final challenge = base64Url
        .encode(sha256.convert(ascii.encode(verifier)).bytes)
        .replaceAll('=', '');
    final authorizationUri = Uri.parse(_googleAuthorizationEndpoint).replace(
      queryParameters: <String, String>{
        'client_id': clientId,
        'redirect_uri': redirectUri.toString(),
        'response_type': 'code',
        'scope': 'openid email $_driveAppDataScope',
        'state': state,
        'nonce': nonce,
        'code_challenge': challenge,
        'code_challenge_method': 'S256',
        'access_type': 'offline',
        'prompt': 'consent',
      },
    );
    final callback = Completer<String>();
    final appLinks = AppLinks();

    void handleRedirect(Uri uri) {
      if (uri.scheme != scheme || uri.path != _desktopOAuthRedirectPath) {
        return;
      }
      if (callback.isCompleted) {
        _logGoogleDesktopOAuth('Ignoring duplicate OAuth redirect.');
        return;
      }
      if (uri.queryParameters['state'] != state) {
        _logGoogleDesktopOAuth(
          'Ignoring OAuth redirect with mismatched state.',
        );
        return;
      }

      final error = uri.queryParameters['error'];
      final code = uri.queryParameters['code'];
      if (error != null) {
        _logGoogleDesktopOAuth(
          'Google returned an authorization error: $error.',
        );
        callback.completeError(
          GoogleDesktopOAuthException(
            error == 'access_denied'
                ? 'A autorização Google foi cancelada. Nenhuma alteração foi feita.'
                : 'O Google não concluiu a autorização desktop.',
            code: error == 'access_denied'
                ? 'google_sign_in_canceled'
                : 'desktop_authorization_failed',
          ),
        );
      } else if (code != null && code.isNotEmpty) {
        _logGoogleDesktopOAuth(
          'Received OAuth redirect with authorization code.',
        );
        callback.complete(code);
      } else {
        _logGoogleDesktopOAuth(
          'OAuth redirect did not contain a code or error.',
        );
        callback.completeError(
          const GoogleDesktopOAuthException(
            'O Google não retornou um código de autorização.',
            code: 'desktop_authorization_code_missing',
          ),
        );
      }
    }

    StreamSubscription<Uri>? subscription;

    try {
      subscription = appLinks.uriLinkStream.listen(
        handleRedirect,
        onError: (Object error, StackTrace stackTrace) {
          if (!callback.isCompleted) {
            callback.completeError(
              _redirectListenerException(error),
              stackTrace,
            );
          }
        },
      );
      final initialLink = await appLinks.getInitialLink();
      if (initialLink != null) handleRedirect(initialLink);
      final opened = await launchUrl(
        authorizationUri,
        mode: LaunchMode.externalApplication,
      );
      if (!opened) {
        _logGoogleDesktopOAuth('Failed to launch the system browser.');
        throw const GoogleDesktopOAuthException(
          'Não foi possível abrir o navegador padrão para autorizar o Google.',
          code: 'desktop_browser_unavailable',
        );
      }
      final code = await callback.future.timeout(
        const Duration(minutes: 5),
        onTimeout: () => throw const GoogleDesktopOAuthException(
          'A autorização Google expirou. Para Linux/Windows, confirme que '
          'GOOGLE_OAUTH_DESKTOP_CLIENT_ID pertence ao cliente OAuth do tipo '
          'Desktop app e tente novamente.',
          code: 'desktop_authorization_timeout',
        ),
      );
      _logGoogleDesktopOAuth('Exchanging authorization code for tokens.');
      final response = await _dio.post<Map<String, dynamic>>(
        _googleTokenEndpoint,
        data: <String, String>{
          'client_id': clientId,
          'client_secret': clientSecret,
          'code': code,
          'code_verifier': verifier,
          'grant_type': 'authorization_code',
          'redirect_uri': redirectUri.toString(),
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          responseType: ResponseType.json,
        ),
      );
      final data = response.data;
      if (data == null) {
        throw const GoogleDesktopOAuthException(
          'O Google não retornou os tokens de autorização.',
          code: 'desktop_token_response_empty',
        );
      }
      final session = _parseTokenResponse(data, expectedNonce: nonce);
      await _storage.write(
        key: _desktopAccessTokenKey,
        value: session.accessToken,
      );
      final refreshToken = data['refresh_token'];
      if (refreshToken is String && refreshToken.isNotEmpty) {
        await _storage.write(key: _desktopRefreshTokenKey, value: refreshToken);
      }
      _session = session;
      _logGoogleDesktopOAuth(
        'Browser authorization succeeded '
        '(refreshTokenReturned=${refreshToken is String && refreshToken.isNotEmpty}, '
        'expiresAt=${session.expiresAt.toIso8601String()}).',
      );
      return session;
    } on MissingPluginException {
      _logGoogleDesktopOAuth('Deep-link plugin is unavailable.');
      throw _missingDesktopLinkPluginException();
    } on DioException catch (error) {
      _logGoogleDesktopOAuth(
        'Authorization-code exchange failed '
        '(httpStatus=${error.response?.statusCode}, '
        'googleError=${_googleErrorCode(error.response?.data)}, '
        'description=${_googleErrorDescription(error.response?.data)}).',
        stackTrace: error.stackTrace,
      );
      throw GoogleDesktopOAuthException(
        googleOAuthTokenExchangeErrorMessage(
          statusCode: error.response?.statusCode,
          responseData: error.response?.data,
        ),
        code: 'desktop_token_exchange_failed',
      );
    } finally {
      if (subscription != null) {
        try {
          await subscription.cancel();
        } on MissingPluginException {
          // Keep the actionable setup error from the unavailable plugin.
        }
      }
    }
  }

  GoogleDesktopOAuthException _redirectListenerException(Object error) {
    if (error is MissingPluginException) {
      return _missingDesktopLinkPluginException();
    }
    return GoogleDesktopOAuthException(
      'O app não recebeu o retorno do navegador. Confira o registro '
      'do protocolo do sistema. Detalhe: ${error.runtimeType}.',
      code: 'desktop_redirect_listener_failed',
    );
  }

  GoogleDesktopOAuthException _missingDesktopLinkPluginException() =>
      const GoogleDesktopOAuthException(
        'Esta compilação não contém o plugin nativo de links do Noema. '
        'Feche todas as instâncias e faça uma compilação nativa completa '
        '(não apenas hot reload): `flutter clean` e depois `flutter run`.',
        code: 'desktop_deep_link_plugin_missing',
      );

  String get _redirectScheme => googleDesktopOAuthRedirectUri(clientId).scheme;

  Future<void> _ensureProtocolRegistered() async {
    try {
      if (Platform.isWindows) {
        _logGoogleDesktopOAuth('Registering OAuth return protocol on Windows.');
        _registerWindowsProtocol();
      } else if (Platform.isLinux) {
        _logGoogleDesktopOAuth('Registering OAuth return protocol on Linux.');
        await _registerLinuxProtocol();
      }
    } on Object catch (error) {
      _logGoogleDesktopOAuth(
        'OAuth return protocol registration failed.',
        error: error,
        stackTrace: StackTrace.current,
      );
      if (error is GoogleDesktopOAuthException) rethrow;
      throw GoogleDesktopOAuthException(
        'Não foi possível registrar o retorno da autorização no sistema. '
        'Confira as permissões do usuário e tente novamente. '
        'Detalhe: ${error.runtimeType}.',
        code: 'desktop_protocol_registration_failed',
      );
    }
  }

  Future<void> _registerLinuxProtocol() async {
    final home = Platform.environment['HOME'];
    if (home == null || home.isEmpty) {
      throw const GoogleDesktopOAuthException(
        'O sistema não informou a pasta pessoal para registrar o retorno OAuth.',
        code: 'desktop_protocol_registration_failed',
      );
    }
    final dataHome = Platform.environment['XDG_DATA_HOME'];
    final applications = Directory(
      '${dataHome == null || dataHome.isEmpty ? '$home/.local/share' : dataHome}/applications',
    );
    await applications.create(recursive: true);
    final desktopFileName = 'noema-google-oauth-$_redirectScheme.desktop';
    final executable = (await resolveGoogleOAuthLinuxHandlerExecutable(
      Platform.resolvedExecutable,
    )).replaceAll('\\', '\\\\').replaceAll('"', '\\"').replaceAll('%', '%%');
    await File('${applications.path}/$desktopFileName').writeAsString(
      '[Desktop Entry]\n'
      'Type=Application\n'
      'Name=Noema Google OAuth\n'
      'Exec="$executable" %u\n'
      'Terminal=false\n'
      'NoDisplay=true\n'
      'MimeType=x-scheme-handler/$_redirectScheme;\n',
      flush: true,
    );
    late final ProcessResult result;
    try {
      result = await Process.run('xdg-mime', [
        'default',
        desktopFileName,
        'x-scheme-handler/$_redirectScheme',
      ]);
    } on ProcessException {
      throw const GoogleDesktopOAuthException(
        'O Linux não encontrou xdg-mime. Instale o pacote xdg-utils e tente '
        'novamente.',
        code: 'desktop_protocol_registration_failed',
      );
    }
    if (result.exitCode != 0) {
      throw const GoogleDesktopOAuthException(
        'O Linux não conseguiu registrar o protocolo Google OAuth. '
        'Instale/ative xdg-utils e tente novamente.',
        code: 'desktop_protocol_registration_failed',
      );
    }
  }

  void _registerWindowsProtocol() {
    final protocolKey = CURRENT_USER.create(
      'Software\\Classes\\$_redirectScheme',
    );
    try {
      protocolKey
        ..setValue(
          '',
          const RegistryValue.string('URL: Noema Google OAuth Protocol'),
        )
        ..setValue('URL Protocol', const RegistryValue.string(''));
      final commandKey = protocolKey.create('shell\\open\\command');
      try {
        commandKey.setValue(
          '',
          RegistryValue.string('"${Platform.resolvedExecutable}" "%1"'),
        );
      } finally {
        commandKey.close();
      }
    } finally {
      protocolKey.close();
    }
  }

  Future<GoogleDesktopOAuthSession> _refresh(String refreshToken) async {
    try {
      _logGoogleDesktopOAuth('Sending refresh-token request to Google.');
      final response = await _dio.post<Map<String, dynamic>>(
        _googleTokenEndpoint,
        data: <String, String>{
          'client_id': clientId,
          'client_secret': clientSecret,
          'grant_type': 'refresh_token',
          'refresh_token': refreshToken,
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          responseType: ResponseType.json,
        ),
      );
      final data = response.data;
      if (data == null) {
        throw const GoogleDesktopOAuthException(
          'O Google não retornou a renovação da autorização desktop.',
          code: 'desktop_token_response_empty',
        );
      }
      final session = _parseTokenResponse(data);
      await _storage.write(
        key: _desktopAccessTokenKey,
        value: session.accessToken,
      );
      final rotatedRefreshToken = data['refresh_token'];
      if (rotatedRefreshToken is String && rotatedRefreshToken.isNotEmpty) {
        await _storage.write(
          key: _desktopRefreshTokenKey,
          value: rotatedRefreshToken,
        );
      }
      _session = session;
      _logGoogleDesktopOAuth(
        'Google refresh-token request succeeded '
        '(expiresAt=${session.expiresAt.toIso8601String()}, '
        'refreshTokenRotated=${rotatedRefreshToken is String && rotatedRefreshToken.isNotEmpty}).',
      );
      return session;
    } on DioException catch (error) {
      final responseData = error.response?.data;
      final responseCode = _googleErrorCode(responseData);
      _logGoogleDesktopOAuth(
        'Google refresh-token request failed '
        '(httpStatus=${error.response?.statusCode}, '
        'googleError=${responseCode ?? "unknown"}, '
        'description=${_googleErrorDescription(responseData)}).',
        stackTrace: error.stackTrace,
      );
      if (responseCode == 'invalid_grant') {
        await Future.wait([
          _storage.delete(key: _desktopRefreshTokenKey),
          _storage.delete(key: _desktopAccessTokenKey),
        ]);
        throw const GoogleDesktopOAuthException(
          'A autorização Google desktop expirou ou foi revogada.',
          code: 'invalid_grant',
        );
      }
      throw const GoogleDesktopOAuthException(
        'Não foi possível renovar a autorização Google desktop. '
        'Verifique a conexão e tente novamente.',
        code: 'desktop_token_refresh_failed',
      );
    }
  }

  GoogleDesktopOAuthSession _parseTokenResponse(
    Map<String, dynamic> data, {
    String? expectedNonce,
  }) {
    final accessToken = data['access_token'];
    final idToken = data['id_token'];
    final expiresIn = data['expires_in'];
    if (accessToken is! String || accessToken.isEmpty) {
      throw const GoogleDesktopOAuthException(
        'O Google não retornou um token de acesso ao Drive.',
        code: 'desktop_access_token_missing',
      );
    }
    if (idToken is! String || idToken.isEmpty) {
      throw const GoogleDesktopOAuthException(
        'O Google não retornou um ID token válido. Reautorize a conta.',
        code: 'id_token_missing',
      );
    }
    if (expiresIn is! num || expiresIn <= 0) {
      throw const GoogleDesktopOAuthException(
        'O Google retornou um prazo inválido para o token de acesso.',
        code: 'desktop_token_expiry_invalid',
      );
    }
    final claims = decodeGoogleOAuthIdTokenClaims(idToken);
    final audience = claims['aud'];
    final audienceMatches =
        audience == clientId ||
        (audience is List<dynamic> && audience.contains(clientId));
    final expiration = claims['exp'];
    final email = claims['email'];
    final issuer = claims['iss'];
    final returnedNonce = claims['nonce'];
    if (!audienceMatches ||
        expiration is! num ||
        expiration <= DateTime.now().millisecondsSinceEpoch ~/ 1000 ||
        email is! String ||
        email.isEmpty ||
        (issuer != 'https://accounts.google.com' &&
            issuer != 'accounts.google.com') ||
        (expectedNonce != null && returnedNonce != expectedNonce)) {
      _logGoogleDesktopOAuth(
        'ID-token validation failed '
        '(audienceMatches=$audienceMatches, '
        'expirationValid=${expiration is num && expiration > DateTime.now().millisecondsSinceEpoch ~/ 1000}, '
        'emailPresent=${email is String && email.isNotEmpty}, '
        'issuerValid=${issuer == "https://accounts.google.com" || issuer == "accounts.google.com"}, '
        'nonceMatches=${expectedNonce == null || returnedNonce == expectedNonce}).',
      );
      throw const GoogleDesktopOAuthException(
        'A resposta de identidade do Google não corresponde ao cliente desktop configurado.',
        code: 'desktop_id_token_invalid',
      );
    }
    return GoogleDesktopOAuthSession(
      email: email,
      idToken: idToken,
      accessToken: accessToken,
      expiresAt: DateTime.now().add(Duration(seconds: expiresIn.toInt())),
    );
  }

  String _randomUrlSafe(int byteCount) {
    final random = Random.secure();
    final bytes = List<int>.generate(byteCount, (_) => random.nextInt(256));
    return base64Url.encode(bytes).replaceAll('=', '');
  }
}

String? _googleErrorCode(Object? responseData) {
  if (responseData is Map) {
    final error = responseData['error'];
    if (error is String) return error;
    if (error is Map && error['status'] is String) {
      return error['status'] as String;
    }
  }
  return null;
}

String _googleErrorDescription(Object? responseData) {
  if (responseData is Map) {
    final description =
        responseData['error_description'] ?? responseData['error'];
    if (description is String) {
      final sanitized = description.replaceAll(RegExp(r'[\r\n]'), ' ');
      return sanitized.substring(
        0,
        sanitized.length > 240 ? 240 : sanitized.length,
      );
    }
    if (description is Map && description['message'] is String) {
      final message = (description['message'] as String).replaceAll(
        RegExp(r'[\r\n]'),
        ' ',
      );
      return message.substring(0, message.length > 240 ? 240 : message.length);
    }
  }
  return 'not provided';
}

String googleOAuthTokenExchangeErrorMessage({
  required int? statusCode,
  required Object? responseData,
}) {
  final payload = switch (responseData) {
    final Map data => data,
    String body => _decodeGoogleOAuthErrorBody(body),
    _ => null,
  };
  final error = payload?['error'];
  final description = payload?['error_description'];
  final detail = description is String
      ? description.replaceAll(RegExp(r'[\x00-\x1F\x7F]'), ' ').trim()
      : null;
  final safeDetail = detail == null || detail.isEmpty
      ? null
      : detail.substring(0, min(detail.length, 240));

  final message = switch (error) {
    'invalid_grant' =>
      'O Google rejeitou o código de autorização. Ele pode ter expirado ou '
          'o redirect/PKCE não corresponde à solicitação. Inicie o vínculo '
          'novamente.',
    'invalid_client' || 'unauthorized_client' =>
      'O Google não reconheceu o cliente OAuth desktop. Confirme se o ID '
          'configurado pertence ao cliente Desktop app correto.',
    'redirect_uri_mismatch' =>
      'O redirect URI enviado ao Google não corresponde ao cliente OAuth '
          'desktop configurado.',
    'invalid_request'
        when description?.toString().toLowerCase().contains('client_secret') ??
            false =>
      'O Google não aceitou o client_secret do cliente OAuth desktop. Confira '
          'config/google_oauth_desktop.json e tente conectar novamente.',
    'invalid_request' =>
      'O Google recusou a troca do código por tokens por causa de parâmetros '
          'inválidos.',
    _ when statusCode == null =>
      'Não foi possível alcançar o serviço OAuth do Google. Verifique a '
          'conexão e tente novamente.',
    _ =>
      'O Google não concluiu a troca do código por tokens'
          '${error is String && error.isNotEmpty ? ' ($error)' : ''}'
          ' (HTTP $statusCode).',
  };

  return safeDetail == null
      ? message
      : '$message Detalhe informado pelo Google: $safeDetail';
}

Map<String, dynamic>? _decodeGoogleOAuthErrorBody(String body) {
  try {
    final decoded = jsonDecode(body);
    return decoded is Map<String, dynamic> ? decoded : null;
  } on FormatException {
    return null;
  }
}

Map<String, dynamic> decodeGoogleOAuthIdTokenClaims(String idToken) {
  final parts = idToken.split('.');
  if (parts.length != 3) {
    throw const GoogleDesktopOAuthException(
      'O Google retornou um ID token malformado.',
      code: 'desktop_id_token_invalid',
    );
  }
  try {
    final payload = utf8.decode(
      base64Url.decode(base64Url.normalize(parts[1])),
    );
    final claims = jsonDecode(payload);
    if (claims is! Map<String, dynamic>) {
      throw const FormatException('ID token payload must be an object');
    }
    return claims;
  } on FormatException {
    throw const GoogleDesktopOAuthException(
      'O Google retornou um ID token malformado.',
      code: 'desktop_id_token_invalid',
    );
  }
}

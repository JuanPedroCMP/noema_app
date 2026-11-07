import 'dart:io';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:noema/feature/config/data/google_drive/google_desktop_oauth.dart';

void main() {
  test(
    'recovers Linux OAuth handler path after a rebuild replaces the binary',
    () async {
      final directory = await Directory.systemTemp.createTemp(
        'noema-oauth-handler-',
      );
      try {
        final executable = File('${directory.path}/noema');
        await executable.writeAsString('test executable');

        expect(
          await resolveGoogleOAuthLinuxHandlerExecutable(
            '${executable.path} (deleted)',
          ),
          executable.path,
        );
      } finally {
        await directory.delete(recursive: true);
      }
    },
  );

  test('rejects a missing Linux OAuth handler executable', () async {
    await expectLater(
      resolveGoogleOAuthLinuxHandlerExecutable(
        '${Directory.systemTemp.path}/noema-oauth-missing',
      ),
      throwsA(
        isA<GoogleDesktopOAuthException>().having(
          (error) => error.code,
          'code',
          'desktop_protocol_executable_unavailable',
        ),
      ),
    );
  });

  test('uses the client-derived custom URI scheme for Desktop OAuth', () {
    final redirect = googleDesktopOAuthRedirectUri(
      '537909677706-c7kff7tsbfhrhbvnn3ipnnor6b8rqhq8.apps.googleusercontent.com',
    );

    expect(
      redirect.scheme,
      'com.googleusercontent.apps.537909677706-c7kff7tsbfhrhbvnn3ipnnor6b8rqhq8',
    );
    expect(redirect.path, '/oauth2redirect');
    expect(redirect.toString(), endsWith(':/oauth2redirect'));
  });

  test('explains OAuth token exchange errors returned by Google', () {
    final message = googleOAuthTokenExchangeErrorMessage(
      statusCode: 400,
      responseData: {
        'error': 'invalid_grant',
        'error_description': 'Code was already redeemed.',
      },
    );

    expect(message, contains('código de autorização'));
    expect(message, contains('Code was already redeemed.'));
  });

  test('reports network errors without inventing a Google response', () {
    final message = googleOAuthTokenExchangeErrorMessage(
      statusCode: null,
      responseData: null,
    );

    expect(message, contains('alcançar o serviço OAuth do Google'));
    expect(message, isNot(contains('HTTP')));
  });

  test(
    'points to desktop OAuth config when Google requires a client secret',
    () {
      final message = googleOAuthTokenExchangeErrorMessage(
        statusCode: 400,
        responseData: {
          'error': 'invalid_request',
          'error_description': 'client_secret is missing',
        },
      );

      expect(message, contains('config/google_oauth_desktop.json'));
      expect(message, contains('tente conectar novamente'));
    },
  );

  group('decodeGoogleOAuthIdTokenClaims', () {
    test('decodes an ID token payload for local claim checks', () {
      final payload = base64Url
          .encode(
            utf8.encode(
              jsonEncode({
                'aud': 'desktop-client-id',
                'email': 'user@example.com',
                'exp': 1_900_000_000,
              }),
            ),
          )
          .replaceAll('=', '');
      final token = 'header.$payload.signature';

      expect(
        decodeGoogleOAuthIdTokenClaims(token),
        containsPair('email', 'user@example.com'),
      );
    });

    test('rejects a malformed ID token', () {
      expect(
        () => decodeGoogleOAuthIdTokenClaims('not-a-jwt'),
        throwsA(isA<GoogleDesktopOAuthException>()),
      );
    });
  });
}

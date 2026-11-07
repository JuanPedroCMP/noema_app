import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noema/core/design/theme/app_theme.dart';
import 'package:noema/feature/config/data/google_drive/google_drive_sync_service.dart';
import 'package:noema/feature/config/presentation/google_account_section.dart';
import 'package:openapi/openapi.dart';

void main() {
  test('explains that Google OAuth must be configured on the backend', () {
    final message = googleDriveOperationErrorMessage(
      DioException(
        requestOptions: RequestOptions(
          path: '/api/v1/google_drive/account/link',
        ),
        response: Response(
          requestOptions: RequestOptions(
            path: '/api/v1/google_drive/account/link',
          ),
          statusCode: 503,
          data: {
            'detail': {
              'code': 'google_oauth_not_configured',
              'message': 'Google OAuth client IDs are not configured.',
              'missing_configuration': ['GOOGLE_OAUTH_CLIENT_SECRET'],
            },
          },
        ),
      ),
    );

    expect(message, contains('GOOGLE_OAUTH_CLIENT_SECRET'));
    expect(message, contains('configuração do servidor'));
    expect(message, contains('API'));
  });

  testWidgets('keeps the Google account section usable in a short window', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(484, 387);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          googleDriveSyncServiceProvider.overrideWith(
            (ref) => _UnavailableGoogleDriveService(),
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.create(
            seedColor: 0xFF6750A4,
            brightness: Brightness.dark,
            displayWidth: 484,
          ),
          home: const Scaffold(
            body: SingleChildScrollView(child: GoogleAccountSection()),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('GOOGLE_OAUTH_CLIENT_SECRET'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('offers connect rather than repair for a retained unlinked row', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(484, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          googleDriveSyncServiceProvider.overrideWith(
            (ref) => _UnlinkedGoogleDriveService(),
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.create(
            seedColor: 0xFF6750A4,
            brightness: Brightness.dark,
            displayWidth: 484,
          ),
          home: const Scaffold(
            body: SingleChildScrollView(child: GoogleAccountSection()),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Conectar Google'), findsOneWidget);
    expect(find.text('Corrigir autorização'), findsNothing);
    expect(find.text('Desvincular'), findsNothing);
    expect(find.textContaining('Tente renovar a autorização'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}

class _UnavailableGoogleDriveService extends Fake
    implements GoogleDriveSyncService {
  @override
  Future<GoogleAccountStatusOut> getAccountStatus() {
    throw DioException(
      requestOptions: RequestOptions(
        path: '/api/v1/google_drive/account/status',
      ),
      response: Response(
        requestOptions: RequestOptions(
          path: '/api/v1/google_drive/account/status',
        ),
        statusCode: 503,
        data: {
          'detail': {
            'code': 'google_oauth_not_configured',
            'message': 'Google OAuth client IDs are not configured.',
            'missing_configuration': ['GOOGLE_OAUTH_CLIENT_SECRET'],
          },
        },
      ),
    );
  }
}

class _UnlinkedGoogleDriveService extends Fake
    implements GoogleDriveSyncService {
  @override
  Future<GoogleAccountStatusOut> getAccountStatus() async =>
      GoogleAccountStatusOut(
        (builder) => builder
          ..accountId = 'retained-account-id'
          ..state = GoogleAccountStatusOutStateEnum.notLinked
          ..driveAppdataGranted = false
          ..syncAvailable = false
          ..error =
              GoogleAccountStatusOutErrorEnum.googleAuthorizationUnverified,
      );

  @override
  Future<List<BackupFileOut>> listBackups(String accountId) async => [];

  @override
  Future<List<SyncLogOut>> listSyncHistory(String accountId) async => [];
}

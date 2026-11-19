import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noema/core/design/theme/app_theme.dart';
import 'package:noema/feature/config/data/google_drive/google_drive_sync_service.dart';
import 'package:noema/feature/config/presentation/google_account_section.dart';
import 'package:openapi/openapi.dart';

void main() {
  test(
    'explains that OAuth audience IDs must be configured on the backend',
    () {
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
                'missing_configuration': ['GOOGLE_OAUTH_CLIENT_IDS'],
              },
            },
          ),
        ),
      );

      expect(message, contains('GOOGLE_OAUTH_CLIENT_IDS'));
      expect(message, contains('configuração da API'));
      expect(message, contains('API'));
    },
  );

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

    expect(find.textContaining('GOOGLE_OAUTH_CLIENT_IDS'), findsOneWidget);
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

  testWidgets(
    'allows renewing authorization without unlinking a connected account',
    (tester) async {
      tester.view.physicalSize = const Size(484, 640);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final service = _ConnectedGoogleDriveService();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            googleDriveSyncServiceProvider.overrideWith((ref) => service),
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
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Renovar autorização'), findsOneWidget);
      await tester.tap(find.text('Renovar autorização'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(service.reauthorizationRequested, isTrue);
      expect(service.unlinkRequested, isFalse);
      expect(tester.takeException(), isNull);
    },
  );
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
            'missing_configuration': ['GOOGLE_OAUTH_CLIENT_IDS'],
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

class _ConnectedGoogleDriveService extends Fake
    implements GoogleDriveSyncService {
  bool reauthorizationRequested = false;
  bool unlinkRequested = false;

  GoogleAccountStatusOut _connectedStatus() => GoogleAccountStatusOut(
    (builder) => builder
      ..accountId = 'connected-account-id'
      ..googleEmail = 'reader@example.com'
      ..state = GoogleAccountStatusOutStateEnum.granted
      ..driveAppdataGranted = true
      ..syncAvailable = true,
  );

  @override
  Future<GoogleAccountStatusOut> getAccountStatus() async => _connectedStatus();

  @override
  Future<GoogleAccountStatusOut> repairGoogleAuthorization() async {
    reauthorizationRequested = true;
    return _connectedStatus();
  }

  @override
  Future<bool> unlinkGoogleAccount(String accountId) async {
    unlinkRequested = true;
    return true;
  }

  @override
  Future<List<BackupFileOut>> listBackups(String accountId) async => [];

  @override
  Future<List<SyncLogOut>> listSyncHistory(String accountId) async => [];
}

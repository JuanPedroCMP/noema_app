import 'dart:io';

import 'package:noema/feature/config/data/google_drive/google_android_oauth.dart';
import 'package:noema/feature/config/data/google_drive/google_desktop_oauth.dart';
import 'package:noema/feature/config/data/google_drive/google_drive_oauth.dart';

GoogleDriveOAuthClient createGoogleDriveOAuthClient() {
  if (Platform.isAndroid) {
    return GoogleAndroidOAuthClient(
      serverClientId: const String.fromEnvironment(
        'GOOGLE_OAUTH_SERVER_CLIENT_ID',
      ),
    );
  }
  if (Platform.isLinux || Platform.isWindows) {
    return GoogleDesktopOAuthClient(
      clientId: const String.fromEnvironment('GOOGLE_OAUTH_DESKTOP_CLIENT_ID'),
      clientSecret: const String.fromEnvironment(
        'GOOGLE_OAUTH_DESKTOP_CLIENT_SECRET',
      ),
    );
  }
  throw const GoogleDriveOAuthException(
    'A sincronização Google está configurada para Android, Linux e Windows.',
    code: 'google_oauth_platform_unsupported',
  );
}

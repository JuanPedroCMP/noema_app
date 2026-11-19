class GoogleDriveOAuthException implements Exception {
  const GoogleDriveOAuthException(this.message, {this.code});

  final String message;
  final String? code;

  @override
  String toString() => message;
}

class GoogleDriveOAuthSession {
  const GoogleDriveOAuthSession({
    required this.email,
    required this.idToken,
    required this.accessToken,
    required this.expiresAt,
  });

  final String? email;
  final String? idToken;
  final String accessToken;
  final DateTime expiresAt;
}

abstract interface class GoogleDriveOAuthClient {
  Future<GoogleDriveOAuthSession> authorize({
    required bool interactive,
    bool forceInteractive = false,
  });

  Future<bool> revokeAndClear();
}

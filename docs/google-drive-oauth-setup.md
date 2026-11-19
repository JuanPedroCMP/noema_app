# Google Drive OAuth setup

The app transfers snapshot bytes directly between the device and Google Drive.
Android uses native Google Sign-In; Linux and Windows use the system browser
with OAuth authorization code + PKCE. The Noema API verifies the account link
and stores backup metadata, but never receives snapshot bytes.

## Google Cloud setup

Use one Google Cloud project for all OAuth clients:

1. Enable the **Google Drive API**.
2. Configure the OAuth consent screen and add test users while the app is in
   testing.
3. Request only the private app-data scope:
   `https://www.googleapis.com/auth/drive.appdata`.
4. Create these OAuth clients:
   - **Android**: use the exact Android application ID and signing certificate
     SHA-1 fingerprints for every build type you distribute.
   - **Web application**: used as `GOOGLE_OAUTH_SERVER_CLIENT_ID` by Android
     Google Sign-In to issue an ID token for the backend.
   - **Desktop app**: used by the Linux/Windows browser flow.

The current Android `applicationId` is `com.example.noema` in
`android/app/build.gradle.kts`. It is still the Flutter template value. Before
publishing, replace it with the app's permanent reverse-domain package name,
then register that exact value in Google Cloud. To get local signing
fingerprints, run `cd android && ./gradlew signingReport`; also register the
release signing SHA-1 used for distribution.

No `google-services.json` is required by this app's Android sign-in
configuration: it passes the Web client ID as `serverClientId`. The Android
OAuth client itself is selected by the installed app's package name and
signing certificate.

## Flutter app configuration

For Android, copy
`config/google_oauth_android.example.json` to
`config/google_oauth_android.json` and set the Web application client ID:

```json
{
  "GOOGLE_OAUTH_SERVER_CLIENT_ID": "<WEB_CLIENT_ID>.apps.googleusercontent.com"
}
```

Run the `Noema (Google OAuth Android)` VS Code configuration, or pass
`--dart-define-from-file=config/google_oauth_android.json` to Flutter.
The Android OAuth client ID is not a Dart define; Google matches it from the
package name and signing certificate.

For Linux/Windows, copy
`config/google_oauth_desktop.example.json` to
`config/google_oauth_desktop.json` and set both values:

```json
{
  "GOOGLE_OAUTH_DESKTOP_CLIENT_ID": "<DESKTOP_CLIENT_ID>.apps.googleusercontent.com",
  "GOOGLE_OAUTH_DESKTOP_CLIENT_SECRET": "<DESKTOP_CLIENT_SECRET>"
}
```

Run the `Noema (Google OAuth desktop)` VS Code configuration, or pass
`--dart-define-from-file=config/google_oauth_desktop.json`.
Desktop OAuth uses a client-derived custom URI scheme and PKCE; do not create
a Web callback URL for this client.

The desktop client secret is part of an installed-app public client and is
embedded in its build. It is not a server credential and must not be treated
as secret. Keep local config files out of source control.

## Backend configuration

Set `GOOGLE_OAUTH_CLIENT_IDS` to a comma-separated allowlist containing all
three OAuth client IDs:

```text
GOOGLE_OAUTH_CLIENT_IDS=<ANDROID_CLIENT_ID>,<WEB_CLIENT_ID>,<DESKTOP_CLIENT_ID>
```

The Android client ID is included because Google may report it as the access
token audience; the Web client ID is the Android ID-token audience; and the
Desktop client ID is the desktop ID-token audience. The backend validates both
the identity token and Drive access token against this allowlist.

For this direct client-side sync flow, the API does not need
`GOOGLE_OAUTH_CLIENT_SECRET`, `GOOGLE_OAUTH_REDIRECT_URIS`, or
`GOOGLE_TOKEN_ENCRYPTION_KEY`. Those variables belong only to the retired
server-side OAuth flow. Never put a server Web client secret or token
encryption key in Flutter configuration.

## Troubleshooting

- `clientConfigurationError` or an unexpected sign-in cancellation on Android:
  check the Android package name, debug/release SHA-1, and Web
  `serverClientId`.
- Account-link verification rejected by the API: check that all three client
  IDs are in `GOOGLE_OAUTH_CLIENT_IDS` and that the access token has the
  `drive.appdata` scope.
- Google says access is not configured: enable the Google Drive API and add
  the account as a consent-screen test user if the app is still in testing.
- A Drive request returns `403 accessNotConfigured` or `SERVICE_DISABLED`:
  enable **Google Drive API** under Google Cloud Console > APIs & Services >
  Library. `insufficientPermissions` instead means the account must renew the
  app authorization and grant `drive.appdata`.
- Desktop callback timeout: verify the configured ID is a **Desktop app**
  client and that the system can register the `noema` custom URI handler.
  Linux also requires `xdg-utils` and `desktop-file-utils` so the URL handler
  can be registered and discovered by the desktop environment.
- If an update reports a revision conflict, refresh the comparison and try
  again. The app checks the Drive version immediately before uploading and
  uses `If-Match` when Drive provides an ETag.
- When local data differs from Drive, the app compares both sides with this
  device's last successful sync. If only one side changed, it proceeds with
  that side without asking. Without a saved baseline, it can also recognize a
  backup created by this same installation and keep its newer local data;
  if the remote backup predates the device's last successful sync, it keeps
  the newer local data. Otherwise it asks when it cannot prove which side
  changed.

This setup guide covers Android, Linux, and Windows. iOS and macOS OAuth are
not configured by this flow.

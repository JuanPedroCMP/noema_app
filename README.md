# noema
A new Flutter project.
# noema_app

## Google Drive OAuth

Follow [the current Google Drive OAuth setup guide](docs/google-drive-oauth-setup.md)
to configure the Android and desktop clients and the backend audience allowlist.
Android uses native Google Sign-In; Linux and Windows use the system browser
with PKCE and a client-derived custom URI scheme.

For Android, copy
`config/google_oauth_android.example.json` to the gitignored
`config/google_oauth_android.json` and set `GOOGLE_OAUTH_SERVER_CLIENT_ID` to
the Web OAuth client ID. Run the `Noema (Google OAuth Android)` launch
configuration to pass it to Flutter.

For Linux/Windows, copy
`config/google_oauth_desktop.example.json` to the gitignored
`config/google_oauth_desktop.json` and set
`GOOGLE_OAUTH_DESKTOP_CLIENT_ID` and
`GOOGLE_OAUTH_DESKTOP_CLIENT_SECRET`. Run the matching desktop launch
configuration. A desktop client secret is a public-client value embedded in
the app; it is not a backend secret.

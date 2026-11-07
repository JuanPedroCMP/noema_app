# Google Drive OAuth setup

Google OAuth and all Drive API calls are owned by the Noema backend. The app
does not need Google Sign-In client IDs, a Google client secret, a refresh
token, or a platform-specific callback scheme.

## Google Cloud configuration

1. Enable the Google Drive API and configure the OAuth consent screen/testers.
2. Create one OAuth client of type **Web application**.
3. Register the backend callback URI exactly, for example:

   ```text
   https://api.example.com/api/v1/google_drive/oauth/callback
   ```

4. Request only `https://www.googleapis.com/auth/drive.appdata`; Noema stores
   snapshots in the app-private Drive folder.

## Backend secrets and redirect allowlist

Configure these values in the backend deployment's secret manager:

```text
GOOGLE_OAUTH_CLIENT_ID=<web client ID>
GOOGLE_OAUTH_CLIENT_SECRET=<web client secret>
GOOGLE_OAUTH_REDIRECT_URIS=https://api.example.com/api/v1/google_drive/oauth/callback
GOOGLE_TOKEN_ENCRYPTION_KEY=<base64 AES key>
GOOGLE_TOKEN_ENCRYPTION_KEY_VERSION=<key version>
```

The callback URI must match exactly in Google Cloud, the API deployment, and
the app's API base URL. Never put the client secret or token-encryption key in
Flutter build defines, app configuration, source control, or support logs.

Apply the backend Google Drive migrations before using the OAuth endpoints.
After the user completes authorization once, the backend stores the encrypted
refresh token for that Noema account. Other signed-in devices read account
status and reuse the server authorization; they do not repeat Google OAuth.

The browser displays a completion page after Google's callback. Keep Noema
open while it polls the authenticated completion endpoint. A timeout usually
means the callback URL is not registered, the app/API base URL does not match,
or the backend cannot exchange the authorization code.

## What belongs in the Flutter app

The app only needs its normal Noema API URL and the user's Noema access token.
It sends snapshot data to the Noema upload endpoint; the backend validates the
manifest and SHA-256 hash before uploading to Drive. Download and deletion are
also performed through the backend. Do not configure or send Google tokens
from Flutter.

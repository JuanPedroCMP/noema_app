# noema
A new Flutter project.
# noema_app

## Google Drive OAuth

Follow [the Google Drive OAuth setup guide](docs/google-drive-oauth-setup.md)
before creating OAuth clients. The guide covers Android, iOS, Linux, and
Windows, lists the exact values needed from Google Cloud, and explains which
values are safe to share.

Google Drive sign-in is configured for Android/iOS with `google_sign_in` and
Linux/Windows with a desktop OAuth flow using the system browser, a
client-derived custom URI scheme, and PKCE. Follow the setup guide for the
required OAuth client IDs and backend audience allowlist. Run the
`Noema (Google OAuth desktop)` VS Code launch configuration to load the
gitignored desktop ID and secret from
`config/google_oauth_desktop.json`. Android/iOS builds use
`config/google_oauth.json` and do not include the desktop client secret.

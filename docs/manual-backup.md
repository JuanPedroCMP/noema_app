# Backup manual

The **Configurações → Backup manual** section exports and imports a compressed
Noema snapshot without requiring Google Drive. The snapshot uses the same
categories and validation rules as Drive synchronization:

- custom themes;
- graphs, notes, and their versions;
- flashcards and exercises;
- study sessions and learning history;
- activity history.

Authentication, credentials and tokens, AI background tasks, device identity,
and server-synchronized preferences are intentionally excluded.

## Export

Choose **Exportar backup** and save the generated file. Unencrypted backups are
ZIP files (`.zip`). The app can optionally encrypt the compressed archive; the
encrypted file uses the `.noema` extension and AES-256-GCM authenticated
encryption, with a per-file random salt and nonce and PBKDF2-HMAC-SHA256 key
derivation.

The default key mode uses the Noema account ID so the same account can unlock
the file on another device. This is convenient but is not a strong secret: a
person who knows the account ID can derive the key. A custom key is recommended
for sensitive backups. Custom keys must have at least 12 characters. Keep the
custom key separately; Noema cannot recover it. If the key is lost, the
encrypted backup cannot be opened.

## Import and conflict choices

Choose **Importar backup** and select a `.zip` or `.noema` file. Encrypted
backups made with a custom key prompt for that key. The app validates the
archive, snapshot integrity, schema, and account ownership before changing any
local data. A backup for a different Noema account is rejected.

When the snapshot differs from the current device:

- **Manter meus dados** leaves this device unchanged.
- **Usar arquivo** replaces the snapshot-managed data on this device. The app
  asks for confirmation because this can remove local-only records.
- **Mesclar** preserves local records when the same record ID conflicts and
  adds records from the file that do not conflict. Related rows whose parent
  record was rejected by the merge are not imported.

Restoration runs transactionally. If validation or restoration fails, the
database transaction is rolled back.

## Local operation history and limits

The history is kept on the current device and shows the latest 50 export and
import attempts, including outcome, chosen strategy, archive and snapshot size,
record count, encryption status, date, and duration. It is not uploaded or
included in backups.

Snapshots are limited to 256 MiB and the compressed or encrypted file to
400 MiB. Keep an additional copy of important backups in a safe location.

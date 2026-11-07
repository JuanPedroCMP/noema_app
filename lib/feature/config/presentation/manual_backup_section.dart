import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/core/design/theme/theme_tokens.dart';
import 'package:noema/feature/config/data/google_drive/local_snapshot.dart';
import 'package:noema/feature/config/data/manual_backup_archive.dart';
import 'package:noema/feature/config/data/manual_backup_service.dart';
import 'package:noema/feature/config/providers/user_provider.dart';

class ManualBackupSection extends ConsumerStatefulWidget {
  const ManualBackupSection({super.key});

  @override
  ConsumerState<ManualBackupSection> createState() =>
      _ManualBackupSectionState();
}

class _ManualBackupSectionState extends ConsumerState<ManualBackupSection> {
  final _customKeyController = TextEditingController();
  final _confirmKeyController = TextEditingController();
  List<ManualBackupHistoryEntry> _history = const [];
  bool _historyLoading = true;
  bool _working = false;
  bool _encrypt = false;
  bool _showCustomKey = false;
  ManualBackupKeyMode _keyMode = ManualBackupKeyMode.accountId;
  String? _error;
  String? _historyError;

  ManualBackupService get _service =>
      ManualBackupService(ref.read(appDatabaseProvider));

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  @override
  void dispose() {
    _customKeyController.dispose();
    _confirmKeyController.dispose();
    super.dispose();
  }

  Future<void> _loadHistory() async {
    try {
      final history = await _service.history();
      if (!mounted) return;
      setState(() {
        _history = history;
        _historyError = null;
        _historyLoading = false;
      });
    } on Object catch (error) {
      if (!mounted) return;
      setState(() {
        _historyError = 'Não foi possível carregar o histórico: $error';
        _historyLoading = false;
      });
    }
  }

  Future<void> _exportBackup() async {
    final customKey = _validatedExportKey();
    if (_encrypt &&
        _keyMode == ManualBackupKeyMode.custom &&
        customKey == null) {
      return;
    }

    setState(() {
      _working = true;
      _error = null;
    });
    ExportedManualBackup? exported;
    var fileSaved = false;
    try {
      final user = await ref.read(userProvider.future);
      exported = await _service.createArchive(
        localUserId: user.id,
        remoteUserId: user.remoteId,
        encrypt: _encrypt,
        keyMode: _keyMode,
        customKey: customKey,
      );
      final extension = exported.encrypted ? 'noema' : 'zip';
      final uri = await FilePicker.saveFile(
        fileName: 'noema-backup-${_fileTimestamp()}.${extension}',
        bytes: exported.bytes,
        mimeType: exported.encrypted
            ? 'application/octet-stream'
            : 'application/zip',
        dialogTitle: 'Salvar backup manual do Noema',
      );
      if (uri == null) return;
      fileSaved = true;
      await _service.recordExportSuccess(exported);
      await _loadHistory();
      if (mounted) {
        _showMessage(
          'Backup exportado (${_formatBytes(exported.bytes.length)}).',
        );
      }
    } on Object catch (error) {
      if (exported != null && !fileSaved) {
        await _service.recordOperation(
          operation: ManualBackupOperation.export,
          status: 'failed',
          strategy: 'export',
          startedAt: exported.startedAt,
          archiveSizeBytes: exported.bytes.length,
          snapshotSizeBytes: exported.snapshotSizeBytes,
          recordCount: exported.recordCount,
          encrypted: exported.encrypted,
          details: 'O arquivo não pôde ser salvo.',
        );
      }
      if (!mounted) return;
      setState(
        () => _error = error is ManualBackupHistoryException
            ? error.toString()
            : 'Não foi possível exportar o backup: $error',
      );
      await _loadHistory();
    } finally {
      if (mounted) setState(() => _working = false);
    }
  }

  String? _validatedExportKey() {
    if (!_encrypt || _keyMode == ManualBackupKeyMode.accountId) return null;
    final key = _customKeyController.text;
    if (key.trim().length < 12) {
      setState(
        () =>
            _error = 'Use uma chave personalizada com ao menos 12 caracteres.',
      );
      return null;
    }
    if (key != _confirmKeyController.text) {
      setState(
        () => _error = 'A confirmação da chave personalizada não confere.',
      );
      return null;
    }
    return key;
  }

  Future<void> _importBackup() async {
    setState(() {
      _working = true;
      _error = null;
    });
    ManualBackupImportPreview? preview;
    final startedAt = DateTime.now();
    Uint8List? bytes;
    var inspectionInvoked = false;
    var fileSelected = false;
    var archiveSizeBytes = 0;
    try {
      final picked = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: const ['zip', 'noema'],
        dialogTitle: 'Selecionar backup manual do Noema',
      );
      if (picked == null) return;
      fileSelected = true;
      final selectedSize = await picked.length();
      if (selectedSize == 0 || (selectedSize ?? 0) > maxManualBackupBytes) {
        throw const FormatException(
          'O arquivo está vazio ou excede o limite seguro de 400 MiB.',
        );
      }
      final buffer = BytesBuilder(copy: false);
      await for (final chunk in picked.readAsByteStream()) {
        archiveSizeBytes += chunk.length;
        if (archiveSizeBytes > maxManualBackupBytes) {
          throw const FormatException(
            'O arquivo excede o limite seguro de 400 MiB.',
          );
        }
        buffer.add(chunk);
      }
      if (archiveSizeBytes == 0) {
        throw const FormatException('O arquivo selecionado está vazio.');
      }
      bytes = buffer.takeBytes();
      final keyMode = ManualBackupArchive.encryptionMode(bytes);
      String? customKey;
      if (keyMode == ManualBackupKeyMode.custom) {
        customKey = await _requestCustomKey();
        if (customKey == null) return;
      }

      final user = await ref.read(userProvider.future);
      inspectionInvoked = true;
      preview = await _service.inspectArchive(
        bytes: bytes,
        localUserId: user.id,
        remoteUserId: user.remoteId,
        customKey: customKey,
      );
      if (!mounted) return;

      final strategy = preview.diff.isEmpty
          ? ManualBackupStrategy.keepLocal
          : await _chooseImportStrategy(preview.diff, preview);
      if (strategy == null || !mounted) return;
      if (strategy == ManualBackupStrategy.keepRemote &&
          !await _confirmReplaceLocalData()) {
        return;
      }
      final identical = preview.diff.isEmpty;
      await _service.applyImport(
        preview,
        strategy,
        localUserId: user.id,
        remoteUserId: user.remoteId,
      );
      preview = null;
      await _loadHistory();
      if (mounted) {
        _showMessage(
          identical
              ? 'Este backup já contém os mesmos dados. Nada foi alterado.'
              : switch (strategy) {
                ManualBackupStrategy.keepLocal =>
                  'Seus dados neste dispositivo foram mantidos.',
                ManualBackupStrategy.keepRemote =>
                  'Os dados do arquivo foram restaurados neste dispositivo.',
                ManualBackupStrategy.merge =>
                  'Os dados do arquivo foram mesclados com os dados locais.',
              },
        );
      }
    } on Object catch (error) {
      if (preview == null && fileSelected && !inspectionInvoked) {
        await _service.recordOperation(
          operation: ManualBackupOperation.import,
          status: 'failed',
          strategy: 'validate',
          startedAt: startedAt,
          archiveSizeBytes: archiveSizeBytes,
          details: 'O arquivo não pôde ser validado.',
        );
        await _loadHistory();
      }
      if (!mounted) return;
      setState(
        () => _error = error is ManualBackupHistoryException
            ? error.toString()
            : 'Não foi possível importar o backup: $error',
      );
    } finally {
      if (preview != null) await _service.disposePreview(preview);
      if (mounted) setState(() => _working = false);
    }
  }

  Future<String?> _requestCustomKey() async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Desbloquear backup'),
        content: TextField(
          controller: controller,
          autofocus: true,
          obscureText: true,
          decoration: const InputDecoration(labelText: 'Chave personalizada'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Desbloquear'),
          ),
        ],
      ),
    );
    controller.dispose();
    return result;
  }

  Future<ManualBackupStrategy?> _chooseImportStrategy(
    SnapshotDiff diff,
    ManualBackupImportPreview preview,
  ) {
    return showDialog<ManualBackupStrategy>(
      context: context,
      builder: (context) => AlertDialog(
        scrollable: true,
        title: const Text('Como resolver as diferenças?'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${diff.totalChanges} registros diferentes · '
              '${diff.conflicts} conflitos · '
              '${_formatBytes(preview.archiveSizeBytes)} compactados · '
              '${_formatBytes(preview.incoming.sizeBytes)} de snapshot.',
            ),
            SizedBox(height: context.spacing.md),
            for (final category in diff.categories)
              Padding(
                padding: EdgeInsets.only(bottom: context.spacing.xs),
                child: Text(
                  '${snapshotCategoryLabel(category.category)}: '
                  '${category.localOnly} somente neste dispositivo, '
                  '${category.remoteOnly} somente no arquivo, '
                  '${category.changed} alterados nos dois lados.',
                ),
              ),
            SizedBox(height: context.spacing.xs),
            for (final change in diff.changes.take(12))
              Padding(
                padding: EdgeInsets.only(bottom: context.spacing.xs),
                child: Text(
                  '${snapshotCategoryLabel(change.category)} · '
                  '${change.table} · ${change.kind.name} · '
                  '${change.fields.isEmpty ? change.rowId : change.fields.join(', ')}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            if (diff.changes.length > 12)
              Text(
                'Mais ${diff.changes.length - 12} diferenças não exibidas.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            SizedBox(height: context.spacing.sm),
            const Text(
              'Mesclar preserva seus registros locais quando há conflito de '
              'mesmo ID e acrescenta os registros do arquivo que não conflitam. '
              '“Usar arquivo” substitui os dados incluídos no backup. Dados '
              'fora do snapshot, como autenticação e credenciais, não são '
              'alterados.',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          OutlinedButton.icon(
            onPressed: () =>
                Navigator.pop(context, ManualBackupStrategy.keepLocal),
            icon: const Icon(Icons.phone_android),
            label: const Text('Manter meus dados'),
          ),
          OutlinedButton.icon(
            onPressed: () =>
                Navigator.pop(context, ManualBackupStrategy.keepRemote),
            icon: const Icon(Icons.archive_outlined),
            label: const Text('Usar arquivo'),
          ),
          FilledButton.icon(
            onPressed: () => Navigator.pop(context, ManualBackupStrategy.merge),
            icon: const Icon(Icons.merge_type),
            label: const Text('Mesclar'),
          ),
        ],
      ),
    );
  }

  Future<bool> _confirmReplaceLocalData() async =>
      await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Substituir dados deste dispositivo?'),
          content: const Text(
            'Esta ação substituirá os dados locais que fazem parte do snapshot '
            'pelo conteúdo do arquivo. O restante do aplicativo, incluindo '
            'autenticação e credenciais, não será alterado. A operação é '
            'transacional: se a restauração falhar, as alterações serão '
            'desfeitas.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Substituir dados'),
            ),
          ],
        ),
      ) ??
      false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Exporte os dados que entram no snapshot do Drive para um arquivo '
          'compactado, ou importe um arquivo em outro dispositivo. O backup '
          'inclui grafos, anotações, conteúdo de aprendizagem, histórico de '
          'estudo, atividade e temas personalizados.',
          style: theme.textTheme.bodyMedium,
        ),
        SizedBox(height: spacing.xs),
        Text(
          'Não inclui credenciais, tokens, dados de autenticação, tarefas de '
          'IA nem preferências sincronizadas com o servidor.',
          style: theme.textTheme.bodySmall,
        ),
        SizedBox(height: spacing.sm),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          value: _encrypt,
          onChanged: _working
              ? null
              : (value) => setState(() {
                  _encrypt = value;
                  _error = null;
                }),
          title: const Text('Criptografar o arquivo'),
          subtitle: const Text(
            'Opcional. A proteção usa AES-256-GCM. Sem a chave correta, o '
            'backup não pode ser recuperado.',
          ),
        ),
        if (_encrypt) ...[
          RadioListTile<ManualBackupKeyMode>(
            contentPadding: EdgeInsets.zero,
            value: ManualBackupKeyMode.accountId,
            groupValue: _keyMode,
            onChanged: _working
                ? null
                : (value) => setState(() {
                    if (value != null) _keyMode = value;
                    _error = null;
                  }),
            title: const Text('Usar meu ID Noema (padrão)'),
            subtitle: const Text(
              'Conveniente, mas menos seguro: quem souber seu ID poderá '
              'derivar a chave.',
            ),
          ),
          RadioListTile<ManualBackupKeyMode>(
            contentPadding: EdgeInsets.zero,
            value: ManualBackupKeyMode.custom,
            groupValue: _keyMode,
            onChanged: _working
                ? null
                : (value) => setState(() {
                    if (value != null) _keyMode = value;
                    _error = null;
                  }),
            title: const Text('Usar uma chave personalizada'),
            subtitle: const Text(
              'Mais segura. Guarde-a separadamente: o Noema não consegue '
              'recuperá-la.',
            ),
          ),
          if (_keyMode == ManualBackupKeyMode.custom) ...[
            TextField(
              controller: _customKeyController,
              enabled: !_working,
              obscureText: !_showCustomKey,
              autofillHints: const [AutofillHints.newPassword],
              decoration: InputDecoration(
                labelText: 'Chave (mínimo de 12 caracteres)',
                suffixIcon: IconButton(
                  tooltip: _showCustomKey ? 'Ocultar chave' : 'Mostrar chave',
                  onPressed: () =>
                      setState(() => _showCustomKey = !_showCustomKey),
                  icon: Icon(
                    _showCustomKey ? Icons.visibility_off : Icons.visibility,
                  ),
                ),
              ),
            ),
            SizedBox(height: spacing.sm),
            TextField(
              controller: _confirmKeyController,
              enabled: !_working,
              obscureText: !_showCustomKey,
              decoration: const InputDecoration(labelText: 'Confirme a chave'),
            ),
          ],
        ],
        if (_error != null) ...[
          SizedBox(height: spacing.xs),
          Text(_error!, style: TextStyle(color: theme.colorScheme.error)),
        ],
        if (_working) ...[
          SizedBox(height: spacing.md),
          const LinearProgressIndicator(),
        ],
        SizedBox(height: spacing.md),
        Wrap(
          spacing: spacing.sm,
          runSpacing: spacing.sm,
          children: [
            FilledButton.icon(
              onPressed: _working ? null : _exportBackup,
              icon: const Icon(Icons.file_download_outlined),
              label: const Text('Exportar backup'),
            ),
            OutlinedButton.icon(
              onPressed: _working ? null : _importBackup,
              icon: const Icon(Icons.file_upload_outlined),
              label: const Text('Importar backup'),
            ),
          ],
        ),
        SizedBox(height: spacing.lg),
        Row(
          children: [
            Expanded(
              child: Text(
                'Histórico de operações',
                style: theme.textTheme.titleMedium,
              ),
            ),
            IconButton(
              tooltip: 'Atualizar histórico',
              onPressed: _historyLoading ? null : _loadHistory,
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
        if (_historyLoading)
          const LinearProgressIndicator()
        else if (_historyError != null)
          Text(_historyError!, style: TextStyle(color: theme.colorScheme.error))
        else if (_history.isEmpty)
          const Text('Ainda não há exportações ou importações manuais.')
        else
          for (final entry in _history) _HistoryTile(entry: entry),
      ],
    );
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  String _fileTimestamp() =>
      DateFormat('yyyyMMdd-HHmmss').format(DateTime.now());
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({required this.entry});

  final ManualBackupHistoryEntry entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final failed = entry.status == 'failed';
    final strategy = manualBackupStrategyLabel(entry.strategy);
    final details = <String>[
      strategy,
      '${_formatBytes(entry.archiveSizeBytes)} compactados',
      if (entry.snapshotSizeBytes > 0)
        '${_formatBytes(entry.snapshotSizeBytes)} de dados',
      '${entry.recordCount} registros',
      if (entry.encrypted) 'Criptografado',
      '${(entry.durationMs / 1000).toStringAsFixed(1)} s',
      if (entry.details != null) entry.details!,
    ].join(' · ');
    final operationLabel = entry.operation == ManualBackupOperation.export
        ? failed
              ? 'Falha ao exportar'
              : 'Exportado'
        : failed
        ? 'Falha ao importar'
        : 'Importado';
    return ListTile(
      contentPadding: EdgeInsets.zero,
      dense: true,
      leading: Icon(
        failed
            ? Icons.error_outline
            : entry.operation == ManualBackupOperation.export
            ? Icons.file_download_outlined
            : Icons.file_upload_outlined,
        color: failed ? theme.colorScheme.error : null,
      ),
      title: Text(
        '$operationLabel · '
        '${DateFormat.yMMMd().add_Hm().format(entry.createdAt)}',
      ),
      subtitle: Text(details),
    );
  }
}

String _formatBytes(int bytes) {
  if (bytes < 1024) return '$bytes B';
  if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
  if (bytes < 1024 * 1024 * 1024) {
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
  return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
}

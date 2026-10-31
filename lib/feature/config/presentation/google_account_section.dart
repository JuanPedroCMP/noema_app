import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:built_value/json_object.dart';
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/core/design/theme/theme_tokens.dart';
import 'package:noema/feature/config/data/config_dao.dart';
import 'package:noema/feature/config/data/google_drive/google_drive_sync_service.dart';
import 'package:noema/feature/config/data/google_drive/local_snapshot.dart';
import 'package:noema/feature/config/providers/preference_storage_provider.dart';
import 'package:noema/feature/config/providers/user_provider.dart';
import 'package:openapi/openapi.dart';

class GoogleAccountSection extends ConsumerStatefulWidget {
  const GoogleAccountSection({super.key});

  @override
  ConsumerState<GoogleAccountSection> createState() =>
      _GoogleAccountSectionState();
}

class _GoogleAccountSectionState extends ConsumerState<GoogleAccountSection> {
  GoogleAccountStatusOut? _status;
  bool _loading = true;
  bool _working = false;
  String? _error;
  String? _progress;
  double? _progressFraction;
  List<BackupFileOut> _backups = const [];
  List<SyncLogOut> _history = const [];
  bool _backupLoading = false;
  String? _backupError;
  String _frequency = 'manual';
  bool _frequencyLoading = true;
  bool _frequencySaving = false;
  String? _frequencyError;

  @override
  void initState() {
    super.initState();
    _refreshStatus();
    _loadFrequency();
  }

  Future<void> _loadFrequency() async {
    try {
      final user = await ref.read(userProvider.future);
      final config = await ConfigDao(
        ref.read(appDatabaseProvider),
      ).getConfigByUser(userId: user.id);
      final stored = config == null
          ? null
          : readConfigPreference(config.preferences, 'backupFrequency');
      if (!mounted) return;
      setState(() {
        _frequency = _backupFrequencies.containsKey(stored)
            ? stored! as String
            : 'manual';
        _frequencyLoading = false;
      });
    } on Object catch (error) {
      if (!mounted) return;
      setState(() {
        _frequencyError = 'Não foi possível carregar a frequência: $error';
        _frequencyLoading = false;
      });
    }
  }

  Future<void> _saveFrequency(String value) async {
    setState(() {
      _frequencySaving = true;
      _frequencyError = null;
    });
    try {
      await ref
          .read(preferenceStorageServiceProvider)
          .save(key: 'backupFrequency', value: value);
      if (!mounted) return;
      setState(() => _frequency = value);
    } on Object catch (error) {
      if (!mounted) return;
      setState(() => _frequencyError = 'Não foi possível salvar: $error');
    } finally {
      if (mounted) setState(() => _frequencySaving = false);
    }
  }

  Future<void> _refreshStatus({bool preserveError = false}) async {
    setState(() {
      _loading = true;
      if (!preserveError) _error = null;
    });
    try {
      final status = await ref
          .read(googleDriveSyncServiceProvider)
          .getAccountStatus();
      if (!mounted) return;
      setState(() {
        _status = status;
        _loading = false;
      });
      final accountId = status.accountId;
      if (accountId == null) {
        setState(() {
          _backups = const [];
          _history = const [];
          _backupError = null;
        });
      } else {
        await _refreshBackupData(accountId);
      }
    } on Object catch (error) {
      if (!mounted) return;
      setState(() {
        final refreshError = _errorMessage(error);
        _error = preserveError && _error != null
            ? '$_error $refreshError'
            : refreshError;
        _loading = false;
      });
    }
  }

  Future<void> _refreshBackupData(String accountId) async {
    setState(() {
      _backupLoading = true;
      _backupError = null;
    });
    try {
      final service = ref.read(googleDriveSyncServiceProvider);
      final backups = await service.listBackups(accountId);
      final history = await service.listSyncHistory(accountId);
      if (!mounted) return;
      setState(() {
        _backups = backups;
        _history = history;
      });
    } on Object catch (error) {
      if (!mounted) return;
      setState(() {
        _backupError = _errorMessage(error);
      });
    } finally {
      if (mounted) setState(() => _backupLoading = false);
    }
  }

  Future<void> _connect() async {
    setState(() {
      _working = true;
      _progress = 'Abrindo a autorização segura do Google…';
      _error = null;
    });
    try {
      final status = await ref
          .read(googleDriveSyncServiceProvider)
          .connectGoogleAccount();
      if (!mounted) return;
      setState(() => _status = status);
      if (status.syncAvailable && status.accountId != null) {
        await _refreshBackupData(status.accountId!);
      }
      _message(
        status.syncAvailable
            ? 'Conta Google conectada. O Noema acessa apenas os próprios arquivos privados no Drive.'
            : _stateDescription(status),
      );
    } on Object catch (error) {
      final message = _errorMessage(error);
      if (mounted) {
        setState(() => _error = message);
        _message(message);
      }
      try {
        final status = await ref
            .read(googleDriveSyncServiceProvider)
            .getAccountStatus();
        if (mounted) setState(() => _status = status);
      } on Object catch (refreshError) {
        if (mounted) {
          setState(() {
            _error = '$message ${_errorMessage(refreshError)}';
          });
        }
      }
    } finally {
      if (mounted) {
        setState(() {
          _working = false;
          _progress = null;
          _progressFraction = null;
        });
      }
    }
  }

  Future<void> _repairAuthorization() async {
    setState(() {
      _working = true;
      _progress = 'Renovando a autorização Google…';
      _progressFraction = null;
      _error = null;
    });
    try {
      final status = await ref
          .read(googleDriveSyncServiceProvider)
          .repairGoogleAuthorization();
      if (!mounted) return;
      setState(() => _status = status);
      if (status.syncAvailable && status.accountId != null) {
        await _refreshBackupData(status.accountId!);
      }
      if (status.syncAvailable) {
        _message(
          'Autorização corrigida. O Google Drive está pronto para sincronizar.',
        );
      } else {
        _message(_stateDescription(status));
      }
    } on Object catch (error) {
      if (mounted) {
        final message = _errorMessage(error);
        setState(() => _error = message);
        _message(message);
      }
    } finally {
      if (mounted) {
        setState(() {
          _working = false;
          _progress = null;
          _progressFraction = null;
        });
      }
    }
  }

  Future<void> _unlink() async {
    final status = _status;
    final accountId = status?.accountId;
    if (accountId == null) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        scrollable: true,
        title: const Text('Desvincular conta Google?'),
        content: Text(
          'A conta ${status?.googleEmail ?? 'Google'} será removida do Noema. '
          'Os registros de metadados dos backups serão apagados do servidor, '
          'mas os arquivos na pasta privada do Noema no Google Drive e os dados '
          'deste dispositivo não serão excluídos. Para usar outra conta, será '
          'necessário autorizar o Google novamente.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton.tonalIcon(
            onPressed: () => Navigator.pop(context, true),
            icon: const Icon(Icons.link_off),
            label: const Text('Desvincular'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() {
      _working = true;
      _progress = 'Removendo metadados e desvinculando a conta…';
      _progressFraction = null;
      _error = null;
    });
    try {
      await ref
          .read(googleDriveSyncServiceProvider)
          .unlinkGoogleAccount(accountId);
      if (!mounted) return;
      _message(
        'Conta desvinculada. Os arquivos no Google Drive e os dados locais foram mantidos.',
      );
      await _refreshStatus();
    } on Object catch (error) {
      if (!mounted) return;
      final message = _errorMessage(error);
      setState(() => _error = message);
      _message(message);
      await _refreshStatus(preserveError: true);
    } finally {
      if (mounted) {
        setState(() {
          _working = false;
          _progress = null;
          _progressFraction = null;
        });
      }
    }
  }

  Future<void> _startSync() async {
    final service = ref.read(googleDriveSyncServiceProvider);
    DriveSyncPreview? preview;
    setState(() {
      _working = true;
      _progress = 'Preparando a sincronização…';
      _progressFraction = null;
      _error = null;
    });
    try {
      preview = await service.prepareSync(onProgress: _showProgress);
      if (!mounted) return;

      DriveSyncResolution? resolution;
      if (preview.remoteSnapshot == null) {
        final confirmed = await _confirmFirstBackup();
        if (confirmed) resolution = DriveSyncResolution.keepLocal;
      } else if (preview.diff?.isEmpty == true) {
        if (preview.metadataNeedsRepair) {
          resolution = DriveSyncResolution.reconcileMetadata;
        } else {
          _message(
            'Este dispositivo já está atualizado com o backup do Drive.',
          );
          return;
        }
      } else {
        resolution = await _chooseResolution(preview);
      }

      if (resolution == null || !mounted) return;
      final result = await service.resolve(
        preview,
        resolution,
        onProgress: _showProgress,
      );
      if (!mounted) return;
      _message(
        result.warning == null
            ? result.message
            : '${result.message} ${result.warning}',
      );
      await _refreshStatus();
    } on Object catch (error) {
      final message = _errorMessage(error);
      if (mounted) setState(() => _error = message);
      _message(message);
    } finally {
      if (preview != null) {
        await service.disposePreview(preview);
      }
      if (mounted) {
        setState(() {
          _working = false;
          _progress = null;
          _progressFraction = null;
        });
      }
    }
  }

  void _showProgress(DriveSyncProgress progress) {
    if (!mounted) return;
    setState(() {
      _progress = progress.label;
      _progressFraction = progress.fraction;
    });
  }

  Future<bool> _confirmFirstBackup() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            scrollable: true,
            title: const Text('Criar o primeiro backup?'),
            content: const Text(
              'O app vai preparar um snapshot dos seus grafos, anotações, '
              'flashcards, exercícios, histórico de estudo e temas locais. '
              'O arquivo será enviado diretamente do dispositivo para a área '
              'privada do Noema no Google Drive. Preferências e dados já '
              'sincronizados com o servidor ficam fora do snapshot.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Agora não'),
              ),
              FilledButton.icon(
                onPressed: () => Navigator.pop(context, true),
                icon: const Icon(Icons.cloud_upload_outlined),
                label: const Text('Criar backup'),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<DriveSyncResolution?> _chooseResolution(
    DriveSyncPreview preview,
  ) async {
    final diff = preview.diff;
    if (diff == null) return null;
    return showDialog<DriveSyncResolution>(
      context: context,
      builder: (context) {
        final spacing = context.spacing;
        return AlertDialog(
          title: const Text('Há diferenças entre este dispositivo e o Drive'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Revise o resumo antes de escolher. “Somente neste lado” '
                  'significa que o registro está presente em um snapshot e '
                  'ausente no outro; não significa necessariamente que foi '
                  'excluído.',
                ),
                SizedBox(height: spacing.md),
                for (final category in diff.categories)
                  _CategoryDifference(category: category),
                SizedBox(height: spacing.md),
                Text(
                  'Detalhes das alterações',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                SizedBox(height: spacing.xs),
                for (final change in diff.changes.take(16))
                  _SnapshotChangeTile(change: change),
                if (diff.changes.length > 16)
                  Padding(
                    padding: EdgeInsets.only(top: spacing.xs),
                    child: Text(
                      'E mais ${diff.changes.length - 16} alterações. '
                      'O total é ${diff.totalChanges}.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                SizedBox(height: spacing.md),
                const Text(
                  'Mesclar mantém os registros locais em conflitos de mesmo '
                  'ID e acrescenta os registros remotos não conflitantes. '
                  'Nenhum lado é escolhido silenciosamente.',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            OutlinedButton.icon(
              onPressed: () =>
                  Navigator.pop(context, DriveSyncResolution.keepLocal),
              icon: const Icon(Icons.phone_android),
              label: const Text('Manter local'),
            ),
            OutlinedButton.icon(
              onPressed: () =>
                  Navigator.pop(context, DriveSyncResolution.keepRemote),
              icon: const Icon(Icons.cloud_download_outlined),
              label: const Text('Usar Drive'),
            ),
            FilledButton.icon(
              onPressed: () =>
                  Navigator.pop(context, DriveSyncResolution.merge),
              icon: const Icon(Icons.merge_type),
              label: const Text('Mesclar'),
            ),
          ],
        );
      },
    );
  }

  String _errorMessage(Object error) => googleDriveOperationErrorMessage(error);

  void _message(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final status = _status;
    final theme = Theme.of(context);
    final state = status?.state.name ?? 'unknown';
    final connected = status?.syncAvailable == true;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Os snapshots são enviados e baixados diretamente entre este '
          'dispositivo e a pasta privada do Noema no Google Drive. O servidor '
          'guarda apenas metadados e não recebe o conteúdo dos arquivos.',
          style: theme.textTheme.bodyMedium,
        ),
        if (_isDesktopTarget)
          Padding(
            padding: EdgeInsets.only(top: spacing.sm),
            child: Text(
              'No Linux e Windows, a autorização abre o navegador padrão e '
              'retorna ao app com uma conexão local protegida por PKCE. '
              'A autorização renovável fica armazenada no cofre seguro do sistema.',
              style: theme.textTheme.bodySmall,
            ),
          ),
        SizedBox(height: spacing.md),
        Card(
          child: ListTile(
            leading: CircleAvatar(
              child: Icon(
                connected
                    ? Icons.cloud_done_outlined
                    : Icons.cloud_off_outlined,
              ),
            ),
            title: Text(
              (status?.googleEmail?.isNotEmpty == true
                      ? status!.googleEmail!
                      : null) ??
                  (_loading ? 'Consultando conta Google…' : _stateTitle(state)),
            ),
            subtitle: Text(
              status == null
                  ? 'O status da conta ainda não está disponível.'
                  : _stateDescription(status),
            ),
            trailing: IconButton(
              tooltip: 'Atualizar status',
              onPressed: _loading || _working ? null : _refreshStatus,
              icon: const Icon(Icons.refresh),
            ),
          ),
        ),
        if (_error != null)
          Padding(
            padding: EdgeInsets.only(top: spacing.xs),
            child: Text(
              _error!,
              style: TextStyle(color: theme.colorScheme.error),
            ),
          ),
        if (status?.error?.name == 'googleAuthorizationUnverified')
          Padding(
            padding: EdgeInsets.only(top: spacing.sm),
            child: Text(
              'Tente renovar a autorização. Se o Google continuar sem '
              'confirmar a conta, a configuração OAuth do servidor precisa '
              'incluir o cliente desta plataforma.',
              style: theme.textTheme.bodySmall,
            ),
          ),
        if (_working) ...[
          SizedBox(height: spacing.sm),
          LinearProgressIndicator(value: _progressFraction),
          if (_progress != null) ...[
            SizedBox(height: spacing.xs),
            Text(_progress!, style: theme.textTheme.bodySmall),
          ],
        ],
        SizedBox(height: spacing.md),
        Wrap(
          spacing: spacing.sm,
          runSpacing: spacing.sm,
          children: [
            if (status?.accountId == null)
              FilledButton.icon(
                onPressed: _working || _loading ? null : _connect,
                icon: const Icon(Icons.link),
                label: const Text('Conectar Google'),
              ),
            if (!connected && status?.accountId != null)
              FilledButton.tonalIcon(
                onPressed: _working ? null : _repairAuthorization,
                icon: const Icon(Icons.build_outlined),
                label: const Text('Corrigir autorização'),
              ),
            if (connected)
              FilledButton.icon(
                onPressed: _working ? null : _startSync,
                icon: const Icon(Icons.sync),
                label: const Text('Sincronizar agora'),
              ),
            if (!connected)
              OutlinedButton.icon(
                onPressed: _loading || _working ? null : _refreshStatus,
                icon: const Icon(Icons.refresh),
                label: const Text('Atualizar status'),
              ),
            if (status?.accountId != null)
              OutlinedButton.icon(
                onPressed: _working ? null : _unlink,
                icon: const Icon(Icons.link_off),
                label: const Text('Desvincular'),
              ),
          ],
        ),
        if (connected) ...[
          SizedBox(height: spacing.lg),
          _backupManagement(context),
        ],
      ],
    );
  }

  Widget _backupManagement(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final conflicts = _history
        .where((entry) => entry.result == SyncResult.inConflict)
        .length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Gerenciar backup', style: theme.textTheme.titleLarge),
        SizedBox(height: spacing.sm),
        Card(
          child: Padding(
            padding: EdgeInsets.all(spacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Frequência preferida',
                  style: theme.textTheme.titleMedium,
                ),
                SizedBox(height: spacing.xs),
                Text(
                  'A sincronização é iniciada manualmente. Esta preferência '
                  'não agenda backups em segundo plano.',
                  style: theme.textTheme.bodySmall,
                ),
                SizedBox(height: spacing.sm),
                DropdownButtonFormField<String>(
                  initialValue: _frequency,
                  decoration: const InputDecoration(
                    labelText: 'Frequência',
                    prefixIcon: Icon(Icons.schedule_outlined),
                  ),
                  items: [
                    for (final entry in _backupFrequencies.entries)
                      DropdownMenuItem(
                        value: entry.key,
                        child: Text(entry.value),
                      ),
                  ],
                  onChanged: _frequencyLoading || _frequencySaving
                      ? null
                      : (value) {
                          if (value != null) _saveFrequency(value);
                        },
                ),
                if (_frequencyLoading || _frequencySaving)
                  const LinearProgressIndicator(),
                if (_frequencyError != null)
                  Padding(
                    padding: EdgeInsets.only(top: spacing.xs),
                    child: Text(
                      _frequencyError!,
                      style: TextStyle(color: theme.colorScheme.error),
                    ),
                  ),
              ],
            ),
          ),
        ),
        SizedBox(height: spacing.sm),
        Card(
          child: Padding(
            padding: EdgeInsets.all(spacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Arquivos de backup',
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                    IconButton(
                      tooltip: 'Atualizar arquivos e histórico',
                      onPressed: _backupLoading
                          ? null
                          : () {
                              final accountId = _status?.accountId;
                              if (accountId != null) {
                                _refreshBackupData(accountId);
                              }
                            },
                      icon: const Icon(Icons.refresh),
                    ),
                  ],
                ),
                if (_backupLoading) const LinearProgressIndicator(),
                if (_backupError != null)
                  Padding(
                    padding: EdgeInsets.only(top: spacing.xs),
                    child: Text(
                      _backupError!,
                      style: TextStyle(color: theme.colorScheme.error),
                    ),
                  ),
                if (!_backupLoading && _backups.isEmpty)
                  const Text(
                    'Nenhum arquivo de backup foi registrado para esta conta.',
                  ),
                for (final backup in _backups.take(8))
                  _BackupFileTile(backup: backup),
                if (_backups.length > 8)
                  Text(
                    'Exibindo 8 de ${_backups.length} registros de backup.',
                    style: theme.textTheme.bodySmall,
                  ),
              ],
            ),
          ),
        ),
        SizedBox(height: spacing.sm),
        Card(
          child: Padding(
            padding: EdgeInsets.all(spacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Histórico e conflitos',
                  style: theme.textTheme.titleMedium,
                ),
                SizedBox(height: spacing.xs),
                Text(
                  conflicts == 0
                      ? 'Nenhum conflito pendente registrado no servidor.'
                      : '$conflicts conflito(s) registrado(s) no histórico.',
                  style: theme.textTheme.bodySmall,
                ),
                if (_history.isEmpty && !_backupLoading)
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text('Ainda não há operações de sincronização.'),
                  ),
                for (final entry in _history.take(10))
                  _SyncHistoryTile(entry: entry),
                if (_history.length > 10)
                  Text(
                    'Exibindo as 10 operações mais recentes.',
                    style: theme.textTheme.bodySmall,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _stateTitle(String state) => switch (state) {
    'notLinked' => 'Nenhuma conta Google conectada',
    'missing' => 'Permissão para o Drive não concedida',
    'revoked' => 'Autorização Google revogada',
    'granted' => 'Conta Google conectada',
    'unknown' => 'Não foi possível verificar a autorização Google',
    _ => 'Status Google indisponível',
  };

  String _stateDescription(GoogleAccountStatusOut status) {
    if (status.syncAvailable) {
      return 'Acesso autorizado somente aos arquivos privados do Noema.';
    }
    if (_isDesktopTarget &&
        status.error?.name == 'googleAuthorizationUnverified') {
      return 'O login desktop foi concluído, mas o servidor ainda não confia '
          'neste cliente. Inclua o Desktop client ID em GOOGLE_OAUTH_CLIENT_IDS '
          'no backend.';
    }
    return switch (status.error?.name) {
      'googleAuthorizationUnverified' =>
        'A conta está vinculada, mas o servidor não conseguiu validar a '
            'autorização Google. Renove a autorização; se persistir, verifique '
            'os clientes OAuth configurados no servidor.',
      'googleAuthorizationRevoked' =>
        'A autorização Google foi revogada. Renove o acesso para sincronizar.',
      'driveAppdataScopeMissing' =>
        'A autorização não inclui o acesso à pasta privada do Noema. '
            'Renove a autorização e conceda o acesso solicitado.',
      _ => switch (status.state.name) {
        'notLinked' => 'Conecte uma conta para criar e restaurar backups.',
        'missing' => 'Conecte novamente e conceda o escopo privado do app.',
        'revoked' => 'Conecte novamente para retomar a sincronização.',
        'unknown' =>
          'O servidor não conseguiu verificar a autorização Google. '
              'Tente corrigir a autorização ou atualizar o status.',
        _ => 'Verifique a conexão e atualize o status.',
      },
    };
  }

  bool get _isDesktopTarget =>
      defaultTargetPlatform == TargetPlatform.linux ||
      defaultTargetPlatform == TargetPlatform.windows;
}

const _backupFrequencies = <String, String>{
  'manual': 'Somente manual',
  'daily': 'Diária',
  'weekly': 'Semanal',
  'monthly': 'Mensal',
};

class _BackupFileTile extends StatelessWidget {
  const _BackupFileTile({required this.backup});

  final BackupFileOut backup;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = backup.operationState.name;
    final date = backup.updatedAt ?? backup.createdAt;
    final counts = _backupCounts(backup);
    final countSummary = [
      for (final category in snapshotCategories)
        if ((counts[category] ?? 0) > 0)
          '${snapshotCategoryLabel(category)}: ${counts[category]}',
    ].join(' · ');

    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      leading: Icon(
        state == 'failed' ? Icons.error_outline : Icons.backup_outlined,
        color: state == 'failed' ? theme.colorScheme.error : null,
      ),
      title: Text(_backupDateLabel(date)),
      subtitle: Text(
        '${_formatBackupSize(backup.sizeBytes)} · ${_backupStateLabel(state)}',
      ),
      children: [
        ListTile(
          dense: true,
          contentPadding: EdgeInsets.zero,
          title: const Text('Arquivo'),
          subtitle: Text(
            backup.localRef == 'primary-snapshot'
                ? 'Snapshot local do Noema'
                : backup.localRef ?? 'Backup do Noema',
          ),
        ),
        ListTile(
          dense: true,
          contentPadding: EdgeInsets.zero,
          title: const Text('Conteúdo incluído'),
          subtitle: Text(
            countSummary.isEmpty
                ? 'Detalhamento do conteúdo indisponível.'
                : countSummary,
          ),
        ),
        if (backup.snapshotVersion != null)
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('Versão do snapshot'),
            subtitle: Text(backup.snapshotVersion!),
          ),
      ],
    );
  }
}

class _SyncHistoryTile extends StatelessWidget {
  const _SyncHistoryTile({required this.entry});

  final SyncLogOut entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final conflict = entry.result == SyncResult.inConflict;
    final failed = entry.result == SyncResult.failure;
    final details = <String>[
      _historyResultLabel(entry.result.name),
      entry.derection.name == 'upload'
          ? 'Enviado ao Drive'
          : 'Restaurado do Drive',
      if (entry.conflictStrategy != null)
        'Estratégia: ${_conflictStrategyLabel(entry.conflictStrategy!.name)}',
      if (entry.errorDetails?.isNotEmpty == true) entry.errorDetails!,
    ].join(' · ');

    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        conflict
            ? Icons.compare_arrows
            : failed
            ? Icons.error_outline
            : Icons.check_circle_outline,
        color: conflict || failed ? theme.colorScheme.error : null,
      ),
      title: Text(
        '${_historyEventLabel(entry.event)} · ${_backupDateLabel(entry.createdAt)}',
      ),
      subtitle: Text(details),
    );
  }
}

Map<String, int> _backupCounts(BackupFileOut backup) {
  final rawCounts = backup.manifest?['counts']?.value;
  if (rawCounts is! Map) return const {};
  return {
    for (final entry in rawCounts.entries)
      if (entry.key is String)
        entry.key as String: entry.value is JsonObject
            ? ((entry.value as JsonObject).value is int
                  ? (entry.value as JsonObject).value as int
                  : 0)
            : entry.value is int
            ? entry.value as int
            : 0,
  };
}

String _formatBackupSize(int? size) {
  if (size == null) return 'Tamanho indisponível';
  if (size < 1024) return '$size B';
  if (size < 1024 * 1024) return '${(size / 1024).toStringAsFixed(1)} KB';
  if (size < 1024 * 1024 * 1024) {
    return '${(size / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
  return '${(size / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
}

String _backupDateLabel(DateTime? date) {
  if (date == null) return 'Data indisponível';
  return date.toLocal().toString().substring(0, 16);
}

String _backupStateLabel(String state) => switch (state) {
  'completed' => 'Concluído',
  'pending' => 'Pendente',
  'failed' => 'Falhou',
  _ => 'Status desconhecido',
};

String _historyResultLabel(String result) => switch (result) {
  'success' => 'Concluído',
  'failure' => 'Falhou',
  'in_conflict' => 'Conflito',
  _ => 'Resultado desconhecido',
};

String _historyEventLabel(String? event) => switch (event) {
  'backup_created' => 'Backup criado',
  'backup_updated' => 'Backup atualizado',
  'sync_completed' => 'Sincronização',
  'backup_restored' => 'Backup restaurado',
  null || '' => 'Operação de backup',
  _ => event.replaceAll('_', ' '),
};

String _conflictStrategyLabel(String strategy) => switch (strategy) {
  'keep_local' => 'manter local',
  'keep_remote' => 'usar Drive',
  'merge' => 'mesclar',
  'duplicate' => 'duplicar',
  _ => strategy,
};

String googleDriveOperationErrorMessage(Object error) {
  if (error is DriveSyncException) return error.message;
  if (error is DioException) {
    final responseData = error.response?.data;
    final detail = responseData is Map ? responseData['detail'] : null;
    if (detail is String && detail.trim().isNotEmpty) {
      return detail;
    }
    final code = detail is Map ? detail['code'] : null;
    if (code is String) {
      return switch (code) {
        'google_account_already_linked' =>
          'Outra conta Google já está vinculada. Desvincule a conta atual antes de conectar uma diferente.',
        'google_account_unavailable' =>
          'Esta conta Google não pode ser vinculada a este perfil Noema.',
        'google_oauth_not_configured' =>
          'A configuração OAuth está ausente no servidor. A equipe responsável '
              'precisa definir GOOGLE_OAUTH_CLIENT_IDS com os IDs OAuth usados '
              'pelos clientes Google do app (incluindo o cliente Desktop) e '
              'reiniciar a API. Tentar autorizar novamente não resolve.',
        'google_oauth_unavailable' =>
          'A verificação do Google está temporariamente indisponível. Tente novamente em instantes.',
        'google_scope_not_allowed' =>
          'O servidor recusou as permissões solicitadas. O app precisa solicitar somente o acesso privado do Noema.',
        _ => 'O servidor recusou a operação Google (código: $code).',
      };
    }
    final status = error.response?.statusCode;
    if (status == 401 || status == 403) {
      return 'A autorização expirou ou não permite esta operação. '
          'Conecte a conta Google novamente.';
    }
    if (status == 409 || status == 412) {
      return 'O backup mudou durante a operação. Atualize a comparação e tente novamente.';
    }
    if (error.response == null) {
      return 'Não foi possível conectar ao servidor ou ao Google Drive. '
          'Verifique sua conexão e tente novamente.';
    }
    return 'A sincronização falhou (HTTP $status). Nenhuma restauração parcial foi aplicada.';
  }
  if (error is FormatException) return error.message;
  return 'Não foi possível concluir a sincronização. Nenhuma falha foi ocultada; tente novamente.';
}

class _CategoryDifference extends StatelessWidget {
  const _CategoryDifference({required this.category});

  final SnapshotCategoryDiff category;

  @override
  Widget build(BuildContext context) {
    final text = <String>[
      if (category.localOnly > 0) '${category.localOnly} somente local',
      if (category.remoteOnly > 0) '${category.remoteOnly} somente no Drive',
      if (category.changed > 0) '${category.changed} divergentes',
    ].join(' · ');
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.folder_outlined),
      title: Text(snapshotCategoryLabel(category.category)),
      subtitle: Text(text),
    );
  }
}

class _SnapshotChangeTile extends StatelessWidget {
  const _SnapshotChangeTile({required this.change});

  final SnapshotChange change;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final description = switch (change.kind) {
      SnapshotChangeKind.added =>
        change.side == SnapshotSide.local
            ? 'Presente somente neste dispositivo'
            : 'Presente somente no Drive',
      SnapshotChangeKind.removed => 'Ausente de um dos snapshots',
      SnapshotChangeKind.changed => 'Divergente nos dois snapshots',
    };
    final fields = change.fields
        .map((field) => field.replaceAll('_', ' '))
        .join(', ');
    final valueDifferences = [
      for (final field in change.fields)
        if (change.localValues.containsKey(field) ||
            change.remoteValues.containsKey(field))
          '${field.replaceAll('_', ' ')}: '
              '${_previewValue(change.localValues[field])} → '
              '${_previewValue(change.remoteValues[field])}',
    ];
    return Padding(
      padding: EdgeInsets.symmetric(vertical: spacing.xxs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(switch (change.kind) {
            SnapshotChangeKind.added => Icons.add_circle_outline,
            SnapshotChangeKind.removed => Icons.remove_circle_outline,
            SnapshotChangeKind.changed => Icons.compare_arrows,
          }, size: 18),
          SizedBox(width: spacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_tableTitle(change.table)} · $description',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  'Registro ${_shortId(change.rowId)}'
                  '${fields.isEmpty ? '' : ' · $fields'}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                for (final difference in valueDifferences)
                  Text(
                    difference,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _previewValue(Object? value) {
    if (value == null) return '—';
    final normalized = '$value'.replaceAll(RegExp(r'\s+'), ' ').trim();
    if (normalized.isEmpty) return 'vazio';
    return normalized.length <= 72
        ? normalized
        : '${normalized.substring(0, 72)}…';
  }

  String _shortId(String value) =>
      value.length <= 12 ? value : '${value.substring(0, 12)}…';

  String _tableTitle(String table) => switch (table) {
    'knowledge_graph' => 'Grafo',
    'graph_node' => 'Nó',
    'graph_edge' => 'Ligação',
    'graph_version' => 'Versão de grafo',
    'note' => 'Anotação',
    'note_version' => 'Versão de anotação',
    'flashcard' => 'Flashcard',
    'flashcard_group' => 'Grupo de flashcards',
    'multiple_choice' => 'Exercício de múltipla escolha',
    'open_ended' => 'Exercício aberto',
    'study_session' => 'Sessão de estudo',
    'study_session_log' => 'Registro de sessão',
    'theme_selection' => 'Seleção de tema',
    _ => table.replaceAll('_', ' '),
  };
}

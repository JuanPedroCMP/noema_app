import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:noema/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/shared/localization/runtime_localization.dart';
import 'package:noema/feature/config/data/personal_ai_configuration_service.dart';
import 'package:noema/feature/config/providers/config_refresh_provider.dart';

class SharedAiApiKeysSection extends ConsumerStatefulWidget {
  const SharedAiApiKeysSection({super.key, required this.providers});

  final List<PersonalAiProvider> providers;

  @override
  ConsumerState<SharedAiApiKeysSection> createState() =>
      _SharedAiApiKeysSectionState();
}

class _SharedAiApiKeysSectionState
    extends ConsumerState<SharedAiApiKeysSection> {
  List<SharedAiApiKey> _keys = [];
  bool _loading = true;
  bool _saving = false;
  bool _accessDenied = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    ref.listenManual(configRefreshProvider, (previous, next) {
      if (previous != next) _load();
    });
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final keys = await ref
          .read(personalAiConfigurationServiceProvider)
          .listSharedApiKeys();
      if (!mounted) return;
      setState(() {
        _keys = keys;
        _accessDenied = false;
        _loading = false;
      });
    } on DioException catch (error) {
      if (!mounted) return;
      if (error.response?.statusCode == 403) {
        setState(() {
          _accessDenied = true;
          _error = null;
          _loading = false;
        });
        return;
      }
      setState(() {
        _accessDenied = false;
        _error = personalAiErrorMessage(error);
        _loading = false;
      });
    } on Object catch (error) {
      if (!mounted) return;
      setState(() {
        _accessDenied = false;
        _error = personalAiErrorMessage(error);
        _loading = false;
      });
    }
  }

  Future<void> _createKey() async {
    final providers = widget.providers
        .where((provider) => provider.isActive)
        .toList(growable: false);
    if (providers.isEmpty) {
      _message('Nenhum provedor ativo está disponível.');
      return;
    }
    final draft = await _editDialog(providers: providers);
    if (draft == null) return;
    await _mutate(() async {
      await ref
          .read(personalAiConfigurationServiceProvider)
          .createSharedApiKey(
            providerId: draft.providerId!,
            name: draft.name,
            apiKey: draft.apiKey!,
            isActive: draft.isActive,
          );
    }, message: 'Chave compartilhada adicionada.');
  }

  Future<void> _editKey(SharedAiApiKey key) async {
    final draft = await _editDialog(key: key, providers: widget.providers);
    if (draft == null) return;
    await _mutate(() async {
      final data = <String, Object?>{
        'name': draft.name,
        'is_active': draft.isActive,
        if (draft.apiKey != null) 'api_key': draft.apiKey,
      };
      await ref
          .read(personalAiConfigurationServiceProvider)
          .updateSharedApiKey(key.id, data);
    }, message: 'Chave compartilhada atualizada.');
  }

  Future<void> _setActive(SharedAiApiKey key, bool isActive) => _mutate(
    () async {
      await ref.read(personalAiConfigurationServiceProvider).updateSharedApiKey(
        key.id,
        {'is_active': isActive},
      );
    },
    message: isActive ? 'Chave compartilhada ativada.' : 'Chave desativada.',
  );

  Future<void> _mutate(
    Future<void> Function() action, {
    required String message,
  }) async {
    setState(() => _saving = true);
    try {
      await action();
      await _load();
      if (mounted) _message(message);
    } on Object catch (error) {
      if (mounted) _message(personalAiErrorMessage(error));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<_SharedApiKeyDraft?> _editDialog({
    required List<PersonalAiProvider> providers,
    SharedAiApiKey? key,
  }) async {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: key?.name ?? '');
    final apiKeyController = TextEditingController();
    var providerId = key?.providerId ?? providers.firstOrNull?.id;
    var isActive = key?.isActive ?? true;
    try {
      return await showDialog<_SharedApiKeyDraft>(
        context: context,
        builder: (dialogContext) => StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
            title: Text(
              key == null
                  ? 'Adicionar chave compartilhada'
                  : 'Editar chave compartilhada',
            ),
            content: SizedBox(
              width: 440,
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (key == null)
                      DropdownButtonFormField<String>(
                        initialValue: providerId,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.nameIdentifier,
                        ),
                        items: providers
                            .map(
                              (provider) => DropdownMenuItem(
                                value: provider.id,
                                child: Text(provider.displayName),
                              ),
                            )
                            .toList(),
                        onChanged: (value) =>
                            setDialogState(() => providerId = value),
                        validator: (value) =>
                            value == null ? 'Selecione um provedor.' : null,
                      )
                    else
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const RuntimeLocalizedText('Provedor'),
                        subtitle: Text(
                          providers
                                  .where(
                                    (provider) => provider.id == key.providerId,
                                  )
                                  .firstOrNull
                                  ?.displayName ??
                              'Provedor indisponível',
                        ),
                      ),
                    TextFormField(
                      controller: nameController,
                      maxLength: 128,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.nameIdentifyKey,
                      ),
                      validator: (value) => value?.trim().isNotEmpty == true
                          ? null
                          : 'Informe um nome.',
                    ),
                    TextFormField(
                      controller: apiKeyController,
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.apiKey,
                        helperText: key == null
                            ? 'A chave será criptografada e nunca será exibida novamente.'
                            : 'Deixe em branco para manter a chave atual.',
                      ),
                      validator: (value) =>
                          key != null || value?.trim().isNotEmpty == true
                          ? null
                          : 'Informe a chave de API.',
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: RuntimeLocalizedText(
                        'Disponível como fallback',
                      ),
                      value: isActive,
                      onChanged: (value) =>
                          setDialogState(() => isActive = value),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const RuntimeLocalizedText('Cancelar'),
              ),
              FilledButton(
                onPressed: () {
                  if (!formKey.currentState!.validate()) return;
                  Navigator.pop(
                    dialogContext,
                    _SharedApiKeyDraft(
                      providerId: providerId,
                      name: nameController.text.trim(),
                      apiKey: apiKeyController.text.trim().isEmpty
                          ? null
                          : apiKeyController.text.trim(),
                      isActive: isActive,
                    ),
                  );
                },
                child: const RuntimeLocalizedText('Salvar'),
              ),
            ],
          ),
        ),
      );
    } finally {
      nameController.dispose();
      apiKeyController.dispose();
    }
  }

  void _message(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (_error != null) {
      return ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const Icon(Icons.error_outline),
        title: RuntimeLocalizedText(
          'Não foi possível carregar as chaves compartilhadas',
        ),
        subtitle: Text(_error!),
        trailing: IconButton(
          tooltip: AppLocalizations.of(context)!.tryAgain,
          onPressed: _load,
          icon: const Icon(Icons.refresh),
        ),
      );
    }
    if (_accessDenied) {
      return const ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(Icons.lock_outline),
        title: RuntimeLocalizedText('Chaves compartilhadas do servidor'),
        subtitle: RuntimeLocalizedText(
          'Gerenciamento disponível somente para administrador.',
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Estas chaves são usadas como última opção depois das chaves pessoais. '
          'O segredo não é retornado pela API.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerLeft,
          child: FilledButton.icon(
            onPressed: _saving ? null : _createKey,
            icon: const Icon(Icons.add),
            label: const RuntimeLocalizedText('Adicionar chave compartilhada'),
          ),
        ),
        if (_saving) const LinearProgressIndicator(),
        if (_keys.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: RuntimeLocalizedText(
              'Nenhuma chave compartilhada configurada.',
            ),
          )
        else
          for (final key in _keys)
            Card(
              margin: const EdgeInsets.only(top: 8),
              child: ListTile(
                leading: Icon(
                  key.isActive ? Icons.key : Icons.key_off,
                  color: key.isActive
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.outline,
                ),
                title: Text(key.name),
                subtitle: Text(
                  '${widget.providers.where((provider) => provider.id == key.providerId).firstOrNull?.displayName ?? 'Provedor'}'
                  ' · ${key.isActive ? 'Ativa' : 'Desativada'}',
                ),
                trailing: PopupMenuButton<String>(
                  enabled: !_saving,
                  onSelected: (action) {
                    if (action == 'toggle') {
                      _setActive(key, !key.isActive);
                    } else if (action == 'edit') {
                      _editKey(key);
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'toggle',
                      child: Text(key.isActive ? 'Desativar' : 'Ativar'),
                    ),
                    const PopupMenuItem(
                      value: 'edit',
                      child: RuntimeLocalizedText('Editar / substituir chave'),
                    ),
                  ],
                ),
              ),
            ),
      ],
    );
  }
}

class _SharedApiKeyDraft {
  const _SharedApiKeyDraft({
    required this.providerId,
    required this.name,
    required this.apiKey,
    required this.isActive,
  });

  final String? providerId;
  final String name;
  final String? apiKey;
  final bool isActive;
}

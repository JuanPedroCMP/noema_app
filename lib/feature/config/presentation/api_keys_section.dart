import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/network/api_client.dart';
import 'package:noema/feature/config/providers/user_provider.dart';
import 'package:openapi/openapi.dart';

typedef _ApiKeyDraft = ({
  String name,
  String providerId,
  String? apiKey,
  bool isActive,
});

class ApiKeysSection extends ConsumerStatefulWidget {
  const ApiKeysSection({super.key});

  @override
  ConsumerState<ApiKeysSection> createState() => _ApiKeysSectionState();
}

class _ApiKeysSectionState extends ConsumerState<ApiKeysSection> {
  List<ProviderOut> _providers = [];
  List<UserApiKeyOut> _keys = [];
  bool _loading = true;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (mounted) {
      setState(() {
        _loading = true;
        _error = null;
      });
    }
    try {
      final user = await ref.read(userProvider.future);
      final client = ref.read(apiClientProvider);
      final providersResponse = await client
          .getProviderApi()
          .listProvidersApiV1AiProviderListGet(isActive: true);
      final keysResponse = await client
          .getUserApiKeyApi()
          .listUserApiKeyApiV1AiUserApiKeyListGet(idUser: user.remoteId);
      final providers = providersResponse.data;
      final keys = keysResponse.data;
      if (providers == null || keys == null) {
        throw StateError('A API não retornou a lista de integrações.');
      }
      if (!mounted) return;
      setState(() {
        _providers = providers.toList();
        _keys = keys.where((key) => key.idUser == user.remoteId).toList();
        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = 'Não foi possível carregar as chaves de API: $error';
        _loading = false;
      });
    }
  }

  Future<void> _createKey() async {
    if (_providers.isEmpty) {
      _message('Nenhum provedor de IA está disponível no momento.');
      return;
    }
    final draft = await _editDialog(providers: _providers);
    if (draft == null) return;
    setState(() => _saving = true);
    try {
      final response = await ref
          .read(apiClientProvider)
          .getUserApiKeyApi()
          .createUserApiKeyApiV1AiUserApiKeyCreatePost(
            userApiKeyCreate: UserApiKeyCreate((builder) {
              builder
                ..idAiProvider = draft.providerId
                ..name = draft.name
                ..apiKey = draft.apiKey!
                ..isActive = draft.isActive;
            }),
          );
      if (response.data == null) {
        throw StateError('A API não confirmou a criação da chave.');
      }
      final user = await ref.read(userProvider.future);
      if (response.data!.idUser != user.remoteId) {
        throw StateError('A chave criada não pertence ao usuário atual.');
      }
      await _load();
      _message('Chave adicionada. O segredo não é salvo neste dispositivo.');
    } catch (error) {
      _message(
        'Não foi possível adicionar a chave. Verifique o provedor e tente novamente.',
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _editKey(UserApiKeyOut key) async {
    final draft = await _editDialog(providers: _providers, apiKey: key);
    if (draft == null) return;
    setState(() => _saving = true);
    try {
      final response = await ref
          .read(apiClientProvider)
          .getUserApiKeyApi()
          .updateUserApiKeyApiV1AiUserApiKeyUpdateIdentificatorPut(
            identificator: key.id,
            userApiKeyUpdate: UserApiKeyUpdate((builder) {
              builder
                ..idAiProvider = draft.providerId
                ..name = draft.name
                ..isActive = draft.isActive;
              if (draft.apiKey?.isNotEmpty == true) {
                builder.apiKey = draft.apiKey;
              }
            }),
          );
      if (response.data == null || response.data!.idUser != key.idUser) {
        throw StateError('A API não confirmou a atualização da chave.');
      }
      await _load();
      _message('Chave atualizada.');
    } catch (error) {
      _message(
        'Não foi possível atualizar a chave. Revise os dados e tente novamente.',
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _deleteKey(UserApiKeyOut key) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remover chave de API?'),
        content: Text(
          'A chave “${key.name}” deixará de estar disponível para este app.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Remover'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    setState(() => _saving = true);
    try {
      await ref
          .read(apiClientProvider)
          .getUserApiKeyApi()
          .deleteUserApiKeyApiV1AiUserApiKeyDeleteIdentificatorDelete(
            identificator: key.id,
          );
      await _load();
      _message('Chave removida.');
    } catch (error) {
      _message('Não foi possível remover a chave: $error');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<_ApiKeyDraft?> _editDialog({
    required List<ProviderOut> providers,
    UserApiKeyOut? apiKey,
  }) {
    return showDialog<_ApiKeyDraft>(
      context: context,
      builder: (context) => _ApiKeyDialog(providers: providers, apiKey: apiKey),
    );
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
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: CircularProgressIndicator(),
        ),
      );
    }
    if (_error != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_error!),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _load,
            icon: const Icon(Icons.refresh),
            label: const Text('Tentar novamente'),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Cadastre suas chaves para usar os provedores de IA disponíveis. '
          'O segredo é enviado à API e não fica salvo nas preferências locais.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.centerLeft,
          child: FilledButton.icon(
            onPressed: _saving ? null : _createKey,
            icon: const Icon(Icons.add),
            label: const Text('Adicionar chave'),
          ),
        ),
        if (_saving) const LinearProgressIndicator(),
        if (_keys.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Text('Nenhuma chave de API configurada.'),
          )
        else
          for (final key in _keys)
            Card(
              margin: const EdgeInsets.only(top: 12),
              child: ListTile(
                leading: Icon(
                  key.isActive ? Icons.key : Icons.key_off,
                  color: key.isActive
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.outline,
                ),
                title: Text(key.name),
                subtitle: Text(
                  '${_providers.where((provider) => provider.id == key.idAiProvider).firstOrNull?.displayName ?? 'Provedor'}'
                  ' · ${key.isActive ? 'Ativa' : 'Desativada'}',
                ),
                trailing: PopupMenuButton<String>(
                  enabled: !_saving,
                  onSelected: (action) {
                    if (action == 'toggle') {
                      _setActive(key, !key.isActive);
                    } else if (action == 'edit') {
                      _editKey(key);
                    } else if (action == 'models') {
                      _manageModels(key);
                    } else if (action == 'delete') {
                      _deleteKey(key);
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'toggle',
                      child: Text(key.isActive ? 'Desativar' : 'Ativar'),
                    ),
                    const PopupMenuItem(value: 'edit', child: Text('Editar')),
                    const PopupMenuItem(
                      value: 'models',
                      child: Text('Modelos permitidos'),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text('Remover'),
                    ),
                  ],
                ),
              ),
            ),
      ],
    );
  }

  Future<void> _manageModels(UserApiKeyOut key) async {
    await showDialog<void>(
      context: context,
      builder: (context) => _ModelAccessDialog(
        apiKeyId: key.id,
        providerId: key.idAiProvider,
        apiKeyName: key.name,
      ),
    );
  }

  Future<void> _setActive(UserApiKeyOut key, bool isActive) async {
    setState(() => _saving = true);
    try {
      await ref
          .read(apiClientProvider)
          .getUserApiKeyApi()
          .updateUserApiKeyApiV1AiUserApiKeyUpdateIdentificatorPut(
            identificator: key.id,
            userApiKeyUpdate: UserApiKeyUpdate(
              (builder) => builder.isActive = isActive,
            ),
          );
      await _load();
      _message(isActive ? 'Chave ativada.' : 'Chave desativada.');
    } catch (error) {
      _message('Não foi possível alterar o estado da chave. Tente novamente.');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}

class _ModelAccessDialog extends ConsumerStatefulWidget {
  const _ModelAccessDialog({
    required this.apiKeyId,
    required this.providerId,
    required this.apiKeyName,
  });

  final String apiKeyId;
  final String providerId;
  final String apiKeyName;

  @override
  ConsumerState<_ModelAccessDialog> createState() => _ModelAccessDialogState();
}

class _ModelAccessDialogState extends ConsumerState<_ModelAccessDialog> {
  List<AiModelOut> _models = [];
  Map<String, String> _assignedIds = {};
  Set<String> _selectedIds = {};
  bool _loading = true;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final client = ref.read(apiClientProvider);
      final modelResponse = await client
          .getAiModelApi()
          .listAiModelsApiV1AiAiModelListGet(
            idAiProvider: widget.providerId,
            isActive: true,
          );
      final assignedResponse = await client
          .getUserApiKeyCanUseIaModelApi()
          .listAgentModelApiV1AiUserApiKeyCanUseIaModelListGet(
            idUserApiKey: widget.apiKeyId,
          );
      final models = modelResponse.data;
      final assignments = assignedResponse.data;
      if (models == null || assignments == null) {
        throw StateError('A API não retornou os modelos desta chave.');
      }
      final scopedAssignments = assignments
          .where((assignment) => assignment.idUserApiKey == widget.apiKeyId)
          .where(
            (assignment) =>
                models.any((model) => model.id == assignment.idAiModel),
          );
      if (!mounted) return;
      setState(() {
        _models = models.toList();
        _assignedIds = {
          for (final assignment in scopedAssignments)
            assignment.idAiModel: assignment.id,
        };
        _selectedIds = _assignedIds.keys.toSet();
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'Não foi possível carregar os modelos permitidos.';
        _loading = false;
      });
    }
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      final api = ref.read(apiClientProvider).getUserApiKeyCanUseIaModelApi();
      final removed = _assignedIds.keys
          .where((id) => !_selectedIds.contains(id))
          .toList();
      final added = _selectedIds
          .where((id) => !_assignedIds.containsKey(id))
          .toList();

      for (final modelId in removed) {
        await api
            .deleteAgentModelApiV1AiUserApiKeyCanUseIaModelDeleteIdentificatorDelete(
              identificator: _assignedIds[modelId]!,
            );
      }
      for (final modelId in added) {
        final response = await api
            .createAgentModelApiV1AiUserApiKeyCanUseIaModelCreatePost(
              userApiKeyCanUseIaModelCreate: UserApiKeyCanUseIaModelCreate(
                (builder) => builder
                  ..idUserApiKey = widget.apiKeyId
                  ..idAiModel = modelId,
              ),
            );
        if (response.data?.idUserApiKey != widget.apiKeyId) {
          throw StateError('A API não confirmou a permissão do modelo.');
        }
      }
      if (!mounted) return;
      Navigator.pop(context);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _error =
            'Não foi possível salvar todas as permissões. '
            'Reabra a janela para conferir o estado atual.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Modelos para ${widget.apiKeyName}'),
      content: SizedBox(
        width: 440,
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
            ? Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_error!),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: _saving ? null : _load,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Recarregar'),
                  ),
                ],
              )
            : _models.isEmpty
            ? const Text('Este provedor não possui modelos ativos.')
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Selecione os modelos que podem usar esta chave.'),
                  const SizedBox(height: 8),
                  Flexible(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        for (final model in _models)
                          CheckboxListTile(
                            value: _selectedIds.contains(model.id),
                            title: Text(model.displayName),
                            subtitle: Text(model.slug),
                            onChanged: _saving
                                ? null
                                : (selected) {
                                    setState(() {
                                      if (selected == true) {
                                        _selectedIds.add(model.id);
                                      } else {
                                        _selectedIds.remove(model.id);
                                      }
                                    });
                                  },
                          ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        if (!_loading && _error == null && _models.isNotEmpty)
          FilledButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Salvar permissões'),
          ),
      ],
    );
  }
}

class _ApiKeyDialog extends StatefulWidget {
  const _ApiKeyDialog({required this.providers, this.apiKey});

  final List<ProviderOut> providers;
  final UserApiKeyOut? apiKey;

  @override
  State<_ApiKeyDialog> createState() => _ApiKeyDialogState();
}

class _ApiKeyDialogState extends State<_ApiKeyDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _secretController;
  late String? _providerId;
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.apiKey?.name ?? '');
    _secretController = TextEditingController();
    _providerId = widget.apiKey?.idAiProvider ?? widget.providers.first.id;
    _isActive = widget.apiKey?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _secretController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate() || _providerId == null) return;
    final draft = (
      name: _nameController.text.trim(),
      providerId: _providerId!,
      apiKey: _secretController.text.trim().isEmpty
          ? null
          : _secretController.text.trim(),
      isActive: _isActive,
    );
    _secretController.clear();
    Navigator.pop<_ApiKeyDraft>(context, draft);
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.apiKey != null;
    return AlertDialog(
      title: Text(editing ? 'Editar chave de API' : 'Nova chave de API'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                initialValue: _providerId,
                decoration: const InputDecoration(labelText: 'Provedor'),
                items: [
                  if (!widget.providers.any(
                    (provider) => provider.id == _providerId,
                  ))
                    DropdownMenuItem(
                      value: _providerId,
                      child: const Text('Provedor atual (indisponível)'),
                    ),
                  ...widget.providers.map(
                    (provider) => DropdownMenuItem(
                      value: provider.id,
                      child: Text(provider.displayName),
                    ),
                  ),
                ],
                onChanged: (value) => setState(() => _providerId = value),
                validator: (value) =>
                    value == null ? 'Selecione um provedor.' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nome para exibir',
                ),
                textCapitalization: TextCapitalization.sentences,
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Informe um nome.'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _secretController,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  labelText: editing ? 'Nova chave (opcional)' : 'Chave de API',
                  helperText: editing
                      ? 'Deixe vazio para manter a chave atual.'
                      : null,
                ),
                validator: (value) =>
                    !editing && (value == null || value.trim().isEmpty)
                    ? 'Informe a chave.'
                    : editing &&
                          _providerId != widget.apiKey!.idAiProvider &&
                          (value == null || value.trim().isEmpty)
                    ? 'Informe uma chave para o novo provedor.'
                    : null,
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Ativa'),
                value: _isActive,
                onChanged: (value) => setState(() => _isActive = value),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: _submit,
          child: Text(editing ? 'Salvar' : 'Adicionar'),
        ),
      ],
    );
  }
}

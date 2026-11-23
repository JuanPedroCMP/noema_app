import 'package:flutter/material.dart';
import 'package:noema/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/shared/localization/runtime_localization.dart';
import 'package:noema/core/network/connetction_checker.dart';
import 'package:noema/core/network/api_client.dart';
import 'package:noema/feature/config/data/personal_ai_configuration_service.dart';
import 'package:noema/feature/config/presentation/shared_ai_api_keys_section.dart';
import 'package:noema/feature/config/providers/config_refresh_provider.dart';
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
  List<PersonalAiProvider> _providers = [];
  List<UserApiKeyOut> _keys = [];
  bool _loading = true;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    ref.listenManual(configRefreshProvider, (previous, next) {
      if (previous != next) _loadIfConnected();
    });
    ref.listenManual(serverConnectionChecker, (previous, next) {
      if (next.value == true && previous?.value != true) _load();
    });
    _loadIfConnected();
  }

  Future<void> _loadIfConnected() async {
    final isConnected =
        (ref.read(serverConnectionChecker).value ??
            await ref.read(serverConnectionChecker.future)) ==
        true;
    if (isConnected) {
      await _load();
    } else if (mounted) {
      setState(() {
        _error = 'Conecte-se à internet para carregar as chaves do servidor.';
        _loading = false;
      });
    }
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
      final providers = await ref
          .read(personalAiConfigurationServiceProvider)
          .listProviders();
      final keysResponse = await client
          .getUserApiKeyApi()
          .listUserApiKeyApiV1AiUserApiKeyListGet(idUser: user.remoteId);
      final keys = keysResponse.data;
      if (keys == null) {
        throw StateError('A API não retornou a lista de integrações.');
      }
      if (!mounted) return;
      setState(() {
        _providers = providers;
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
    final availableProviders = _providers
        .where((provider) => provider.isActive)
        .toList(growable: false);
    if (availableProviders.isEmpty) {
      _message('Nenhum provedor ativo está disponível no momento.');
      return;
    }
    final draft = await _editDialog(providers: availableProviders);
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
                ..apiKey = draft.apiKey ?? ''
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
      try {
        final enabledModelCount = await _allowAllProviderModels(
          response.data!.id,
          draft.providerId,
        );
        await _load();
        _message(
          enabledModelCount == 0
              ? 'Chave adicionada. Não há modelos ativos para este provedor; '
                    'o acesso pode ser configurado depois.'
              : 'Chave adicionada com acesso aos $enabledModelCount modelos '
                    'ativos do provedor. O segredo não é salvo neste dispositivo.',
        );
      } catch (_) {
        await _load();
        _message(
          'A chave foi criada, mas não foi possível liberar todos os modelos. '
          'Revise “Modelos permitidos” na chave.',
        );
        return;
      }
    } catch (error) {
      _message(
        'Não foi possível adicionar a chave. Verifique o provedor e tente novamente.',
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<int> _allowAllProviderModels(
    String apiKeyId,
    String providerId,
  ) async {
    final models = await ref
        .read(personalAiConfigurationServiceProvider)
        .listModels();
    final providerModels = models
        .where((model) => model.providerId == providerId && model.isActive)
        .toList();
    if (providerModels.isEmpty) return 0;

    final api = ref.read(apiClientProvider).getUserApiKeyCanUseIaModelApi();
    final assignedResponse = await api
        .listAgentModelApiV1AiUserApiKeyCanUseIaModelListGet(
          idUserApiKey: apiKeyId,
        );
    final assignments = assignedResponse.data;
    if (assignments == null) {
      throw StateError('A API não retornou as permissões da chave.');
    }

    final assignedIds = assignments
        .where((assignment) => assignment.idUserApiKey == apiKeyId)
        .map((assignment) => assignment.idAiModel)
        .toSet();
    for (final model in providerModels) {
      if (assignedIds.contains(model.id)) continue;
      final response = await api
          .createAgentModelApiV1AiUserApiKeyCanUseIaModelCreatePost(
            userApiKeyCanUseIaModelCreate: UserApiKeyCanUseIaModelCreate(
              (builder) => builder
                ..idUserApiKey = apiKeyId
                ..idAiModel = model.id,
            ),
          );
      if (response.data?.idUserApiKey != apiKeyId ||
          response.data?.idAiModel != model.id) {
        throw StateError('A API não confirmou o acesso ao modelo.');
      }
    }
    return providerModels.length;
  }

  Future<void> _editKey(UserApiKeyOut key) async {
    final availableProviders = _providers
        .where(
          (provider) => provider.isActive || provider.id == key.idAiProvider,
        )
        .toList(growable: false);
    final draft = await _editDialog(providers: availableProviders, apiKey: key);
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
              if (draft.apiKey != null ||
                  draft.providerId != key.idAiProvider) {
                builder.apiKey = draft.apiKey ?? '';
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
        title: const RuntimeLocalizedText('Remover chave de API?'),
        content: Text(
          'A chave “${key.name}” deixará de estar disponível para este app.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const RuntimeLocalizedText('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const RuntimeLocalizedText('Remover'),
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
    required List<PersonalAiProvider> providers,
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
            onPressed: _loadIfConnected,
            icon: const Icon(Icons.refresh),
            label: const RuntimeLocalizedText('Tentar novamente'),
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
            label: const RuntimeLocalizedText('Adicionar chave'),
          ),
        ),
        if (_saving) const LinearProgressIndicator(),
        if (_keys.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: RuntimeLocalizedText('Nenhuma chave de API configurada.'),
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
                title: Text(
                  key.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  '${_providers.where((provider) => provider.id == key.idAiProvider).firstOrNull?.displayName ?? 'Provedor'}'
                  ' · ${key.isActive ? 'Ativa' : 'Desativada'}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      tooltip: AppLocalizations.of(context)!.explanation,
                      onPressed: _saving ? null : () => _manageModels(key),
                      icon: const Icon(Icons.tune_rounded),
                    ),
                    PopupMenuButton<String>(
                      enabled: !_saving,
                      onSelected: (action) {
                        if (action == 'toggle') {
                          _setActive(key, !key.isActive);
                        } else if (action == 'edit') {
                          _editKey(key);
                        } else if (action == 'delete') {
                          _deleteKey(key);
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'toggle',
                          child: Text(key.isActive ? 'Desativar' : 'Ativar'),
                        ),
                        const PopupMenuItem(
                          value: 'edit',
                          child: RuntimeLocalizedText('Editar'),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: RuntimeLocalizedText('Remover'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        const SizedBox(height: 24),
        const Divider(),
        const SizedBox(height: 16),
        Text(
          'Chaves compartilhadas do servidor',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        SharedAiApiKeysSection(providers: _providers),
      ],
    );
  }

  Future<void> _manageModels(UserApiKeyOut key) async {
    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => _ModelAccessDialog(
        apiKeyId: key.id,
        providerId: key.idAiProvider,
        apiKeyName: key.name,
      ),
    );
    if (saved == true) {
      _message('Permissões de modelos atualizadas.');
    }
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
  final TextEditingController _searchController = TextEditingController();
  List<PersonalAiModel> _models = [];
  Map<String, String> _assignedIds = {};
  Set<String> _selectedIds = {};
  String _searchQuery = '';
  bool _loading = true;
  bool _saving = false;
  String? _error;

  int get _selectedActiveCount => _models
      .where((model) => model.isActive && _selectedIds.contains(model.id))
      .length;

  int get _selectedInactiveCount => _models
      .where((model) => !model.isActive && _selectedIds.contains(model.id))
      .length;

  int get _activeModelCount => _models.where((model) => model.isActive).length;

  bool get _allActiveSelected =>
      _activeModelCount > 0 && _selectedActiveCount == _activeModelCount;

  bool get _hasChanges =>
      _selectedIds.length != _assignedIds.length ||
      !_selectedIds.containsAll(_assignedIds.keys);

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleAllActive() {
    setState(() {
      final activeIds = _models
          .where((model) => model.isActive)
          .map((model) => model.id)
          .toSet();
      if (_allActiveSelected) {
        _selectedIds.removeAll(activeIds);
      } else {
        _selectedIds.addAll(activeIds);
      }
    });
  }

  void _clearSelection() {
    setState(_selectedIds.clear);
  }

  void _invertActiveSelection() {
    setState(() {
      for (final model in _models.where((model) => model.isActive)) {
        if (!_selectedIds.add(model.id)) _selectedIds.remove(model.id);
      }
    });
  }

  void _setModelSelected(String modelId, bool selected) {
    setState(() {
      if (selected) {
        _selectedIds.add(modelId);
      } else {
        _selectedIds.remove(modelId);
      }
    });
  }

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
      final models = await ref
          .read(personalAiConfigurationServiceProvider)
          .listModels();
      final assignedResponse = await client
          .getUserApiKeyCanUseIaModelApi()
          .listAgentModelApiV1AiUserApiKeyCanUseIaModelListGet(
            idUserApiKey: widget.apiKeyId,
          );
      final assignments = assignedResponse.data;
      if (assignments == null) {
        throw StateError('A API não retornou os modelos desta chave.');
      }
      final providerModels =
          models
              .where((model) => model.providerId == widget.providerId)
              .toList()
            ..sort((a, b) {
              if (a.isActive != b.isActive) return a.isActive ? -1 : 1;
              return a.displayName.toLowerCase().compareTo(
                b.displayName.toLowerCase(),
              );
            });
      final scopedAssignments = assignments
          .where((assignment) => assignment.idUserApiKey == widget.apiKeyId)
          .where(
            (assignment) =>
                providerModels.any((model) => model.id == assignment.idAiModel),
          );
      if (!mounted) return;
      setState(() {
        _models = providerModels;
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
        if (response.data?.idUserApiKey != widget.apiKeyId ||
            response.data?.idAiModel != modelId) {
          throw StateError('A API não confirmou a permissão do modelo.');
        }
      }
      if (!mounted) return;
      Navigator.pop(context, true);
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
    final normalizedQuery = _searchQuery.trim().toLowerCase();
    final visibleModels = _models
        .where(
          (model) =>
              normalizedQuery.isEmpty ||
              model.displayName.toLowerCase().contains(normalizedQuery) ||
              model.slug.toLowerCase().contains(normalizedQuery),
        )
        .toList();
    final activeProgress = _activeModelCount == 0
        ? 0.0
        : _selectedActiveCount / _activeModelCount;

    return AlertDialog(
      title: RuntimeLocalizedText('Modelos para ${widget.apiKeyName}'),
      content: SizedBox(
        width: 520,
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
                    label: const RuntimeLocalizedText('Recarregar'),
                  ),
                ],
              )
            : _models.isEmpty
            ? RuntimeLocalizedText(
                'Nenhum modelo foi cadastrado para este provedor.',
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '$_selectedActiveCount de $_activeModelCount modelos ativos selecionados',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  if (_selectedInactiveCount > 0) ...[
                    const SizedBox(height: 4),
                    Text(
                      '$_selectedInactiveCount modelo(s) inativo(s) ainda com acesso. '
                      'Desmarque para revogar.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                  const SizedBox(height: 8),
                  LinearProgressIndicator(value: activeProgress),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _searchController,
                    onChanged: (value) => setState(() => _searchQuery = value),
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.allowedModels,
                      hintText: AppLocalizations.of(context)!.searchModel,
                      prefixIcon: const Icon(Icons.search_rounded),
                      suffixIcon: _searchQuery.isEmpty
                          ? null
                          : IconButton(
                              tooltip: AppLocalizations.of(context)!.textClearSearch,
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _searchQuery = '');
                              },
                              icon: const Icon(Icons.close_rounded),
                            ),
                      isDense: true,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      FilledButton.tonalIcon(
                        onPressed: _saving || _activeModelCount == 0
                            ? null
                            : _toggleAllActive,
                        icon: Icon(
                          _allActiveSelected
                              ? Icons.deselect
                              : Icons.select_all,
                          size: 18,
                        ),
                        label: Text(
                          _allActiveSelected
                              ? 'Desmarcar ativos'
                              : 'Selecionar todos',
                        ),
                      ),
                      TextButton.icon(
                        onPressed: _saving || _activeModelCount == 0
                            ? null
                            : _invertActiveSelection,
                        icon: const Icon(Icons.swap_vert_rounded, size: 18),
                        label: const RuntimeLocalizedText('Inverter ativos'),
                      ),
                      TextButton.icon(
                        onPressed: _saving || _selectedIds.isEmpty
                            ? null
                            : _clearSelection,
                        icon: const Icon(Icons.deselect, size: 18),
                        label: const RuntimeLocalizedText('Limpar'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (visibleModels.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Text(
                        'Nenhum modelo encontrado para “$_searchQuery”.',
                        textAlign: TextAlign.center,
                      ),
                    )
                  else
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.sizeOf(context).height * 0.45,
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: visibleModels.length,
                        separatorBuilder: (context, index) =>
                            const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final model = visibleModels[index];
                          final isSelected = _selectedIds.contains(model.id);
                          return CheckboxListTile(
                            dense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 4,
                            ),
                            controlAffinity: ListTileControlAffinity.leading,
                            value: isSelected,
                            title: Text(model.displayName),
                            subtitle: Text(
                              model.isActive
                                  ? model.slug
                                  : '${model.slug} · Inativo',
                            ),
                            secondary: model.supportsVision
                                ? const Tooltip(
                                    message: 'Suporta imagens',
                                    child: Icon(Icons.visibility_outlined),
                                  )
                                : null,
                            onChanged:
                                _saving || (!model.isActive && !isSelected)
                                ? null
                                : (selected) => _setModelSelected(
                                    model.id,
                                    selected == true,
                                  ),
                          );
                        },
                      ),
                    ),
                ],
              ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.pop(context),
          child: const RuntimeLocalizedText('Cancelar'),
        ),
        if (!_loading && _error == null && _models.isNotEmpty)
          FilledButton(
            onPressed: _saving || !_hasChanges ? null : _save,
            child: _saving
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const RuntimeLocalizedText('Salvar permissões'),
          ),
      ],
    );
  }
}

class _ApiKeyDialog extends StatefulWidget {
  const _ApiKeyDialog({required this.providers, this.apiKey});

  final List<PersonalAiProvider> providers;
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

  bool get _allowsEmptyKey =>
      widget.providers
          .where((provider) => provider.id == _providerId)
          .firstOrNull
          ?.protocol ==
      'openai_compatible';

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
                decoration: InputDecoration(labelText: AppLocalizations.of(context)!.nameIdentifier),
                items: [
                  if (!widget.providers.any(
                    (provider) => provider.id == _providerId,
                  ))
                    DropdownMenuItem(
                      value: _providerId,
                      child: RuntimeLocalizedText(
                        'Provedor atual (indisponível)',
                      ),
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
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.provider,
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
                  helperText: _allowsEmptyKey
                      ? 'Deixe vazio apenas se o provedor OpenAI-compatible não exigir segredo (por exemplo, um servidor local).'
                      : editing
                      ? 'Deixe vazio para manter a chave atual.'
                      : null,
                ),
                validator: (value) =>
                    !editing &&
                        !_allowsEmptyKey &&
                        (value == null || value.trim().isEmpty)
                    ? 'Informe a chave.'
                    : editing &&
                          _providerId != widget.apiKey!.idAiProvider &&
                          !_allowsEmptyKey &&
                          (value == null || value.trim().isEmpty)
                    ? 'Informe uma chave para o novo provedor.'
                    : null,
              ),
              if (!editing) ...[
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      size: 18,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Ao adicionar, todos os modelos ativos deste provedor '
                        'serão liberados para a chave. Você pode ajustar isso depois.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ],
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const RuntimeLocalizedText('Ativa'),
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
          child: const RuntimeLocalizedText('Cancelar'),
        ),
        FilledButton(
          onPressed: _submit,
          child: Text(editing ? 'Salvar' : 'Adicionar'),
        ),
      ],
    );
  }
}

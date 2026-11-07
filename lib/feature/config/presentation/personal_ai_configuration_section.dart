import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/network/connetction_checker.dart';
import 'package:noema/feature/config/providers/config_refresh_provider.dart';
import 'package:noema/feature/config/data/personal_ai_configuration_service.dart';
import 'package:openapi/openapi.dart';

class PersonalAiConfigurationSection extends ConsumerStatefulWidget {
  const PersonalAiConfigurationSection({super.key});

  @override
  ConsumerState<PersonalAiConfigurationSection> createState() =>
      _PersonalAiConfigurationSectionState();
}

class _PersonalAiConfigurationSectionState
    extends ConsumerState<PersonalAiConfigurationSection> {
  PersonalAiConfiguration? _configuration;
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
        _error = 'Conecte-se à internet para carregar a configuração de IA.';
        _loading = false;
      });
    }
  }

  Future<void> _load({bool showLoading = true}) async {
    setState(() {
      if (showLoading) _loading = true;
      _error = null;
    });
    try {
      final configuration = await ref
          .read(personalAiConfigurationServiceProvider)
          .load();
      if (!mounted) return;
      setState(() {
        _configuration = configuration;
        _loading = false;
      });
    } on Object catch (error) {
      if (!mounted) return;
      setState(() {
        _error = personalAiErrorMessage(error);
        _loading = false;
      });
    }
  }

  Future<void> _mutate<T>(
    Future<T> Function() action, {
    required String successMessage,
  }) async {
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await action();
      if (!mounted) return;
      _message(successMessage);
      await _load(showLoading: false);
    } on Object catch (error) {
      if (!mounted) return;
      setState(() {
        _error = personalAiErrorMessage(error);
      });
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _createProvider() async {
    final values = await _showEditor(
      title: 'Adicionar provedor OpenAI-compatible',
      fields: [
        _EditorField(
          key: 'display_name',
          label: 'Nome para exibir',
          kind: _FieldKind.text,
          required: true,
          maxLength: 64,
        ),
        _EditorField(
          key: 'slug',
          label: 'Identificador (slug)',
          kind: _FieldKind.slug,
          required: true,
          maxLength: 64,
          helperText: 'Ex.: lm-studio, ollama ou meu-servidor',
        ),
        _EditorField(
          key: 'base_url',
          label: 'URL base',
          kind: _FieldKind.url,
          required: true,
          maxLength: 2048,
          helperText:
              'Informe a URL completa da API, normalmente terminada em /v1.',
        ),
      ],
      note:
          'Por segurança, a API valida a URL e exige HTTPS, exceto quando o próprio servidor permite conexões locais. Para modelos locais, a API precisa estar na mesma máquina e permitir AI_ALLOW_LOCAL_AI=true; localhost no app não aponta para o seu computador quando a API está remota.',
    );
    if (values == null) return;
    await _mutate(() async {
      await ref
          .read(personalAiConfigurationServiceProvider)
          .createProvider(
            slug: values['slug']! as String,
            displayName: values['display_name']! as String,
            baseUrl: values['base_url']! as String,
          );
    }, successMessage: 'Provedor adicionado.');
  }

  Future<void> _editProvider(PersonalAiProvider provider) async {
    final values = await _showEditor(
      title: 'Editar provedor',
      fields: [
        _EditorField(
          key: 'display_name',
          label: 'Nome para exibir',
          initialValue: provider.displayName,
          kind: _FieldKind.text,
          required: true,
          maxLength: 64,
        ),
        _EditorField(
          key: 'slug',
          label: 'Identificador (slug)',
          initialValue: provider.slug,
          kind: _FieldKind.slug,
          required: true,
          maxLength: 64,
        ),
        _EditorField(
          key: 'base_url',
          label: 'URL base',
          initialValue: provider.baseUrl ?? '',
          kind: _FieldKind.url,
          required: true,
          maxLength: 2048,
          helperText: 'Informe a URL completa, normalmente terminada em /v1.',
        ),
        _EditorField(
          key: 'is_active',
          label: 'Disponibilidade',
          initialValue: provider.isActive ? 'true' : 'false',
          kind: _FieldKind.boolean,
          choices: const {'true': 'Ativo', 'false': 'Desativado'},
        ),
      ],
    );
    if (values == null) return;
    await _mutate(
      () async => ref
          .read(personalAiConfigurationServiceProvider)
          .updateProvider(provider.id, values),
      successMessage: 'Provedor atualizado.',
    );
  }

  Future<void> _createModel() async {
    final config = _configuration!;
    final providers = config.providers.where((item) => item.isOwned).toList();
    if (providers.isEmpty) {
      _message('Adicione primeiro um provedor próprio para cadastrar modelos.');
      return;
    }
    final values = await _showEditor(
      title: 'Adicionar modelo',
      fields: [
        _EditorField(
          key: 'id_ai_provider',
          label: 'Provedor',
          kind: _FieldKind.choice,
          choices: {for (final item in providers) item.id: item.displayName},
          required: true,
        ),
        _EditorField(
          key: 'display_name',
          label: 'Nome para exibir',
          kind: _FieldKind.text,
          required: true,
          maxLength: 64,
        ),
        _EditorField(
          key: 'slug',
          label: 'Identificador do modelo',
          kind: _FieldKind.text,
          required: true,
          maxLength: 64,
          helperText:
              'Use o ID exato do endpoint; barras e tags como :14b são válidas.',
        ),
        _EditorField(
          key: 'context_window',
          label: 'Janela de contexto (tokens)',
          kind: _FieldKind.positiveInteger,
          required: true,
        ),
        _EditorField(
          key: 'input_token_limit',
          label: 'Limite de tokens de entrada',
          kind: _FieldKind.positiveInteger,
          required: true,
        ),
        _EditorField(
          key: 'output_token_limit',
          label: 'Limite de tokens de saída',
          kind: _FieldKind.positiveInteger,
          required: true,
        ),
        _EditorField(
          key: 'supports_vision',
          label: 'Visão',
          initialValue: 'false',
          kind: _FieldKind.boolean,
          choices: const {'true': 'Compatível', 'false': 'Não compatível'},
        ),
      ],
    );
    if (values == null) return;
    await _mutate(
      () async =>
          ref.read(personalAiConfigurationServiceProvider).createModel(values),
      successMessage: 'Modelo adicionado.',
    );
  }

  Future<void> _editModel(PersonalAiModel model) async {
    final config = _configuration!;
    final providers = config.providers.where((item) => item.isOwned).toList();
    if (providers.isEmpty) return;
    final values = await _showEditor(
      title: 'Editar modelo',
      fields: [
        _EditorField(
          key: 'id_ai_provider',
          label: 'Provedor',
          initialValue: model.providerId,
          kind: _FieldKind.choice,
          choices: {for (final item in providers) item.id: item.displayName},
          required: true,
        ),
        _EditorField(
          key: 'display_name',
          label: 'Nome para exibir',
          initialValue: model.displayName,
          kind: _FieldKind.text,
          required: true,
          maxLength: 64,
        ),
        _EditorField(
          key: 'slug',
          label: 'Identificador do modelo',
          initialValue: model.slug,
          kind: _FieldKind.text,
          required: true,
          maxLength: 64,
          helperText:
              'Use o ID exato do endpoint; barras e tags como :14b são válidas.',
        ),
        _EditorField(
          key: 'context_window',
          label: 'Janela de contexto (tokens)',
          initialValue: model.contextWindow?.toString(),
          kind: _FieldKind.positiveInteger,
          required: true,
        ),
        _EditorField(
          key: 'input_token_limit',
          label: 'Limite de tokens de entrada',
          initialValue: model.inputTokenLimit?.toString(),
          kind: _FieldKind.positiveInteger,
          required: true,
        ),
        _EditorField(
          key: 'output_token_limit',
          label: 'Limite de tokens de saída',
          initialValue: model.outputTokenLimit?.toString(),
          kind: _FieldKind.positiveInteger,
          required: true,
        ),
        _EditorField(
          key: 'supports_vision',
          label: 'Visão',
          initialValue: model.supportsVision ? 'true' : 'false',
          kind: _FieldKind.boolean,
          choices: const {'true': 'Compatível', 'false': 'Não compatível'},
        ),
        _EditorField(
          key: 'is_active',
          label: 'Disponibilidade',
          initialValue: model.isActive ? 'true' : 'false',
          kind: _FieldKind.boolean,
          choices: const {'true': 'Ativo', 'false': 'Desativado'},
        ),
      ],
    );
    if (values == null) return;
    await _mutate(
      () async => ref
          .read(personalAiConfigurationServiceProvider)
          .updateModel(model.id, values),
      successMessage: 'Modelo atualizado.',
    );
  }

  Future<void> _createAgent() async {
    final values = await _showEditor(
      title: 'Adicionar agente',
      fields: [
        _EditorField(
          key: 'alias',
          label: 'Nome do agente',
          kind: _FieldKind.text,
          required: true,
          maxLength: 64,
        ),
        _EditorField(
          key: 'task',
          label: 'Tarefa',
          kind: _FieldKind.choice,
          choices: _taskChoices,
          required: true,
        ),
        _EditorField(
          key: 'base_system_prompt',
          label: 'Instruções do sistema',
          kind: _FieldKind.multiline,
          required: true,
        ),
        _EditorField(
          key: 'temperature',
          label: 'Temperatura (opcional)',
          kind: _FieldKind.temperature,
          helperText: 'Valor entre 0 e 2; deixe vazio para usar o padrão.',
        ),
      ],
      note:
          'Depois de criar o agente, escolha os modelos de IA disponíveis para ele.',
    );
    if (values == null) return;
    await _mutate(
      () async =>
          ref.read(personalAiConfigurationServiceProvider).createAgent(values),
      successMessage: 'Agente adicionado.',
    );
  }

  Future<void> _editAgent(PersonalAiAgent agent) async {
    final values = await _showEditor(
      title: 'Editar agente',
      fields: [
        _EditorField(
          key: 'alias',
          label: 'Nome do agente',
          initialValue: agent.alias,
          kind: _FieldKind.text,
          required: true,
          maxLength: 64,
        ),
        _EditorField(
          key: 'task',
          label: 'Tarefa',
          initialValue: agent.task,
          kind: _FieldKind.choice,
          choices: _taskChoices,
          required: true,
        ),
        _EditorField(
          key: 'base_system_prompt',
          label: 'Instruções do sistema',
          initialValue: agent.baseSystemPrompt,
          kind: _FieldKind.multiline,
          required: true,
        ),
        _EditorField(
          key: 'temperature',
          label: 'Temperatura (opcional)',
          initialValue: agent.temperature?.toString(),
          kind: _FieldKind.temperature,
          helperText: 'Valor entre 0 e 2.',
        ),
        _EditorField(
          key: 'is_active',
          label: 'Disponibilidade',
          initialValue: agent.isActive ? 'true' : 'false',
          kind: _FieldKind.boolean,
          choices: const {'true': 'Ativo', 'false': 'Desativado'},
        ),
      ],
    );
    if (values == null) return;
    await _mutate(
      () async => ref
          .read(personalAiConfigurationServiceProvider)
          .updateAgent(agent.id, values),
      successMessage: 'Agente atualizado.',
    );
  }

  Future<void> _createAgentModel(PersonalAiAgent agent) async {
    final config = _configuration!;
    final models = config.models;
    if (models.isEmpty) {
      _message('Cadastre ou ative um modelo antes de vinculá-lo ao agente.');
      return;
    }
    final values = await _showEditor(
      title: 'Modelo para ${agent.alias}',
      fields: [
        _EditorField(
          key: 'id_ai_model',
          label: 'Modelo',
          kind: _FieldKind.choice,
          choices: {
            for (final model in models)
              model.id:
                  '${model.displayName} · ${_providerName(model.providerId)}',
          },
          required: true,
        ),
        _EditorField(
          key: 'quality_expected',
          label: 'Qualidade esperada',
          initialValue: 'good',
          kind: _FieldKind.choice,
          choices: _qualityChoices,
          required: true,
        ),
        _EditorField(
          key: 'custom_system_prompt',
          label: 'Instruções adicionais (opcional)',
          kind: _FieldKind.multiline,
        ),
        _EditorField(
          key: 'temperature',
          label: 'Temperatura (opcional)',
          kind: _FieldKind.temperature,
          helperText: 'Valor entre 0 e 2; deixe vazio para usar o padrão.',
        ),
      ],
    );
    if (values == null) return;
    values['id_agent'] = agent.id;
    values['custom_system_prompt'] ??= '';
    await _mutate(
      () async => ref
          .read(personalAiConfigurationServiceProvider)
          .createAgentModel(values),
      successMessage: 'Modelo vinculado ao agente.',
    );
  }

  Future<void> _editAgentModel(PersonalAiAgentModel link) async {
    final config = _configuration!;
    final models = config.models;
    final values = await _showEditor(
      title: 'Editar modelo do agente',
      fields: [
        _EditorField(
          key: 'id_ai_model',
          label: 'Modelo',
          initialValue: link.modelId,
          kind: _FieldKind.choice,
          choices: {
            for (final model in models)
              model.id:
                  '${model.displayName} · ${_providerName(model.providerId)}',
          },
          required: true,
        ),
        _EditorField(
          key: 'quality_expected',
          label: 'Qualidade esperada',
          initialValue: link.qualityExpected ?? 'good',
          kind: _FieldKind.choice,
          choices: _qualityChoices,
          required: true,
        ),
        _EditorField(
          key: 'custom_system_prompt',
          label: 'Instruções adicionais',
          initialValue: link.customSystemPrompt,
          kind: _FieldKind.multiline,
        ),
        _EditorField(
          key: 'custom_temperature',
          label: 'Temperatura personalizada (opcional)',
          initialValue: link.temperature?.toString(),
          kind: _FieldKind.temperature,
          helperText: 'Valor entre 0 e 2.',
        ),
        _EditorField(
          key: 'is_active',
          label: 'Disponibilidade',
          initialValue: link.isActive ? 'true' : 'false',
          kind: _FieldKind.boolean,
          choices: const {'true': 'Ativo', 'false': 'Desativado'},
        ),
      ],
    );
    if (values == null) return;
    values['custom_system_prompt'] ??= '';
    await _mutate(
      () async => ref
          .read(personalAiConfigurationServiceProvider)
          .updateAgentModel(link.id, values),
      successMessage: 'Vínculo atualizado.',
    );
  }

  Future<void> _deactivate({
    required String title,
    required String description,
    required Future<void> Function() action,
    required String successMessage,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(description),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Desativar'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await _mutate(action, successMessage: successMessage);
  }

  Future<Map<String, Object?>?> _showEditor({
    required String title,
    required List<_EditorField> fields,
    String? note,
  }) async {
    final formKey = GlobalKey<FormState>();
    final controllers = <String, TextEditingController>{};
    final selectedValues = <String, String?>{};
    for (final field in fields) {
      if (field.kind == _FieldKind.choice || field.kind == _FieldKind.boolean) {
        final initial = field.initialValue;
        selectedValues[field.key] =
            initial != null && field.choices.containsKey(initial)
            ? initial
            : field.choices.keys.firstOrNull;
      } else {
        controllers[field.key] = TextEditingController(
          text: field.initialValue ?? '',
        );
      }
    }

    try {
      return await showDialog<Map<String, Object?>>(
        context: context,
        builder: (context) => StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
            title: Text(title),
            content: SizedBox(
              width: 520,
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (note != null) ...[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            note,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      for (final field in fields) ...[
                        if (field.kind == _FieldKind.choice ||
                            field.kind == _FieldKind.boolean)
                          DropdownButtonFormField<String>(
                            initialValue: selectedValues[field.key],
                            isExpanded: true,
                            decoration: InputDecoration(
                              labelText: field.label,
                              helperText: field.helperText,
                            ),
                            items: field.choices.entries
                                .map(
                                  (item) => DropdownMenuItem(
                                    value: item.key,
                                    child: Text(item.value),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) => setDialogState(
                              () => selectedValues[field.key] = value,
                            ),
                            validator: field.required
                                ? (value) => value == null
                                      ? 'Escolha uma opção.'
                                      : null
                                : null,
                          )
                        else
                          TextFormField(
                            controller: controllers[field.key],
                            decoration: InputDecoration(
                              labelText: field.label,
                              helperText: field.helperText,
                              alignLabelWithHint:
                                  field.kind == _FieldKind.multiline,
                            ),
                            minLines: field.kind == _FieldKind.multiline
                                ? 3
                                : 1,
                            maxLines: field.kind == _FieldKind.multiline
                                ? 7
                                : 1,
                            keyboardType: switch (field.kind) {
                              _FieldKind.positiveInteger =>
                                TextInputType.number,
                              _FieldKind.temperature =>
                                const TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                              _FieldKind.url => TextInputType.url,
                              _ => TextInputType.text,
                            },
                            textCapitalization:
                                field.kind == _FieldKind.multiline
                                ? TextCapitalization.sentences
                                : TextCapitalization.none,
                            autocorrect: field.kind == _FieldKind.multiline,
                            maxLength: field.maxLength,
                            validator: (value) =>
                                _validateField(field, value ?? ''),
                          ),
                        const SizedBox(height: 10),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              FilledButton(
                onPressed: () {
                  if (!formKey.currentState!.validate()) return;
                  final result = <String, Object?>{};
                  for (final field in fields) {
                    if (field.kind == _FieldKind.choice ||
                        field.kind == _FieldKind.boolean) {
                      final value = selectedValues[field.key];
                      if (value != null) {
                        result[field.key] = field.kind == _FieldKind.boolean
                            ? value == 'true'
                            : value;
                      }
                      continue;
                    }
                    final text = controllers[field.key]!.text.trim();
                    if (text.isEmpty) {
                      result[field.key] = null;
                    } else {
                      result[field.key] = switch (field.kind) {
                        _FieldKind.positiveInteger => int.parse(text),
                        _FieldKind.temperature => double.parse(text),
                        _ => text,
                      };
                    }
                  }
                  Navigator.pop(context, result);
                },
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      );
    } finally {
      for (final controller in controllers.values) {
        controller.dispose();
      }
    }
  }

  String? _validateField(_EditorField field, String value) {
    final normalized = value.trim();
    if (normalized.isEmpty) {
      return field.required ? 'Preencha este campo.' : null;
    }
    if (field.maxLength != null && normalized.length > field.maxLength!) {
      return 'Use no máximo ${field.maxLength} caracteres.';
    }
    switch (field.kind) {
      case _FieldKind.slug:
        if (!RegExp(r'^[a-zA-Z0-9][a-zA-Z0-9._-]*$').hasMatch(normalized)) {
          return 'Use letras, números, ponto, hífen ou sublinhado.';
        }
      case _FieldKind.url:
        final uri = Uri.tryParse(normalized);
        if (uri == null ||
            !const {'http', 'https'}.contains(uri.scheme.toLowerCase()) ||
            uri.host.isEmpty ||
            uri.userInfo.isNotEmpty) {
          return 'Informe uma URL http:// ou https:// válida, sem credenciais.';
        }
      case _FieldKind.positiveInteger:
        final parsed = int.tryParse(normalized);
        if (parsed == null || parsed <= 0) {
          return 'Informe um número inteiro maior que zero.';
        }
      case _FieldKind.temperature:
        final parsed = double.tryParse(normalized);
        if (parsed == null || parsed < 0 || parsed > 2) {
          return 'Informe um valor entre 0 e 2.';
        }
      case _FieldKind.text:
      case _FieldKind.multiline:
      case _FieldKind.choice:
      case _FieldKind.boolean:
        break;
    }
    return null;
  }

  String _providerName(String providerId) =>
      _configuration!.providers
          .where((provider) => provider.id == providerId)
          .firstOrNull
          ?.displayName ??
      'Provedor';

  String _modelName(String modelId) =>
      _configuration!.models
          .where((model) => model.id == modelId)
          .firstOrNull
          ?.displayName ??
      'Modelo indisponível';

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
    if (_configuration == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_error ?? 'Não foi possível carregar as configurações de IA.'),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _loadIfConnected,
            icon: const Icon(Icons.refresh),
            label: const Text('Tentar novamente'),
          ),
        ],
      );
    }

    final config = _configuration!;
    final ownedAgents = config.agents.where((agent) => agent.isOwned).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Configure provedores compatíveis com a API OpenAI, cadastre os modelos '
          'disponíveis e escolha quais modelos cada agente pode usar. Os recursos '
          'globais aparecem para consulta; somente os seus podem ser editados. '
          'Para autenticação, cadastre uma chave em “Chaves de API” e permita '
          'que ela use os modelos desejados. Deixe a chave vazia apenas quando '
          'o provedor OpenAI-compatible não exigir segredo.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        if (_error != null) ...[
          const SizedBox(height: 12),
          _ErrorBanner(message: _error!, onRetry: _loadIfConnected),
        ],
        if (_saving) const LinearProgressIndicator(),
        const SizedBox(height: 16),
        _SectionHeading(
          title: 'Provedores',
          subtitle: 'Servidores de IA e endpoints OpenAI-compatible.',
          action: FilledButton.icon(
            onPressed: _saving ? null : _createProvider,
            icon: const Icon(Icons.add),
            label: const Text('Adicionar provedor'),
          ),
        ),
        if (config.providers.isEmpty)
          const _EmptyHint('Nenhum provedor de IA está disponível.')
        else
          for (final provider in config.providers)
            _EntityCard(
              title: provider.displayName,
              subtitle:
                  '${provider.isOwned ? 'Pessoal' : 'Global'} · ${provider.protocol} · ${provider.baseUrl ?? 'URL não informada'}',
              active: provider.isActive,
              actions: provider.isOwned
                  ? [
                      _MenuAction(
                        label: 'Editar',
                        icon: Icons.edit_outlined,
                        onPressed: _saving
                            ? null
                            : () => _editProvider(provider),
                      ),
                      _MenuAction(
                        label: 'Desativar',
                        icon: Icons.delete_outline,
                        onPressed: _saving
                            ? null
                            : () => _deactivate(
                                title: 'Desativar provedor?',
                                description:
                                    '“${provider.displayName}” e seus modelos deixarão de aparecer como opções. O histórico será preservado.',
                                action: () => ref
                                    .read(
                                      personalAiConfigurationServiceProvider,
                                    )
                                    .deleteProvider(provider.id),
                                successMessage: 'Provedor desativado.',
                              ),
                      ),
                    ]
                  : const [],
            ),
        const SizedBox(height: 20),
        _SectionHeading(
          title: 'Modelos',
          subtitle: 'Defina IDs e limites de contexto para cada provedor.',
          action: FilledButton.icon(
            onPressed: _saving ? null : _createModel,
            icon: const Icon(Icons.add),
            label: const Text('Adicionar modelo'),
          ),
        ),
        if (config.models.isEmpty)
          const _EmptyHint('Nenhum modelo ativo está disponível.')
        else
          for (final model in config.models)
            _EntityCard(
              title: model.displayName,
              subtitle:
                  '${_providerName(model.providerId)} · ID ${model.slug} · contexto ${model.contextWindow ?? '—'} tokens · entrada ${model.inputTokenLimit ?? '—'} · saída ${model.outputTokenLimit ?? '—'}'
                  '${model.supportsVision ? ' · visão' : ''}',
              active: model.isActive,
              actions: model.isOwned
                  ? [
                      _MenuAction(
                        label: 'Editar',
                        icon: Icons.edit_outlined,
                        onPressed: _saving ? null : () => _editModel(model),
                      ),
                      _MenuAction(
                        label: 'Desativar',
                        icon: Icons.delete_outline,
                        onPressed: _saving
                            ? null
                            : () => _deactivate(
                                title: 'Desativar modelo?',
                                description:
                                    '“${model.displayName}” deixará de ser oferecido aos agentes. O histórico será preservado.',
                                action: () => ref
                                    .read(
                                      personalAiConfigurationServiceProvider,
                                    )
                                    .deleteModel(model.id),
                                successMessage: 'Modelo desativado.',
                              ),
                      ),
                    ]
                  : const [],
            ),
        const SizedBox(height: 20),
        _SectionHeading(
          title: 'Agentes',
          subtitle: 'Instruções e tarefa que orientam cada agente de IA.',
          action: FilledButton.icon(
            onPressed: _saving ? null : _createAgent,
            icon: const Icon(Icons.add),
            label: const Text('Adicionar agente'),
          ),
        ),
        if (config.agents.isEmpty)
          const _EmptyHint('Nenhum agente está disponível.')
        else
          for (final agent in config.agents)
            _EntityCard(
              title: agent.alias,
              subtitle:
                  '${agent.isOwned ? 'Pessoal' : 'Global'} · ${_taskLabel(agent.task)}'
                  '${agent.temperature == null ? '' : ' · temperatura ${agent.temperature}'}',
              active: agent.isActive,
              actions: agent.isOwned
                  ? [
                      _MenuAction(
                        label: 'Editar',
                        icon: Icons.edit_outlined,
                        onPressed: _saving ? null : () => _editAgent(agent),
                      ),
                      _MenuAction(
                        label: 'Desativar',
                        icon: Icons.delete_outline,
                        onPressed: _saving
                            ? null
                            : () => _deactivate(
                                title: 'Desativar agente?',
                                description:
                                    '“${agent.alias}” e seus vínculos de modelo deixarão de ser usados. O histórico será preservado.',
                                action: () => ref
                                    .read(
                                      personalAiConfigurationServiceProvider,
                                    )
                                    .deleteAgent(agent.id),
                                successMessage: 'Agente desativado.',
                              ),
                      ),
                    ]
                  : const [],
              details: agent.baseSystemPrompt,
            ),
        const SizedBox(height: 20),
        _SectionHeading(
          title: 'Modelos por agente',
          subtitle:
              'Vincule cada agente pessoal a um ou mais modelos disponíveis.',
        ),
        if (ownedAgents.isEmpty)
          const _EmptyHint(
            'Crie um agente pessoal para configurar vínculos de modelos.',
          )
        else
          for (final agent in ownedAgents)
            _AgentModelsCard(
              agent: agent,
              links: config.agentModels
                  .where((link) => link.agentId == agent.id)
                  .toList(),
              modelName: _modelName,
              saving: _saving,
              onAdd: () => _createAgentModel(agent),
              onEdit: _editAgentModel,
              onDeactivate: (link) => _deactivate(
                title: 'Desativar vínculo?',
                description:
                    'O modelo “${_modelName(link.modelId)}” deixará de ser usado pelo agente “${agent.alias}”.',
                action: () => ref
                    .read(personalAiConfigurationServiceProvider)
                    .deleteAgentModel(link.id),
                successMessage: 'Vínculo desativado.',
              ),
            ),
      ],
    );
  }
}

class _AgentModelsCard extends StatelessWidget {
  const _AgentModelsCard({
    required this.agent,
    required this.links,
    required this.modelName,
    required this.saving,
    required this.onAdd,
    required this.onEdit,
    required this.onDeactivate,
  });

  final PersonalAiAgent agent;
  final List<PersonalAiAgentModel> links;
  final String Function(String) modelName;
  final bool saving;
  final VoidCallback onAdd;
  final ValueChanged<PersonalAiAgentModel> onEdit;
  final ValueChanged<PersonalAiAgentModel> onDeactivate;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  agent.alias,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              OutlinedButton.icon(
                onPressed: saving ? null : onAdd,
                icon: const Icon(Icons.add),
                label: const Text('Vincular modelo'),
              ),
            ],
          ),
          if (links.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text('Nenhum modelo vinculado.'),
            )
          else
            for (final link in links)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.smart_toy_outlined),
                title: Text(modelName(link.modelId)),
                subtitle: Text(
                  'Qualidade ${_qualityLabel(link.qualityExpected)}'
                  '${link.temperature == null ? '' : ' · temperatura ${link.temperature}'}',
                ),
                trailing: PopupMenuButton<String>(
                  enabled: !saving,
                  onSelected: (action) {
                    if (action == 'edit') onEdit(link);
                    if (action == 'deactivate') onDeactivate(link);
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(value: 'edit', child: Text('Editar vínculo')),
                    PopupMenuItem(
                      value: 'deactivate',
                      child: Text('Desativar vínculo'),
                    ),
                  ],
                ),
              ),
        ],
      ),
    ),
  );
}

class _EntityCard extends StatelessWidget {
  const _EntityCard({
    required this.title,
    required this.subtitle,
    required this.active,
    required this.actions,
    this.details,
  });

  final String title;
  final String subtitle;
  final bool active;
  final List<_MenuAction> actions;
  final String? details;

  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      leading: Icon(
        active ? Icons.hub_outlined : Icons.pause_circle_outline,
        color: active ? null : Theme.of(context).colorScheme.outline,
      ),
      title: Text(title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(subtitle),
          if (details != null) ...[
            const SizedBox(height: 6),
            Text(details!, maxLines: 3, overflow: TextOverflow.ellipsis),
          ],
        ],
      ),
      isThreeLine: details != null,
      trailing: actions.isEmpty
          ? null
          : PopupMenuButton<_MenuAction>(
              enabled: actions.any((action) => action.onPressed != null),
              onSelected: (action) => action.onPressed?.call(),
              itemBuilder: (context) => actions
                  .map(
                    (action) => PopupMenuItem(
                      value: action,
                      enabled: action.onPressed != null,
                      child: Row(
                        children: [
                          Icon(action.icon, size: 18),
                          const SizedBox(width: 8),
                          Text(action.label),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
    ),
  );
}

class _MenuAction {
  const _MenuAction({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({
    required this.title,
    required this.subtitle,
    this.action,
  });

  final String title;
  final String subtitle;
  final Widget? action;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      runSpacing: 8,
      spacing: 12,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
        ?action,
      ],
    ),
  );
}

class _EmptyHint extends StatelessWidget {
  const _EmptyHint(this.message);

  final String message;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Text(message, style: Theme.of(context).textTheme.bodyMedium),
  );
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Card(
    color: Theme.of(context).colorScheme.errorContainer,
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(child: Text(message)),
          IconButton(
            tooltip: 'Tentar novamente',
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
    ),
  );
}

class _EditorField {
  const _EditorField({
    required this.key,
    required this.label,
    required this.kind,
    this.initialValue,
    this.required = false,
    this.maxLength,
    this.helperText,
    this.choices = const {},
  });

  final String key;
  final String label;
  final _FieldKind kind;
  final String? initialValue;
  final bool required;
  final int? maxLength;
  final String? helperText;
  final Map<String, String> choices;
}

enum _FieldKind {
  text,
  multiline,
  slug,
  url,
  positiveInteger,
  temperature,
  choice,
  boolean,
}

const _qualityChoices = {
  'unusable': 'Inutilizável',
  'poor': 'Baixa',
  'fair': 'Razoável',
  'good': 'Boa',
  'very_good': 'Muito boa',
  'excellent': 'Excelente',
};

const _taskLabels = {
  'manipulate_graph': 'Editar grafo',
  'manipulate_node': 'Editar nó',
  'generate_node_description': 'Descrever nó',
  'create_study_session': 'Criar sessão de estudo',
  'evaluate_essay_question': 'Avaliar resposta dissertativa',
  'create_essay_question': 'Criar questão dissertativa',
  'create_multiple_choice_question': 'Criar questão de múltipla escolha',
  'evaluate_multiple_choice_question': 'Avaliar questão de múltipla escolha',
  'create_feynman': 'Criar questão Feynman',
  'evaluate_feynman': 'Avaliar resposta Feynman',
  'recommend_study_resource': 'Recomendar recursos',
  'study_manager': 'Planejar estudos',
  'study_assistent': 'Assistente de estudos',
  'create_flashcard_group': 'Criar grupo de flashcards',
  'manipulate_flashcard_group': 'Editar grupo de flashcards',
  'create_flashcard': 'Criar flashcard',
  'create_flashcards': 'Criar flashcards',
};

Map<String, String> get _taskChoices => {
  for (final task in TaskType.values)
    task.name: _taskLabels[task.name] ?? task.name.replaceAll('_', ' '),
};

String _taskLabel(String task) => _taskLabels[task] ?? task;

String _qualityLabel(String? quality) =>
    _qualityChoices[quality] ?? quality ?? 'não definida';

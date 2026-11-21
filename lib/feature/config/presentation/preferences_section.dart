import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/design/theme/theme_tokens.dart';
import 'package:noema/feature/ai/providers/ai_queue_concurrency_provider.dart';
import 'package:noema/feature/config/providers/app_locale_provider.dart';
import 'package:noema/feature/config/providers/exercise_correction_mode_provider.dart';
import 'package:noema/feature/config/providers/preference_storage_provider.dart';
import 'package:noema/feature/config/presentation/preference_device_scope_control.dart';
import 'package:noema/feature/config/presentation/response_language_preferences_section.dart';
import 'package:noema/feature/graph/providers/graph_prompt_preferences_provider.dart';
import 'package:noema/feature/study_assistant/models/study_assistant_state.dart';
import 'package:noema/feature/study_assistant/providers/study_assistant_preferences_provider.dart';
import 'package:noema/l10n/app_localizations.dart';
import 'package:noema/shared/localization/runtime_localization.dart';

class PreferencesSection extends ConsumerWidget {
  const PreferencesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final locale = ref.watch(appLocaleProvider);
    final automaticSync = ref.watch(automaticConfigSyncProvider);
    final pendingSync = ref.watch(pendingConfigPreferenceCountProvider);
    final selected = locale.when(
      data: (value) => value?.languageCode ?? 'system',
      error: (_, _) => 'system',
      loading: () => null,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          child: Column(
            children: [
              automaticSync.when(
                loading: () => const ListTile(
                  leading: Icon(Icons.cloud_sync_outlined),
                  title: RuntimeLocalizedText('Sincronização de preferências'),
                  subtitle: RuntimeLocalizedText(
                    'Carregando configuração local…',
                  ),
                ),
                error: (error, _) => ListTile(
                  leading: const Icon(Icons.error_outline),
                  title: const RuntimeLocalizedText(
                    'Sincronização de preferências',
                  ),
                  subtitle: RuntimeLocalizedText('Não foi possível carregar'),
                  trailing: IconButton(
                    tooltip: 'Tentar novamente',
                    onPressed: () =>
                        ref.invalidate(automaticConfigSyncProvider),
                    icon: const Icon(Icons.refresh),
                  ),
                ),
                data: (enabled) => Row(
                  children: [
                    Expanded(
                      child: SwitchListTile(
                        secondary: const Icon(Icons.cloud_sync_outlined),
                        title: RuntimeLocalizedText(
                          l10n.synchronizeAutomatically,
                        ),
                        subtitle: RuntimeLocalizedText(l10n.updateOtherDevices),
                        value: enabled,
                        onChanged: (value) => _setAutomaticSync(
                          context,
                          () => ref
                              .read(automaticConfigSyncProvider.notifier)
                              .setEnabled(value),
                        ),
                      ),
                    ),
                    const _PreferenceInfoButton(
                      title: 'Sincronização automática',
                      message:
                          'As mudanças são salvas neste dispositivo primeiro e enviadas quando há conexão. Desative para sincronizar apenas manualmente.',
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ),
              pendingSync.when(
                loading: () => const SizedBox.shrink(),
                error: (error, _) => ListTile(
                  leading: const Icon(Icons.error_outline),
                  title: const RuntimeLocalizedText(
                    'Alterações aguardando sincronização',
                  ),
                  subtitle: RuntimeLocalizedText('Não foi possível verificar'),
                ),
                data: (count) => count == 0
                    ? const SizedBox.shrink()
                    : ListTile(
                        leading: const Icon(Icons.cloud_upload_outlined),
                        title: Text(
                          '$count ${count == 1 ? 'alteração pendente' : 'alterações pendentes'}',
                        ),
                        subtitle: const RuntimeLocalizedText(
                          'Envia quando a conexão estiver disponível.',
                        ),
                        trailing: FilledButton.tonalIcon(
                          onPressed: () => _syncNow(
                            context,
                            () => ref
                                .read(configPreferenceSyncServiceProvider)
                                .syncPending(force: true),
                          ),
                          icon: const Icon(Icons.sync),
                          label: const RuntimeLocalizedText('Sincronizar'),
                        ),
                      ),
              ),
            ],
          ),
        ),
        SizedBox(height: context.spacing.md),
        const ResponseLanguagePreferencesSection(),
        SizedBox(height: context.spacing.lg - context.spacing.xs),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                initialValue: selected,
                decoration: InputDecoration(
                  labelText: l10n.appLanguage,
                  prefixIcon: Icon(Icons.language),
                ),
                items: [
                  DropdownMenuItem(
                    value: 'system',
                    child: Text(l10n.deviceLanguage),
                  ),
                  DropdownMenuItem(
                    value: 'pt',
                    child: Text(l10n.portugueseBrazil),
                  ),
                  DropdownMenuItem(value: 'en', child: Text(l10n.english)),
                  DropdownMenuItem(value: 'ja', child: Text(l10n.japanese)),
                  DropdownMenuItem(value: 'ko', child: Text(l10n.korean)),
                  DropdownMenuItem(value: 'es', child: Text(l10n.spanish)),
                  DropdownMenuItem(value: 'fr', child: Text(l10n.french)),
                  DropdownMenuItem(value: 'de', child: Text(l10n.german)),
                ],
                onChanged: selected == null
                    ? null
                    : (value) async {
                        if (value == null) return;
                        try {
                          await ref
                              .read(appLocaleProvider.notifier)
                              .setLocale(
                                value == 'system' ? null : Locale(value),
                              );
                        } catch (error) {
                          if (!context.mounted) return;
                          _showSaveError(
                            context,
                            'Não foi possível salvar o idioma: $error',
                          );
                        }
                      },
              ),
            ),
            const SizedBox(width: 8),
            PreferenceDeviceScopeControl(
              preferenceKey: 'locale',
              effectiveValue: selected ?? 'system',
              onScopeChanged: () => ref.invalidate(appLocaleProvider),
            ),
          ],
        ),
        if (locale.hasError)
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () => ref.invalidate(appLocaleProvider),
              icon: const Icon(Icons.refresh),
              label: const RuntimeLocalizedText('Recarregar idioma'),
            ),
          ),
        SizedBox(height: context.spacing.lg - context.spacing.xs),
        const _ExerciseCorrectionModeSetting(),
        SizedBox(height: context.spacing.lg - context.spacing.xs),
        const _AiQueueConcurrencySetting(),
        SizedBox(height: context.spacing.lg - context.spacing.xs),
        const _StudyAssistantGenerationSetting(),
        SizedBox(height: context.spacing.lg - context.spacing.xs),
        const _GraphPromptSetting(),
      ],
    );
  }
}

class _StudyAssistantGenerationSetting extends ConsumerWidget {
  const _StudyAssistantGenerationSetting();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(studyAssistantSettingsProvider);
    return settings.when(
      loading: () => const ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(Icons.auto_awesome_outlined),
        title: RuntimeLocalizedText('Assistente de estudos'),
        subtitle: RuntimeLocalizedText('Carregando configurações...'),
      ),
      error: (error, _) => ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const Icon(Icons.error_outline),
        title: const RuntimeLocalizedText('Assistente de estudos'),
        subtitle: RuntimeLocalizedText('Não foi possível carregar'),
        trailing: IconButton(
          tooltip: 'Tentar novamente',
          onPressed: () => ref.invalidate(studyAssistantSettingsProvider),
          icon: const Icon(Icons.refresh),
        ),
      ),
      data: (value) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const RuntimeLocalizedText(
                    'Fixar assistente em telas largas',
                  ),
                  value: value.pinPanel,
                  onChanged: (enabled) => _saveAssistantPreference(
                    context,
                    () => ref
                        .read(studyAssistantSettingsProvider.notifier)
                        .setPinPanel(enabled),
                  ),
                ),
              ),
              const _PreferenceInfoButton(
                title: 'Assistente fixado',
                message:
                    'Mantém o painel aberto ao lado do conteúdo em telas largas. Em telas menores, ele continua disponível como painel flutuante.',
              ),
              const SizedBox(width: 8),
              PreferenceDeviceScopeControl(
                preferenceKey: 'studyAssistantPinPanel',
                effectiveValue: value.pinPanel,
                onScopeChanged: () =>
                    ref.invalidate(studyAssistantSettingsProvider),
              ),
            ],
          ),
          SizedBox(height: context.spacing.sm),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<StudyAssistantResponseStyle>(
                  initialValue: value.responseStyle,
                  decoration: const InputDecoration(
                    labelText: 'Nível de detalhe das respostas',
                    prefixIcon: Icon(Icons.notes_outlined),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: StudyAssistantResponseStyle.concise,
                      child: RuntimeLocalizedText('Direto ao ponto'),
                    ),
                    DropdownMenuItem(
                      value: StudyAssistantResponseStyle.balanced,
                      child: RuntimeLocalizedText('Equilibrado'),
                    ),
                    DropdownMenuItem(
                      value: StudyAssistantResponseStyle.detailed,
                      child: RuntimeLocalizedText('Explicações detalhadas'),
                    ),
                  ],
                  onChanged: (style) {
                    if (style == null) return;
                    _saveAssistantPreference(
                      context,
                      () => ref
                          .read(studyAssistantSettingsProvider.notifier)
                          .setResponseStyle(style),
                    );
                  },
                ),
              ),
              const SizedBox(width: 8),
              const _PreferenceInfoButton(
                title: 'Nível de detalhe',
                message:
                    'Define o estilo inicial das respostas. Você também pode pedir uma explicação mais curta ou detalhada no chat.',
              ),
              const SizedBox(width: 8),
              PreferenceDeviceScopeControl(
                preferenceKey: 'studyAssistantResponseStyle',
                effectiveValue: value.responseStyle.name,
                onScopeChanged: () =>
                    ref.invalidate(studyAssistantSettingsProvider),
              ),
            ],
          ),
          SizedBox(height: context.spacing.sm),
          Row(
            children: [
              Expanded(
                child: SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const RuntimeLocalizedText('Enter para enviar'),
                  subtitle: const RuntimeLocalizedText(
                    'Shift+Enter cria uma nova linha.',
                  ),
                  value: value.sendOnEnter,
                  onChanged: (enabled) => _saveAssistantPreference(
                    context,
                    () => ref
                        .read(studyAssistantSettingsProvider.notifier)
                        .setSendOnEnter(enabled),
                  ),
                ),
              ),
              PreferenceDeviceScopeControl(
                preferenceKey: 'studyAssistantSendOnEnter',
                effectiveValue: value.sendOnEnter,
                onScopeChanged: () =>
                    ref.invalidate(studyAssistantSettingsProvider),
              ),
            ],
          ),
          SizedBox(height: context.spacing.sm),
          Row(
            children: [
              Expanded(
                child: SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const RuntimeLocalizedText(
                    'Gerar ações automaticamente',
                  ),
                  subtitle: const RuntimeLocalizedText(
                    'Executa automaticamente ações propostas.',
                  ),
                  value: value.autoGenerateActions,
                  onChanged: (enabled) => _saveAssistantPreference(
                    context,
                    () => ref
                        .read(studyAssistantSettingsProvider.notifier)
                        .setAutoGenerateActions(enabled),
                  ),
                ),
              ),
              const _PreferenceInfoButton(
                title: 'Ações automáticas',
                message:
                    'Quando o assistente sugerir uma ação compatível, ele pode abrir a tela correspondente e iniciar a geração. Você ainda pode revisar o conteúdo antes de salvar.',
              ),
              const SizedBox(width: 8),
              PreferenceDeviceScopeControl(
                preferenceKey: 'studyAssistantAutoGenerateActions',
                effectiveValue: value.autoGenerateActions,
                onScopeChanged: () =>
                    ref.invalidate(studyAssistantSettingsProvider),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GraphPromptSetting extends ConsumerWidget {
  const _GraphPromptSetting();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setting = ref.watch(graphPromptEnhancementModeProvider);
    return setting.when(
      loading: () => const ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(Icons.auto_fix_high_outlined),
        title: RuntimeLocalizedText('Melhorar prompts de grafos'),
        subtitle: RuntimeLocalizedText('Carregando configuração...'),
      ),
      error: (error, _) => ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const Icon(Icons.error_outline),
        title: const RuntimeLocalizedText('Melhorar prompts de grafos'),
        subtitle: RuntimeLocalizedText('Não foi possível carregar'),
        trailing: IconButton(
          tooltip: 'Tentar novamente',
          onPressed: () => ref.invalidate(graphPromptEnhancementModeProvider),
          icon: const Icon(Icons.refresh),
        ),
      ),
      data: (mode) => Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<GraphPromptEnhancementMode>(
              initialValue: mode,
              decoration: const InputDecoration(
                labelText: 'Melhorar prompt ao criar grafos',
                prefixIcon: Icon(Icons.auto_fix_high_outlined),
              ),
              items: GraphPromptEnhancementMode.values
                  .map(
                    (item) =>
                        DropdownMenuItem(value: item, child: Text(item.label)),
                  )
                  .toList(growable: false),
              onChanged: (selected) {
                if (selected == null) return;
                _saveGraphPromptPreference(
                  context,
                  () => ref
                      .read(graphPromptEnhancementModeProvider.notifier)
                      .setMode(selected),
                );
              },
            ),
          ),
          const SizedBox(width: 8),
          _PreferenceInfoButton(
            title: 'Aprimoramento do prompt',
            message: mode.description,
          ),
          const SizedBox(width: 8),
          PreferenceDeviceScopeControl(
            preferenceKey: 'graphPromptEnhancementMode',
            effectiveValue: mode.preferenceName,
            onScopeChanged: () =>
                ref.invalidate(graphPromptEnhancementModeProvider),
          ),
        ],
      ),
    );
  }
}

Future<void> _setAutomaticSync(
  BuildContext context,
  Future<void> Function() save,
) async {
  try {
    await save();
  } catch (error) {
    if (!context.mounted) return;
    _showSaveError(context, 'Não foi possível salvar a preferência: $error');
  }
}

Future<void> _syncNow(
  BuildContext context,
  Future<void> Function() sync,
) async {
  try {
    await sync();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: RuntimeLocalizedText(
          'Preferências sincronizadas com sucesso.',
        ),
      ),
    );
  } catch (error) {
    if (!context.mounted) return;
    _showSaveError(
      context,
      'As alterações continuam salvas localmente. Não foi possível sincronizar: $error',
    );
  }
}

Future<void> _saveAssistantPreference(
  BuildContext context,
  Future<void> Function() save,
) async {
  try {
    await save();
  } catch (error) {
    if (!context.mounted) return;
    _showSaveError(context, 'Não foi possível salvar a preferência: $error');
  }
}

Future<void> _saveGraphPromptPreference(
  BuildContext context,
  Future<void> Function() save,
) async {
  try {
    await save();
  } catch (error) {
    if (!context.mounted) return;
    _showSaveError(context, 'Não foi possível salvar a preferência: $error');
  }
}

void _showSaveError(BuildContext context, String message) {
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

class _ExerciseCorrectionModeSetting extends ConsumerWidget {
  const _ExerciseCorrectionModeSetting();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(exerciseCorrectionModeProvider);
    return mode.when(
      loading: () => const ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(Icons.fact_check_outlined),
        title: RuntimeLocalizedText('Correção de exercícios'),
        subtitle: RuntimeLocalizedText('Carregando configuração...'),
      ),
      error: (error, _) => ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const Icon(Icons.error_outline),
        title: const RuntimeLocalizedText('Correção de exercícios'),
        subtitle: RuntimeLocalizedText('Não foi possível carregar'),
        trailing: IconButton(
          tooltip: 'Tentar novamente',
          onPressed: () => ref.invalidate(exerciseCorrectionModeProvider),
          icon: const Icon(Icons.refresh),
        ),
      ),
      data: (value) => Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<ExerciseCorrectionMode>(
              initialValue: value,
              decoration: const InputDecoration(
                labelText: 'Modo de correção das tarefas',
                prefixIcon: Icon(Icons.fact_check_outlined),
              ),
              items: const [
                DropdownMenuItem(
                  value: ExerciseCorrectionMode.automaticAi,
                  child: RuntimeLocalizedText('Automática com IA'),
                ),
                DropdownMenuItem(
                  value: ExerciseCorrectionMode.manual,
                  child: RuntimeLocalizedText('Manual'),
                ),
              ],
              onChanged: (nextValue) async {
                if (nextValue == null) return;
                try {
                  await ref
                      .read(exerciseCorrectionModeProvider.notifier)
                      .setMode(nextValue);
                } catch (error) {
                  if (!context.mounted) return;
                  _showSaveError(
                    context,
                    'Não foi possível salvar o modo de correção: $error',
                  );
                }
              },
            ),
          ),
          const SizedBox(width: 8),
          const _PreferenceInfoButton(
            title: 'Correção de tarefas',
            message:
                'No modo automático, as respostas entram na fila de correção por IA. No modo manual, você corrige pelo histórico.',
          ),
          const SizedBox(width: 8),
          PreferenceDeviceScopeControl(
            preferenceKey: 'exerciseCorrectionMode',
            effectiveValue: value.preferenceValue,
            onScopeChanged: () =>
                ref.invalidate(exerciseCorrectionModeProvider),
          ),
        ],
      ),
    );
  }
}

class _AiQueueConcurrencySetting extends ConsumerWidget {
  const _AiQueueConcurrencySetting();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final concurrency = ref.watch(aiQueueConcurrencyProvider);
    return concurrency.when(
      loading: () => const ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(Icons.queue),
        title: RuntimeLocalizedText('Fila de tarefas de IA'),
        subtitle: RuntimeLocalizedText('Carregando configuração...'),
      ),
      error: (error, _) => ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const Icon(Icons.error_outline),
        title: const RuntimeLocalizedText('Fila de tarefas de IA'),
        subtitle: RuntimeLocalizedText('Não foi possível carregar'),
        trailing: IconButton(
          tooltip: 'Tentar novamente',
          onPressed: () => ref.invalidate(aiQueueConcurrencyProvider),
          icon: const Icon(Icons.refresh),
        ),
      ),
      data: (value) => Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<int>(
              initialValue: value,
              decoration: const InputDecoration(
                labelText: 'Gerações automáticas simultâneas',
                prefixIcon: Icon(Icons.queue),
              ),
              items: const [
                DropdownMenuItem(
                  value: 1,
                  child: RuntimeLocalizedText('1 por vez'),
                ),
                DropdownMenuItem(
                  value: 2,
                  child: RuntimeLocalizedText('Até 2 simultâneas'),
                ),
                DropdownMenuItem(
                  value: 3,
                  child: RuntimeLocalizedText('Até 3 simultâneas'),
                ),
                DropdownMenuItem(
                  value: 4,
                  child: RuntimeLocalizedText('Até 4 simultâneas'),
                ),
                DropdownMenuItem(
                  value: 5,
                  child: RuntimeLocalizedText('Até 5 simultâneas'),
                ),
                DropdownMenuItem(
                  value: 6,
                  child: RuntimeLocalizedText('Até 6 simultâneas'),
                ),
                DropdownMenuItem(
                  value: 7,
                  child: RuntimeLocalizedText('Até 7 simultâneas'),
                ),
                DropdownMenuItem(
                  value: 8,
                  child: RuntimeLocalizedText('Até 8 simultâneas'),
                ),
              ],
              onChanged: (nextValue) async {
                if (nextValue == null) return;
                try {
                  await ref
                      .read(aiQueueConcurrencyProvider.notifier)
                      .setConcurrency(nextValue);
                } catch (error) {
                  if (!context.mounted) return;
                  _showSaveError(
                    context,
                    'Não foi possível salvar o limite da fila de IA: $error',
                  );
                }
              },
            ),
          ),
          const SizedBox(width: 8),
          const _PreferenceInfoButton(
            title: 'Fila de tarefas de IA',
            message:
                'Limita quantas gerações automáticas são processadas ao mesmo tempo. Ações iniciadas manualmente não aguardam essa fila.',
          ),
          const SizedBox(width: 8),
          PreferenceDeviceScopeControl(
            preferenceKey: 'aiMaxConcurrentRequests',
            effectiveValue: value,
            onScopeChanged: () => ref.invalidate(aiQueueConcurrencyProvider),
          ),
        ],
      ),
    );
  }
}

class _PreferenceInfoButton extends StatelessWidget {
  const _PreferenceInfoButton({required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Mais informações',
      visualDensity: VisualDensity.compact,
      onPressed: () => showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: RuntimeLocalizedText(title),
          content: RuntimeLocalizedText(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const RuntimeLocalizedText('Entendi'),
            ),
          ],
        ),
      ),
      icon: const Icon(Icons.info_outline, size: 20),
    );
  }
}

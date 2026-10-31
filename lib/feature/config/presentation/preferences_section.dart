import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/core/design/theme/theme_tokens.dart';
import 'package:noema/feature/ai/providers/ai_queue_concurrency_provider.dart';
import 'package:noema/feature/config/providers/app_locale_provider.dart';
import 'package:noema/feature/config/providers/exercise_correction_mode_provider.dart';
import 'package:noema/feature/config/presentation/preference_device_scope_control.dart';
import 'package:noema/feature/config/presentation/response_language_preferences_section.dart';
import 'package:noema/feature/study_assistant/models/study_assistant_state.dart';
import 'package:noema/feature/study_assistant/providers/study_assistant_preferences_provider.dart';

class PreferencesSection extends ConsumerWidget {
  const PreferencesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(appLocaleProvider);
    final selected = locale.when(
      data: (value) => value?.languageCode ?? 'system',
      error: (_, _) => 'system',
      loading: () => null,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          child: ListTile(
            dense: true,
            leading: const Icon(Icons.cloud_sync_outlined),
            title: const Text('Preferências sincronizadas com a conta'),
            subtitle: const Text(
              'Use o ícone discreto ao lado de uma configuração para mantê-la somente neste dispositivo.',
            ),
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
                decoration: const InputDecoration(
                  labelText: 'Idioma do aplicativo',
                  prefixIcon: Icon(Icons.language),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'system',
                    child: Text('Usar idioma do dispositivo'),
                  ),
                  DropdownMenuItem(value: 'pt', child: Text('Português')),
                  DropdownMenuItem(value: 'en', child: Text('English')),
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
              label: const Text('Recarregar idioma'),
            ),
          ),
        SizedBox(height: context.spacing.lg - context.spacing.xs),
        const _ExerciseCorrectionModeSetting(),
        SizedBox(height: context.spacing.lg - context.spacing.xs),
        const _AiQueueConcurrencySetting(),
        SizedBox(height: context.spacing.lg - context.spacing.xs),
        const _StudyAssistantGenerationSetting(),
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
        title: Text('Assistente de estudos'),
        subtitle: Text('Carregando configurações...'),
      ),
      error: (error, _) => ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const Icon(Icons.error_outline),
        title: const Text('Assistente de estudos'),
        subtitle: Text('Não foi possível carregar: $error'),
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
                  title: const Text('Manter o assistente fixado'),
                  subtitle: const Text(
                    'Em telas largas, o painel fica ao lado do conteúdo.',
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
                    helperText:
                        'Você pode pedir mais ou menos detalhes a qualquer momento no chat.',
                    prefixIcon: Icon(Icons.notes_outlined),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: StudyAssistantResponseStyle.concise,
                      child: Text('Direto ao ponto'),
                    ),
                    DropdownMenuItem(
                      value: StudyAssistantResponseStyle.balanced,
                      child: Text('Equilibrado'),
                    ),
                    DropdownMenuItem(
                      value: StudyAssistantResponseStyle.detailed,
                      child: Text('Explicações detalhadas'),
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
                  title: const Text('Enter envia a mensagem'),
                  subtitle: const Text(
                    'Desativado: Enter insere uma nova linha; use o botão para enviar.',
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
                  title: const Text('Gerar ações automaticamente'),
                  subtitle: const Text(
                    'Prepara e inicia ações compatíveis; o conteúdo sempre exige sua revisão.',
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
        title: Text('Correção de exercícios'),
        subtitle: Text('Carregando configuração...'),
      ),
      error: (error, _) => ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const Icon(Icons.error_outline),
        title: const Text('Correção de exercícios'),
        subtitle: Text('Não foi possível carregar: $error'),
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
                helperText:
                    'No modo automático, respostas entram na fila de IA. No manual, você corrige pelo histórico.',
                prefixIcon: Icon(Icons.fact_check_outlined),
              ),
              items: const [
                DropdownMenuItem(
                  value: ExerciseCorrectionMode.automaticAi,
                  child: Text('Automática com IA'),
                ),
                DropdownMenuItem(
                  value: ExerciseCorrectionMode.manual,
                  child: Text('Manual'),
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
        title: Text('Fila de tarefas de IA'),
        subtitle: Text('Carregando configuração...'),
      ),
      error: (error, _) => ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const Icon(Icons.error_outline),
        title: const Text('Fila de tarefas de IA'),
        subtitle: Text('Não foi possível carregar: $error'),
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
                helperText:
                    'Ações iniciadas por você não aguardam a fila automática.',
                prefixIcon: Icon(Icons.queue),
              ),
              items: const [
                DropdownMenuItem(value: 1, child: Text('1 por vez')),
                DropdownMenuItem(value: 2, child: Text('Até 2 simultâneas')),
                DropdownMenuItem(value: 3, child: Text('Até 3 simultâneas')),
                DropdownMenuItem(value: 4, child: Text('Até 4 simultâneas')),
                DropdownMenuItem(value: 5, child: Text('Até 5 simultâneas')),
                DropdownMenuItem(value: 6, child: Text('Até 6 simultâneas')),
                DropdownMenuItem(value: 7, child: Text('Até 7 simultâneas')),
                DropdownMenuItem(value: 8, child: Text('Até 8 simultâneas')),
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

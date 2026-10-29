import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/feature/ai/providers/ai_queue_concurrency_provider.dart';
import 'package:noema/feature/config/providers/app_locale_provider.dart';
import 'package:noema/feature/config/providers/exercise_correction_mode_provider.dart';

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
        Text(
          'Essas preferências ficam salvas localmente para cada conta.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
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
                        .setLocale(value == 'system' ? null : Locale(value));
                  } catch (error) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Não foi possível salvar o idioma: $error',
                        ),
                      ),
                    );
                  }
                },
        ),
        const SizedBox(height: 20),
        const _ExerciseCorrectionModeSetting(),
        const SizedBox(height: 20),
        const _AiQueueConcurrencySetting(),
        if (locale.hasError)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () => ref.invalidate(appLocaleProvider),
                icon: const Icon(Icons.refresh),
                label: const Text('Recarregar preferências'),
              ),
            ),
          ),
      ],
    );
  }
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
      data: (value) => DropdownButtonFormField<ExerciseCorrectionMode>(
        initialValue: value,
        decoration: const InputDecoration(
          labelText: 'Modo de correção das tarefas',
          helperText:
              'No modo automático, as respostas entram na fila de IA após o envio. No manual, você corrige pelo histórico.',
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
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Não foi possível salvar o modo de correção: $error',
                ),
              ),
            );
          }
        },
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
      data: (value) => DropdownButtonFormField<int>(
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
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Não foi possível salvar o limite da fila de IA: $error',
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

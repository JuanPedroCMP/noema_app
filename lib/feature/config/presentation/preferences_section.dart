import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/feature/config/providers/app_locale_provider.dart';

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

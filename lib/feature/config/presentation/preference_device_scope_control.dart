import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/feature/config/providers/preference_storage_provider.dart';

class PreferenceDeviceScopeControl extends ConsumerWidget {
  const PreferenceDeviceScopeControl({
    super.key,
    required this.preferenceKey,
    required this.effectiveValue,
    this.languageId,
    this.onScopeChanged,
  });

  final String preferenceKey;
  final Object effectiveValue;
  final String? languageId;
  final VoidCallback? onScopeChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scope = ref.watch(preferenceDeviceOnlyProvider(preferenceKey));
    return scope.when(
      loading: () => const SizedBox(
        width: 44,
        height: 48,
        child: Center(
          child: SizedBox.square(
            dimension: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ),
      error: (error, _) => IconButton(
        tooltip: 'Não foi possível carregar o destino: $error',
        onPressed: () =>
            ref.invalidate(preferenceDeviceOnlyProvider(preferenceKey)),
        icon: const Icon(Icons.error_outline),
      ),
      data: (deviceOnly) => PopupMenuButton<bool>(
        tooltip: deviceOnly
            ? 'Salvo somente neste dispositivo'
            : 'Opções de sincronização',
        icon: Icon(
          deviceOnly ? Icons.phone_android : Icons.cloud_outlined,
          color: deviceOnly
              ? Theme.of(context).colorScheme.tertiary
              : Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        onSelected: (nextDeviceOnly) async {
          try {
            await ref
                .read(preferenceStorageServiceProvider)
                .setDeviceOnly(
                  key: preferenceKey,
                  effectiveValue: effectiveValue,
                  deviceOnly: nextDeviceOnly,
                  languageId: languageId,
                );
            ref.invalidate(preferenceDeviceOnlyProvider(preferenceKey));
            onScopeChanged?.call();
          } catch (error) {
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Não foi possível alterar onde esta configuração é salva: $error',
                ),
              ),
            );
          }
        },
        itemBuilder: (context) => [
          PopupMenuItem(
            value: true,
            child: Row(
              children: [
                const Icon(Icons.phone_android_outlined, size: 20),
                const SizedBox(width: 12),
                const Expanded(child: Text('Somente neste dispositivo')),
                if (deviceOnly) const Icon(Icons.check, size: 18),
              ],
            ),
          ),
          PopupMenuItem(
            value: false,
            child: Row(
              children: [
                const Icon(Icons.cloud_outlined, size: 20),
                const SizedBox(width: 12),
                const Expanded(child: Text('Sincronizar com a conta')),
                if (!deviceOnly) const Icon(Icons.check, size: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

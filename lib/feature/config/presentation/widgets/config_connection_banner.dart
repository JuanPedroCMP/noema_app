import 'package:flutter/material.dart';
import 'package:noema/shared/localization/runtime_localization.dart';
import 'package:noema/core/design/theme/theme_tokens.dart';
import 'package:noema/core/design/tokens/layout.dart';
import 'package:noema/shared/widgets/app_card.dart';

class ConfigConnectionBanner extends StatelessWidget {
  const ConfigConnectionBanner({
    super.key,
    required this.isConnected,
    required this.onRefresh,
  });

  final bool isConnected;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final spacing = context.spacing;

    final statusIcon = Icon(
      isConnected ? Icons.cloud_done_outlined : Icons.cloud_off_outlined,
      color: isConnected ? colorScheme.primary : colorScheme.error,
      size: 20,
    );

    final statusLabel = Container(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.sm,
        vertical: spacing.xs / 2,
      ),
      decoration: BoxDecoration(
        color: isConnected
            ? colorScheme.primaryContainer.withValues(alpha: 0.6)
            : colorScheme.errorContainer.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          statusIcon,
          SizedBox(width: spacing.xs),
          Text(
            isConnected ? 'Conectado' : 'Offline',
            style: theme.textTheme.labelMedium?.copyWith(
              color: isConnected
                  ? colorScheme.onPrimaryContainer
                  : colorScheme.onErrorContainer,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );

    final message = Text(
      isConnected
          ? 'As preferências são salvas localmente primeiro. Dados que dependem do servidor são carregados ao abrir cada seção.'
          : 'Você pode alterar as preferências offline. Dados e ações que dependem do servidor ficarão indisponíveis até a conexão voltar.',
      style: theme.textTheme.bodyMedium?.copyWith(
        color: colorScheme.onSurfaceVariant,
      ),
    );

    final refreshButton = OutlinedButton.icon(
      onPressed: isConnected ? onRefresh : null,
      icon: const Icon(Icons.refresh, size: 18),
      label: const RuntimeLocalizedText('Atualizar'),
    );

    return AppCard(
      padding: EdgeInsets.all(spacing.md),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < AppLayoutTokens.compactHeaderBreakpoint) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(alignment: Alignment.centerLeft, child: statusLabel),
                SizedBox(height: spacing.sm),
                message,
                SizedBox(height: spacing.sm),
                refreshButton,
              ],
            );
          }
          return Row(
            children: [
              statusLabel,
              SizedBox(width: spacing.md),
              Expanded(child: message),
              SizedBox(width: spacing.sm),
              refreshButton,
            ],
          );
        },
      ),
    );
  }
}

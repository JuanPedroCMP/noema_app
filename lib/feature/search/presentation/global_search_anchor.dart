import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noema/shared/localization/runtime_localization.dart';
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/core/design/theme/theme_tokens.dart';
import 'package:noema/feature/config/providers/user_provider.dart';
import 'package:noema/feature/search/data/global_search_service.dart';

class GlobalSearchAnchor extends ConsumerWidget {
  const GlobalSearchAnchor({
    super.key,
    required this.isDesktop,
    required this.onNavigate,
  });

  final bool isDesktop;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchWidth = (MediaQuery.sizeOf(context).width * .25)
        .clamp(240.0, 320.0)
        .toDouble();
    return SearchAnchor(
      isFullScreen: !isDesktop,
      viewHintText: 'Grafos, tópicos, tarefas, flashcards…',
      viewBackgroundColor: context.colors.surfaceContainerLow,
      viewElevation: 4,
      viewShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.radius.dialog),
      ),
      viewConstraints: const BoxConstraints(maxWidth: 680),
      builder: (context, controller) {
        if (!isDesktop) {
          return IconButton(
            tooltip: 'Buscar no Noema',
            onPressed: controller.openView,
            style: IconButton.styleFrom(
              backgroundColor: context.colors.surfaceContainerHighest,
              foregroundColor: context.colors.onSurfaceVariant,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(context.radius.button),
              ),
            ),
            icon: const Icon(Icons.search_rounded),
          );
        }

        return SizedBox(
          width: searchWidth,
          child: SearchBar(
            controller: controller,
            hintText: 'Buscar no Noema',
            constraints: const BoxConstraints(minHeight: 48, maxHeight: 48),
            elevation: const WidgetStatePropertyAll(0),
            backgroundColor: WidgetStatePropertyAll(
              context.colors.surfaceContainerHighest,
            ),
            side: WidgetStateProperty.resolveWith(
              (states) => BorderSide(
                color: states.contains(WidgetState.focused)
                    ? context.colors.primary
                    : context.colors.outlineVariant,
              ),
            ),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(context.radius.button),
              ),
            ),
            padding: const WidgetStatePropertyAll(
              EdgeInsets.symmetric(horizontal: 14),
            ),
            hintStyle: WidgetStatePropertyAll(
              context.textTheme.bodyMedium?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
            textStyle: WidgetStatePropertyAll(context.textTheme.bodyMedium),
            leading: const Icon(Icons.search_rounded),
            onTap: controller.openView,
            onChanged: (_) => controller.openView(),
            textInputAction: TextInputAction.search,
          ),
        );
      },
      suggestionsBuilder: (context, controller) async {
        final query = controller.text.trim();
        if (query.length < 2) {
          return [
            ListTile(
              leading: Icon(
                Icons.tips_and_updates_outlined,
                color: context.colors.primary,
              ),
              title: const RuntimeLocalizedText(
                'Encontre conteúdos em todo o Noema',
              ),
              subtitle: const RuntimeLocalizedText(
                'Digite ao menos 2 caracteres para buscar.',
              ),
            ),
          ];
        }

        try {
          final user = await ref.read(userProvider.future);
          final results = await GlobalSearchService(
            ref.read(appDatabaseProvider),
          ).search(userId: user.id, query: query);
          if (results.isEmpty) {
            return [
              ListTile(
                leading: const Icon(Icons.search_off_rounded),
                title: const RuntimeLocalizedText(
                  'Nenhum resultado encontrado',
                ),
                subtitle: RuntimeLocalizedText(
                  'Tente outro termo para “$query”.',
                ),
              ),
            ];
          }

          return [
            for (final result in results)
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: context.colors.secondaryContainer,
                  foregroundColor: context.colors.onSecondaryContainer,
                  child: Icon(result.kind.icon, size: 20),
                ),
                title: Text(
                  result.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  '${result.kind.label} · ${result.subtitle}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: const Icon(Icons.arrow_forward_rounded, size: 18),
                onTap: () {
                  controller.closeView(result.title);
                  onNavigate(result.path);
                },
              ),
          ];
        } catch (error, stackTrace) {
          debugPrint('Falha ao pesquisar conteúdos: $error');
          debugPrintStack(stackTrace: stackTrace);
          return [
            ListTile(
              leading: Icon(
                Icons.error_outline_rounded,
                color: context.colors.error,
              ),
              title: const RuntimeLocalizedText(
                'Não foi possível concluir a busca',
              ),
              subtitle: const RuntimeLocalizedText(
                'Feche a busca e tente novamente.',
              ),
            ),
          ];
        }
      },
    );
  }
}

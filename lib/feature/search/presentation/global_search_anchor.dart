import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    return SearchAnchor(
      isFullScreen: !isDesktop,
      viewHintText: 'Grafos, tópicos, tarefas, flashcards…',
      builder: (context, controller) {
        if (!isDesktop) {
          return IconButton(
            tooltip: 'Buscar no Noema',
            onPressed: controller.openView,
            icon: const Icon(Icons.search_rounded),
          );
        }

        return SizedBox(
          width: 280,
          child: SearchBar(
            controller: controller,
            hintText: 'Buscar no Noema',
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
              title: const Text('Encontre conteúdos em todo o Noema'),
              subtitle: const Text(
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
                title: const Text('Nenhum resultado encontrado'),
                subtitle: Text('Tente outro termo para “$query”.'),
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
              title: const Text('Não foi possível concluir a busca'),
              subtitle: const Text('Feche a busca e tente novamente.'),
            ),
          ];
        }
      },
    );
  }
}

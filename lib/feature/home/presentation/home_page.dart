import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:noema/core/database/database_provider.dart';
import 'package:noema/core/network/api_client.dart';
import 'package:noema/feature/auth/providers/auth_state_provider.dart';
import 'package:noema/feature/auth/providers/account_state.dart';
import 'package:noema/feature/auth/services/login_service.dart';
import 'package:noema/feature/config/data/user_dao.dart';
import 'package:noema/core/router/route_paths.dart';
import 'package:noema/l10n/app_localizations.dart';
import 'package:noema/shared/widgets/responsive_content.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storage = ref.read(secureSorageProvider);
    return AppResponsiveContent(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 24,
        children: [
          AppPageHeader(
            title: AppLocalizations.of(context)!.helloWorld,
            subtitle: "Organize seus estudos e continue de onde parou.",
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final compact = constraints.maxWidth < 420;
                  final message = const Text(
                    "Sua área de estudos está pronta para você.",
                  );
                  final logout = OutlinedButton.icon(
                    onPressed: () async {
                      try {
                        await storage.delete(key: 'access_token');
                        await storage.delete(
                          key: 'access_token_remote_owner_id',
                        );
                        await storage.delete(
                          key: 'access_token_remote_onwer_id',
                        );
                      } catch (error) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Não foi possível sair: $error'),
                            ),
                          );
                        }
                        return;
                      }
                      clearApiAccessToken(ref.read(apiClientProvider));
                      try {
                        await AppUserDao(
                          ref.read(appDatabaseProvider),
                        ).deactivateAllUsers();
                      } catch (error) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'A sessão foi encerrada, mas o estado local '
                                'não pôde ser atualizado: $error',
                              ),
                            ),
                          );
                        }
                      } finally {
                        resetAccountScopedState(ref);
                        ref.invalidate(authStateProvider);
                        if (context.mounted) context.go(RoutePaths.login);
                      }
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text("Sair"),
                  );
                  return compact
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          spacing: 16,
                          children: [message, logout],
                        )
                      : Row(
                          children: [
                            Expanded(child: message),
                            logout,
                          ],
                        );
                },
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.playlist_add_check_circle_outlined),
              title: const Text('Sessões de estudo'),
              subtitle: const Text(
                'Agrupe questões e acompanhe cada realização.',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.go(RoutePaths.studySessions),
            ),
          ),
        ],
      ),
    );
  }
}

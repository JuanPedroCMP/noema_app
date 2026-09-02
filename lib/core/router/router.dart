import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:noema/core/router/app_shell.dart';
import 'package:noema/feature/auth/providers/auth_base_page.dart';
import 'package:noema/feature/auth/providers/auth_state_provider.dart';
import 'package:noema/feature/auth/presentation/login_page.dart';
import 'package:noema/feature/auth/presentation/sign_up_page.dart';
import 'package:noema/feature/config/presentation/config_page.dart';
import 'package:noema/feature/exercises/multiple_choice/presentation/multiple_choice.dart';
import 'package:noema/feature/exercises/open_ended/presentation/open_ended.dart';
import 'package:noema/feature/exercises/presentation/list_exercices.dart';
import 'package:noema/feature/graph/pages/graph_list.dart';
import 'package:noema/feature/graph/pages/graph_page.dart';
import 'package:noema/feature/home/presentation/home_page.dart';
import 'package:noema/feature/notes/presentation/notes_page.dart';
import 'package:noema/feature/splash/presentation/splash_page.dart';
import 'package:noema/teste_page.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: "/",

    redirect: (context, state) {
      final isLoggingIn = state.matchedLocation == "/login";
      final isSigninUp = state.matchedLocation == "/sign_up";
      final isAuthLoading = authState.isLoading;
      final isLoggedIn = authState.value == true;

      if (isAuthLoading) {
        return "/splash";
      }

      if (!isLoggedIn && !isLoggingIn && !isSigninUp) {
        return "/login";
      }

      if (isLoggedIn && (isLoggingIn || state.matchedLocation == "/splash")) {
        return "/";
      }

      return null;
    },

    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return AuthBasePage(child: child);
        },
        routes: [
          GoRoute(path: "/splash", builder: (_, _) => SplashPage()),
          GoRoute(path: "/login", builder: (_, _) => LoginPage()),

          GoRoute(path: "/sign_up", builder: (_, _) => SignUpPage()),
        ],
      ),

      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShell(
            navigationShell: navigationShell,
            currentPath: state.uri.path,
          );
        },

        branches: [
          StatefulShellBranch(
            routes: [GoRoute(path: "/", builder: (_, _) => const HomePage())],
          ),

          StatefulShellBranch(
            routes: [GoRoute(path: "/notes", builder: (_, _) => NotesPage())],
          ),

          StatefulShellBranch(
            routes: [GoRoute(path: "/config", builder: (_, _) => ConfigPage())],
          ),

          StatefulShellBranch(
            routes: [
              GoRoute(path: "/teste", builder: (_, _) => M3ShowcaseApp()),
            ],
          ),

          StatefulShellBranch(
            routes: [
              GoRoute(
                path: "/graphs",
                builder: (_, _) =>
                    GraphList(), // Fazer página que mostram todos os grafos em formato de grafos
                routes: [
                  GoRoute(
                    path: ':graphId',
                    builder: (context, state) {
                      final String graphId = state.pathParameters['graphId']!;
                      return GraphPage(graphId: graphId);
                    },
                    routes: [
                      GoRoute(
                        path: 'exercices/:nodeId',
                        builder: (context, state) {
                          final String nodeId = state.pathParameters['nodeId']!;
                          return ExercicesList(nodeId: nodeId);
                        },
                        routes: [
                          GoRoute(
                            path: 'create_open_ended/:nodeId',
                            builder: (context, state) {
                              final String nodeId =
                                  state.pathParameters['nodeId']!;
                              return OpenEnded(nodeId: nodeId, defaultMode: 1);
                            },
                          ),
                          GoRoute(
                            path: 'updade_open_ended/:nodeId/:openEndedId',
                            builder: (context, state) {
                              final String nodeId =
                                  state.pathParameters['nodeId']!;
                              final String openEndedId =
                                  state.pathParameters['openEndedId']!;
                              return OpenEnded(
                                nodeId: nodeId,
                                openEndedId: openEndedId,
                                defaultMode: 1,
                              );
                            },
                          ),
                          GoRoute(
                            path: 'do_open_ended/:nodeId/:openEndedId',
                            builder: (context, state) {
                              final String nodeId =
                                  state.pathParameters['nodeId']!;
                              final String openEndedId =
                                  state.pathParameters['openEndedId']!;
                              return OpenEnded(
                                nodeId: nodeId,
                                openEndedId: openEndedId,
                                defaultMode: 2,
                              );
                            },
                          ),
                          GoRoute(
                            path: 'get_open_ended/:nodeId/:openEndedId',
                            builder: (context, state) {
                              final String nodeId =
                                  state.pathParameters['nodeId']!;
                              final String openEndedId =
                                  state.pathParameters['openEndedId']!;
                              return OpenEnded(
                                nodeId: nodeId,
                                openEndedId: openEndedId,
                                defaultMode: 3,
                              );
                            },
                          ),
                          GoRoute(
                            path: 'create_multiple_choise/:nodeId',
                            builder: (context, state) {
                              final String nodeId =
                                  state.pathParameters['nodeId']!;
                              return MultipleChoise(
                                nodeId: nodeId,
                                defaultMode: 1,
                              );
                            },
                          ),
                          GoRoute(
                            path:
                                'updade_multiple_choise/:nodeId/:multipleChoiseId',
                            builder: (context, state) {
                              final String nodeId =
                                  state.pathParameters['nodeId']!;
                              final String multipleChoiseId =
                                  state.pathParameters['multipleChoiseId']!;
                              return MultipleChoise(
                                nodeId: nodeId,
                                multipleChoiseId: multipleChoiseId,
                                defaultMode: 1,
                              );
                            },
                          ),
                          GoRoute(
                            path:
                                'do_multiple_choise/:nodeId/:multipleChoiseId',
                            builder: (context, state) {
                              final String nodeId =
                                  state.pathParameters['nodeId']!;
                              final String multipleChoiseId =
                                  state.pathParameters['multipleChoiseId']!;
                              return MultipleChoise(
                                nodeId: nodeId,
                                multipleChoiseId: multipleChoiseId,
                                defaultMode: 2,
                              );
                            },
                          ),
                          GoRoute(
                            path:
                                'get_multiple_choise/:nodeId:multipleChoiseId',
                            builder: (context, state) {
                              final String nodeId =
                                  state.pathParameters['nodeId']!;
                              final String multipleChoiseId =
                                  state.pathParameters['multipleChoiseId']!;
                              return MultipleChoise(
                                nodeId: nodeId,
                                multipleChoiseId: multipleChoiseId,
                                defaultMode: 3,
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

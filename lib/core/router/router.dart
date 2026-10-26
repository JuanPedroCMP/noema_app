import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:noema/core/router/app_shell.dart';
import 'package:noema/core/router/route_paths.dart';
import 'package:noema/feature/auth/providers/auth_base_page.dart';
import 'package:noema/feature/auth/providers/auth_state_provider.dart';
import 'package:noema/feature/auth/presentation/login_page.dart';
import 'package:noema/feature/auth/presentation/sign_up_page.dart';
import 'package:noema/feature/config/presentation/config_page.dart';
import 'package:noema/feature/exercises/multiple_choice/presentation/multiple_choice.dart';
import 'package:noema/feature/exercises/open_ended/presentation/open_ended.dart';
import 'package:noema/feature/exercises/presentation/list_exercices.dart';
import 'package:noema/feature/exercises/presentation/list_exercices_answers.dart';
import 'package:noema/feature/graph/pages/graph_list.dart';
import 'package:noema/feature/graph/pages/graph_page.dart';
import 'package:noema/feature/home/presentation/home_page.dart';
import 'package:noema/feature/flashcards/presentation/flashcard.dart';
import 'package:noema/feature/notes/presentation/notes_page.dart';
import 'package:noema/feature/splash/presentation/splash_page.dart';
import 'package:noema/feature/study_session/presentation/study_session_create_page.dart';
import 'package:noema/feature/study_session/presentation/study_session_detail_page.dart';
import 'package:noema/feature/study_session/presentation/study_session_run_page.dart';
import 'package:noema/feature/study_session/presentation/study_sessions_page.dart';
import 'package:noema/teste_page.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: RoutePaths.home,

    redirect: (context, state) {
      final isLoggingIn = state.matchedLocation == RoutePaths.login;
      final isSigninUp = state.matchedLocation == RoutePaths.signUp;
      final isAuthLoading = authState.isLoading;
      final isLoggedIn = authState.value == true;

      if (isAuthLoading) {
        return RoutePaths.splash;
      }

      if (!isLoggedIn && !isLoggingIn && !isSigninUp) {
        return RoutePaths.login;
      }

      if (isLoggedIn && (isLoggingIn || state.matchedLocation == "/splash")) {
        return RoutePaths.home;
      }

      return null;
    },

    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return AuthBasePage(child: child);
        },
        routes: [
          GoRoute(path: RoutePaths.splash, builder: (_, _) => SplashPage()),
          GoRoute(path: RoutePaths.login, builder: (_, _) => LoginPage()),
          GoRoute(path: RoutePaths.signUp, builder: (_, _) => SignUpPage()),
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
            routes: [
              GoRoute(
                path: RoutePaths.home,
                builder: (_, _) => const HomePage(),
                routes: [
                  GoRoute(
                    path: 'study-sessions',
                    builder: (_, _) => const StudySessionsPage(),
                    routes: [
                      GoRoute(
                        path: 'create',
                        builder: (_, _) => const StudySessionCreatePage(),
                      ),
                      GoRoute(
                        path: ':sessionId',
                        builder: (context, state) => StudySessionDetailPage(
                          sessionId: state.pathParameters['sessionId']!,
                        ),
                        routes: [
                          GoRoute(
                            path: 'edit',
                            builder: (context, state) =>
                                StudySessionCreatePage(
                                  sessionId:
                                      state.pathParameters['sessionId']!,
                                ),
                          ),
                          GoRoute(
                            path: 'run',
                            builder: (context, state) => StudySessionRunPage(
                              sessionId: state.pathParameters['sessionId']!,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          StatefulShellBranch(
            routes: [
              GoRoute(path: RoutePaths.notes, builder: (_, _) => NotesPage()),
            ],
          ),

          StatefulShellBranch(
            routes: [
              GoRoute(path: RoutePaths.config, builder: (_, _) => ConfigPage()),
            ],
          ),

          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.test,
                builder: (_, _) => M3ShowcaseApp(),
              ),
            ],
          ),

          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.graphs,
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
                        path: 'flashcards/:nodeId',
                        builder: (context, state) {
                          final nodeId = state.pathParameters['nodeId']!;
                          return FlashcardPage(nodeId: nodeId);
                        },
                      ),
                      GoRoute(
                        path: 'exercises/:nodeId',
                        builder: (context, state) {
                          final String nodeId = state.pathParameters['nodeId']!;
                          return ExercicesList(nodeId: nodeId);
                        },
                        routes: [
                          GoRoute(
                            path: 'responses',
                            builder: (context, state) {
                              final String nodeId =
                                  state.pathParameters['nodeId']!;
                              return ExercicesAnswerList(nodeId: nodeId);
                            },
                          ),
                          GoRoute(
                            path: 'open-ended/create',
                            builder: (context, state) {
                              final String nodeId =
                                  state.pathParameters['nodeId']!;
                              return OpenEnded(nodeId: nodeId, defaultMode: 1);
                            },
                          ),
                          GoRoute(
                            path: 'open-ended/:openEndedId/edit',
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
                            path: 'open-ended/:openEndedId/answer',
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
                            path: 'open-ended/:openEndedId/view',
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
                            path: 'multiple-choice/create',
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
                            path: 'multiple-choice/:multipleChoiseId/edit',
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
                            path: 'multiple-choice/:multipleChoiseId/answer',
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
                            path: 'multiple-choice/:multipleChoiseId/view',
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
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.flashcards,
                builder: (_, _) => const FlashcardPage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

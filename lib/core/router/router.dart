import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:noema/core/router/app_shell.dart';
import 'package:noema/feature/auth/providers/auth_base_page.dart';
import 'package:noema/feature/auth/providers/auth_state_provider.dart';
import 'package:noema/feature/auth/presentation/login_page.dart';
import 'package:noema/feature/auth/presentation/sign_up_page.dart';
import 'package:noema/feature/config/presentation/config_page.dart';
import 'package:noema/feature/config/presentation/profile_section.dart';
import 'package:noema/feature/graph/create_graph.dart';
import 'package:noema/feature/graph/graph.dart';
import 'package:noema/feature/graph/graph_list.dart';
import 'package:noema/feature/graph/graph_page.dart';
import 'package:noema/feature/graph/manage_graph.dart';
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
                      return GraphPage(graphId: graphId,);
                    },
                  ),
                  GoRoute(
                    path: 'edit/:graphId',
                    builder: (context, state) {
                      final String graphId = state.pathParameters['graphId']!;
                      return ManageGraph(graphId: graphId,);
                    },
                  ),
                ],
              ),
            ],
          ),

          StatefulShellBranch(
            //Temp
            routes: [
              GoRoute(
                path: "/cg",
                builder: (_, _) => CreateGraph(),
                routes: [
                  
                ]
              ),
            ],
          ),

          StatefulShellBranch(
            //Temp
            routes: [
              GoRoute(path: "/lg", builder: (_, _) => GraphList(), routes: [
                  
                ]
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

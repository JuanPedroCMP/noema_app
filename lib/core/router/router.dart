

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:noema/core/router/base_page.dart';
import 'package:noema/feature/auth/presentation/sign_up_page.dart';
import 'package:noema/feature/home/presentation/home_page.dart';
import 'package:noema/feature/notes/presentation/notes_page.dart';


final goRouterProvider= Provider<GoRouter>((ref){
return GoRouter(
  initialLocation:  "/",

  routes: 
  [
    ShellRoute(
      builder: (context, state, child) {
        return BasePage(child: child);
      },

      routes: [
        GoRoute(
        path: "/",
        builder: (_, _) => const HomePage(),
        ),

        GoRoute(
          path: "/notes",
          builder: (_, _) => NotesPage(),
        ),

        GoRoute(
          path: "/sign_up",
          builder: (_, _) => SignUpPage()
        )
      ]
    )
  ]
  );
});
import 'package:go_router/go_router.dart';

import '../../app/app_shell.dart';
import '../../features/book_details/presentation/book_details_page.dart';
import '../../features/explore/presentation/explore_page.dart';
import '../../features/home/presentation/home_page.dart';
import '../../features/library/presentation/library_page.dart';
import '../../features/onboarding/presentation/onboarding_page.dart';
import 'app_routes.dart';

/// Cria o roteador do app.
///
/// [isOnboarded] diz se o usuário já concluiu o onboarding; enquanto não
/// concluiu, toda navegação é redirecionada para [AppRoutes.onboarding].
GoRouter createAppRouter({required bool Function() isOnboarded}) {
  return GoRouter(
    initialLocation: AppRoutes.home,
    redirect: (context, state) {
      final atOnboarding = state.matchedLocation == AppRoutes.onboarding;
      if (!isOnboarded()) {
        return atOnboarding ? null : AppRoutes.onboarding;
      }
      return atOnboarding ? AppRoutes.home : null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingPage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          _branch(AppRoutes.home, (context, state) => const HomePage()),
          _branch(AppRoutes.explore, (context, state) => const ExplorePage()),
          _branch(AppRoutes.library, (context, state) => const LibraryPage()),
        ],
      ),
      GoRoute(
        path: AppRoutes.bookDetails,
        builder: (context, state) =>
            BookDetailsPage(bookId: state.pathParameters['id']!),
      ),
    ],
  );
}

StatefulShellBranch _branch(String path, GoRouterWidgetBuilder builder) {
  return StatefulShellBranch(
    routes: [GoRoute(path: path, builder: builder)],
  );
}

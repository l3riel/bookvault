import 'package:go_router/go_router.dart';

import 'app_shell.dart';
import '../features/book_details/book_details_page.dart';
import '../features/explore/explore_page.dart';
import '../features/home/home_page.dart';
import '../features/library/library_page.dart';
import '../features/onboarding/onboarding_page.dart';

/// Caminhos das rotas do app.
abstract final class AppRoutes {
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String explore = '/explore';
  static const String library = '/library';
  static const String bookDetails = '/book/:id';

  static String bookDetailsOf(String id) => '/book/${Uri.encodeComponent(id)}';
}

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

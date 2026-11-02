import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../models/book.dart';
import '../models/genre.dart';
import '../stores/book_details_store.dart';
import '../stores/explore_store.dart';
import '../stores/home_store.dart';
import '../stores/onboarding_store.dart';
import 'app_dependencies.dart';
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

  /// Explorar já buscando [term] (usado pelo "Ver todos" da Home).
  static String exploreSearch(String term) =>
      Uri(path: explore, queryParameters: {'q': term}).toString();
}

/// Cria o roteador do app.
///
/// Sem preferências salvas, toda navegação vai para o onboarding; com elas,
/// o onboarding não abre mais (S05).
GoRouter createAppRouter(AppDependencies dependencies) {
  final preferences = dependencies.preferencesRepository;
  return GoRouter(
    initialLocation: AppRoutes.home,
    redirect: (context, state) {
      final atOnboarding = state.matchedLocation == AppRoutes.onboarding;
      if (preferences.load() == null) {
        return atOnboarding ? null : AppRoutes.onboarding;
      }
      return atOnboarding ? AppRoutes.home : null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) =>
            OnboardingPage(createStore: () => OnboardingStore(preferences)),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          _branch(
            AppRoutes.home,
            (context, state) => HomePage(
              createStore: () => HomeStore(
                preferences: preferences,
                books: dependencies.booksRepository,
                now: DateTime.now,
              ),
              libraryStore: dependencies.libraryStore,
            ),
          ),
          _branch(
            AppRoutes.explore,
            (context, state) => ExplorePage(
              initialQuery: state.uri.queryParameters['q'],
              createStore: () => ExploreStore(
                dependencies.booksRepository,
                suggestions: [
                  for (final key in preferences.load()?.genres ?? <String>[])
                    ?Genre.fromKey(key),
                ],
              ),
              libraryStore: dependencies.libraryStore,
            ),
          ),
          _branch(
            AppRoutes.library,
            (context, state) => LibraryPage(store: dependencies.libraryStore),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.bookDetails,
        builder: (context, state) {
          final bookId = state.pathParameters['id']!;
          final extra = state.extra;
          return BookDetailsPage(
            key: ValueKey(bookId),
            createStore: () => BookDetailsStore(
              bookId: bookId,
              books: dependencies.booksRepository,
              library: dependencies.libraryStore,
              // O resultado da busca já traz o livro; link direto não.
              initialBook: extra is Book && extra.id == bookId ? extra : null,
            ),
          );
        },
      ),
    ],
  );
}

StatefulShellBranch _branch(String path, GoRouterWidgetBuilder builder) {
  return StatefulShellBranch(
    routes: [GoRoute(path: path, builder: builder)],
  );
}

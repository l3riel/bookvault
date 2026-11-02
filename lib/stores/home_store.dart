import 'package:mobx/mobx.dart';

import '../data/repositories/books_exception.dart';
import '../data/repositories/books_repository.dart';
import '../data/repositories/preferences_repository.dart';
import '../models/book.dart';
import '../models/genre.dart';

part 'home_store.g.dart';

/// Quantos gêneros a Home consulta, no máximo (poupa a cota da API).
const int maxRecommendedGenres = 3;

/// Situação das recomendações da Home.
enum HomeStatus { loading, ready, empty, error }

/// Fileira de recomendações de um gênero.
class GenreShelf {
  const GenreShelf(this.genre, this.books);

  final Genre genre;
  final List<Book> books;
}

/// "Bom dia", "Boa tarde" ou "Boa noite" pela hora de [time].
String greetingFor(DateTime time) {
  final hour = time.hour;
  if (hour >= 5 && hour < 12) return 'Bom dia';
  if (hour >= 12 && hour < 18) return 'Boa tarde';
  return 'Boa noite';
}

/// Estado da Home: saudação e recomendações pelos gêneros (S08). Sem IA:
/// cada gênero vira uma busca `subject:` na Google Books.
class HomeStore = _HomeStore with _$HomeStore;

abstract class _HomeStore with Store {
  _HomeStore({
    required PreferencesRepository preferences,
    required this._books,
    required this._now,
  }) {
    final saved = preferences.load();
    name = saved?.name ?? '';
    genres = [
      for (final key in saved?.genres ?? const <String>[]) ?Genre.fromKey(key),
    ].take(maxRecommendedGenres).toList();
  }

  final BooksRepository _books;
  final DateTime Function() _now;

  late final String name;

  /// Gêneros consultados, na ordem do onboarding (no máximo 3).
  late final List<Genre> genres;

  int _requestId = 0;

  @observable
  HomeStatus status = HomeStatus.loading;

  @observable
  Book? spotlight;

  /// Gênero de onde saiu o destaque.
  @observable
  Genre? spotlightGenre;

  @observable
  List<GenreShelf> shelves = const [];

  @observable
  String? errorMessage;

  /// Ex.: "Boa noite, Gabriel".
  String get greeting {
    final hello = greetingFor(_now());
    return name.isEmpty ? hello : '$hello, $name';
  }

  /// Busca as recomendações de todos os gêneros em paralelo. Um gênero que
  /// falha é omitido; só vira erro se todos falharem.
  @action
  Future<void> load() async {
    final requestId = ++_requestId;
    status = HomeStatus.loading;
    errorMessage = null;
    if (genres.isEmpty) {
      _show(const []);
      return;
    }
    BooksException? firstError;
    final results = await Future.wait([
      for (final genre in genres)
        _books
            .searchBySubject(genre.subject)
            .then<List<Book>?>(
              (books) => books,
              onError: (Object error) {
                if (error is! BooksException) throw error;
                firstError ??= error;
                return null;
              },
            ),
    ]);
    if (requestId != _requestId) return;
    if (results.every((books) => books == null)) {
      _fail(firstError!.message);
      return;
    }
    final seen = <String>{};
    _show([
      for (var i = 0; i < genres.length; i++)
        GenreShelf(genres[i], [
          for (final book in results[i] ?? const <Book>[])
            if (seen.add(book.id)) book,
        ]),
    ]);
  }

  @action
  void _show(List<GenreShelf> all) {
    final filled = all.where((shelf) => shelf.books.isNotEmpty).toList();
    if (filled.isEmpty) {
      spotlight = null;
      spotlightGenre = null;
      shelves = const [];
      status = HomeStatus.empty;
      return;
    }
    final first = filled.first;
    spotlight = first.books.first;
    spotlightGenre = first.genre;
    shelves = [
      if (first.books.length > 1)
        GenreShelf(first.genre, first.books.sublist(1)),
      ...filled.skip(1),
    ];
    status = HomeStatus.ready;
  }

  @action
  void _fail(String message) {
    errorMessage = message;
    spotlight = null;
    shelves = const [];
    status = HomeStatus.error;
  }
}

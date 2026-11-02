import 'package:bookvault/core/storage/local_storage.dart';
import 'package:bookvault/data/repositories/books_repository.dart';
import 'package:bookvault/data/repositories/preferences_repository.dart';
import 'package:bookvault/models/genre.dart';
import 'package:bookvault/models/user_preferences.dart';
import 'package:bookvault/services/books_api_service.dart';
import 'package:bookvault/stores/home_store.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_dio.dart';
import '../helpers/fake_preferences.dart';
import '../helpers/google_books_fixtures.dart';

void main() {
  late FakeHttpAdapter adapter;

  /// Responde por assunto: `subject:fantasy` → livros de [bySubject].
  FakeHandler bySubject(Map<String, List<String>> ids) => (options) {
    final subject = (options.queryParameters['q'] as String).substring(8);
    final found = ids[subject];
    if (found == null) {
      throw DioException(
        requestOptions: options,
        type: DioExceptionType.connectionError,
      );
    }
    return jsonBody(
      searchJson([
        for (final id in found) volumeJson(id: id, title: 'Livro $id'),
      ]),
    );
  };

  Future<HomeStore> storeWith(
    List<String> genres, {
    String name = 'Gabriel',
    DateTime? now,
  }) async {
    final prefs = PreferencesRepository(
      storage: LocalStorage(await openPreferences()),
    );
    await prefs.save(UserPreferences(name: name, genres: genres));
    return HomeStore(
      preferences: prefs,
      books: BooksRepository(api: BooksApiService(fakeDio(adapter))),
      now: () => now ?? DateTime(2026, 11, 2, 20),
    );
  }

  setUp(() {
    adapter = FakeHttpAdapter(
      bySubject({
        'fantasy': ['a', 'b', 'c'],
        'philosophy': ['d', 'b', 'e'],
      }),
    );
  });

  group('greetingFor', () {
    test('muda com a hora do dia', () {
      expect(greetingFor(DateTime(2026, 1, 1, 5)), 'Bom dia');
      expect(greetingFor(DateTime(2026, 1, 1, 11, 59)), 'Bom dia');
      expect(greetingFor(DateTime(2026, 1, 1, 12)), 'Boa tarde');
      expect(greetingFor(DateTime(2026, 1, 1, 17, 59)), 'Boa tarde');
      expect(greetingFor(DateTime(2026, 1, 1, 18)), 'Boa noite');
      expect(greetingFor(DateTime(2026, 1, 1, 4, 59)), 'Boa noite');
    });
  });

  test('saudação usa o nome salvo', () async {
    final store = await storeWith(['fantasy']);
    expect(store.greeting, 'Boa noite, Gabriel');
  });

  test('busca cada gênero por subject e monta destaque e fileiras', () async {
    final store = await storeWith(['fantasy', 'philosophy']);
    await store.load();

    expect(
      adapter.requests.map((r) => r.queryParameters['q']),
      containsAll(['subject:fantasy', 'subject:philosophy']),
    );
    expect(store.status, HomeStatus.ready);
    expect(store.spotlight?.id, 'a');
    expect(store.spotlightGenre, Genre.fantasy);
    expect(store.shelves.map((s) => s.genre), [
      Genre.fantasy,
      Genre.philosophy,
    ]);
    expect(store.shelves.first.books.map((b) => b.id), ['b', 'c']);
  });

  test('livro repetido aparece só no primeiro gênero', () async {
    final store = await storeWith(['fantasy', 'philosophy']);
    await store.load();

    expect(store.shelves.last.books.map((b) => b.id), ['d', 'e']);
  });

  test('consulta no máximo 3 gêneros', () async {
    adapter.handler = (options) => jsonBody(searchJson([]));
    final store = await storeWith([
      'fantasy',
      'philosophy',
      'history',
      'mystery',
      'classics',
    ]);
    await store.load();

    expect(adapter.requests, hasLength(3));
    expect(store.genres, [Genre.fantasy, Genre.philosophy, Genre.history]);
  });

  test('falha em um gênero mostra os outros', () async {
    final store = await storeWith(['history', 'philosophy']);
    await store.load();

    expect(store.status, HomeStatus.ready);
    expect(store.spotlight?.id, 'd');
    expect(store.shelves.single.genre, Genre.philosophy);
  });

  test('falha em todos vira erro em pt-BR', () async {
    final store = await storeWith(['history', 'mystery']);
    await store.load();

    expect(store.status, HomeStatus.error);
    expect(store.errorMessage, contains('Sem conexão'));
  });

  test('nenhum livro em nenhum gênero fica vazio', () async {
    adapter.handler = (options) => jsonBody(searchJson([]));
    final store = await storeWith(['fantasy']);
    await store.load();

    expect(store.status, HomeStatus.empty);
    expect(store.spotlight, isNull);
  });

  test('gênero com um só livro vira só o destaque', () async {
    adapter.handler = bySubject({
      'fantasy': ['a'],
      'philosophy': ['d'],
    });
    final store = await storeWith(['fantasy', 'philosophy']);
    await store.load();

    expect(store.spotlight?.id, 'a');
    expect(store.shelves.single.genre, Genre.philosophy);
  });
}

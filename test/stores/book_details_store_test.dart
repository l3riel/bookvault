import 'package:bookvault/core/storage/local_storage.dart';
import 'package:bookvault/data/repositories/books_repository.dart';
import 'package:bookvault/data/repositories/library_repository.dart';
import 'package:bookvault/models/book.dart';
import 'package:bookvault/models/reading_status.dart';
import 'package:bookvault/services/books_api_service.dart';
import 'package:bookvault/stores/book_details_store.dart';
import 'package:bookvault/stores/library_store.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_dio.dart';
import '../helpers/fake_preferences.dart';
import '../helpers/google_books_fixtures.dart';

void main() {
  const dune = Book(id: 'dune', title: 'Duna', authors: ['Frank Herbert']);

  late FakeHttpAdapter adapter;
  late LibraryRepository libraryRepository;
  late LibraryStore library;

  setUp(() async {
    adapter = FakeHttpAdapter(
      (options) => jsonBody(volumeJson(id: 'dune', title: 'Duna (API)')),
    );
    libraryRepository = LibraryRepository(
      storage: LocalStorage(await openPreferences()),
    );
    library = LibraryStore(libraryRepository)..load();
  });

  BookDetailsStore storeFor(String id, {Book? initial}) => BookDetailsStore(
    bookId: id,
    books: BooksRepository(api: BooksApiService(fakeDio(adapter))),
    library: library,
    initialBook: initial,
  );

  test('usa o livro recebido sem chamar a API', () async {
    final store = storeFor('dune', initial: dune);
    await store.load();

    expect(store.status, BookDetailsStatus.loaded);
    expect(store.book, dune);
    expect(adapter.requests, isEmpty);
  });

  test('livro salvo carrega do aparelho, mesmo sem internet', () async {
    adapter.handler = failWith(DioExceptionType.connectionError);
    await library.add(dune, status: ReadingStatus.reading);

    final store = storeFor('dune');
    await store.load();

    expect(store.book?.title, 'Duna');
    expect(store.savedBook?.status, ReadingStatus.reading);
    expect(adapter.requests, isEmpty);
  });

  test('sem livro conhecido busca na API pelo id', () async {
    final store = storeFor('dune');
    await store.load();

    expect(store.book?.title, 'Duna (API)');
    expect(adapter.requests.single.path, 'volumes/dune');
  });

  test('falha na API mostra a mensagem de erro', () async {
    adapter.handler = failWith(DioExceptionType.connectionError);

    final store = storeFor('dune');
    await store.load();

    expect(store.status, BookDetailsStatus.error);
    expect(store.errorMessage, contains('Sem conexão'));
  });

  test('adicionar salva como Quero ler na biblioteca', () async {
    final store = storeFor('dune', initial: dune);
    await store.load();

    await store.add();

    expect(store.isSaved, isTrue);
    expect(store.savedBook?.status, ReadingStatus.wantToRead);
    expect(library.total, 1);
    expect(libraryRepository.contains('dune'), isTrue);
  });

  test('muda o status e remove pela biblioteca', () async {
    final store = storeFor('dune', initial: dune);
    await store.load();
    await store.add();

    await store.changeStatus(ReadingStatus.completed);
    expect(library.savedBook('dune')?.status, ReadingStatus.completed);

    await store.remove();
    expect(store.isSaved, isFalse);
    expect(libraryRepository.contains('dune'), isFalse);
  });
}

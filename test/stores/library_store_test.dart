import 'package:bookvault/core/storage/local_storage.dart';
import 'package:bookvault/data/repositories/library_repository.dart';
import 'package:bookvault/models/book.dart';
import 'package:bookvault/models/reading_status.dart';
import 'package:bookvault/stores/library_store.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_preferences.dart';

void main() {
  late LibraryRepository repository;
  late LibraryStore store;

  setUp(() async {
    var clock = DateTime.utc(2026, 11, 2);
    repository = LibraryRepository(
      storage: LocalStorage(await openPreferences()),
      now: () => clock = clock.add(const Duration(minutes: 1)),
    );
    await repository.add(const Book(id: 'dune', title: 'Duna'));
    await repository.add(
      const Book(id: 'hobbit', title: 'O Hobbit'),
      status: ReadingStatus.reading,
    );
    await repository.add(
      const Book(id: '1984', title: '1984'),
      status: ReadingStatus.reading,
    );
    store = LibraryStore(repository)..load();
  });

  test('carrega os livros do mais recente para o mais antigo', () {
    expect(store.books.map((b) => b.id), ['1984', 'hobbit', 'dune']);
    expect(store.total, 3);
  });

  test('conta livros por status', () {
    expect(store.countByStatus, {
      ReadingStatus.wantToRead: 1,
      ReadingStatus.reading: 2,
      ReadingStatus.completed: 0,
    });
  });

  test('filtro destaca só o status escolhido', () {
    store.setFilter(ReadingStatus.reading);

    expect(store.filteredCount, 2);
    expect(store.isHighlighted(store.books.first), isTrue);
    expect(store.isHighlighted(store.books.last), isFalse);

    store.setFilter(null);
    expect(store.books.every(store.isHighlighted), isTrue);
  });

  test('mudar status atualiza a lista e grava', () async {
    await store.changeStatus('dune', ReadingStatus.completed);

    expect(store.books.last.status, ReadingStatus.completed);
    expect(repository.findById('dune')?.status, ReadingStatus.completed);
    expect(store.countByStatus[ReadingStatus.completed], 1);
  });

  test('remover tira da lista e do armazenamento', () async {
    await store.remove('hobbit');

    expect(store.books.map((b) => b.id), ['1984', 'dune']);
    expect(repository.contains('hobbit'), isFalse);
  });
}

import 'dart:convert';

import 'package:bookvault/core/storage/local_storage.dart';
import 'package:bookvault/data/repositories/library_repository.dart';
import 'package:bookvault/models/book.dart';
import 'package:bookvault/models/reading_status.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/fake_preferences.dart';

void main() {
  const dune = Book(id: 'dune', title: 'Duna', authors: ['Frank Herbert']);
  const hobbit = Book(id: 'hobbit', title: 'O Hobbit');
  const orwell = Book(id: '1984', title: '1984');

  late SharedPreferences preferences;
  late DateTime clock;

  LibraryRepository repositoryOn(SharedPreferences prefs) =>
      LibraryRepository(storage: LocalStorage(prefs), now: () => clock);

  setUp(() async {
    preferences = await openPreferences();
    clock = DateTime.utc(2026, 11, 2, 10);
  });

  test('livro adicionado continua salvo depois de reabrir o app', () async {
    await repositoryOn(preferences).add(dune);

    final reopened = repositoryOn(await reopenPreferences(preferences));
    final saved = reopened.findById('dune');

    expect(saved?.book, dune);
    expect(saved?.status, ReadingStatus.wantToRead);
    expect(saved?.addedAt, DateTime.utc(2026, 11, 2, 10));
  });

  test('adicionar livro repetido lança StateError e não duplica', () async {
    final repository = repositoryOn(preferences);
    await repository.add(dune);

    await expectLater(repository.add(dune), throwsStateError);
    expect(repository.getAll(), hasLength(1));
  });

  test('atualização de status persiste depois de reabrir', () async {
    final repository = repositoryOn(preferences);
    await repository.add(dune);

    final updated = await repository.updateStatus(
      'dune',
      ReadingStatus.reading,
    );

    expect(updated.status, ReadingStatus.reading);
    final reopened = repositoryOn(await reopenPreferences(preferences));
    expect(reopened.findById('dune')?.status, ReadingStatus.reading);
  });

  test('livro removido some e não volta depois de reabrir', () async {
    final repository = repositoryOn(preferences);
    await repository.add(dune);
    await repository.add(hobbit);

    await repository.remove('dune');

    expect(repository.contains('dune'), isFalse);
    final reopened = repositoryOn(await reopenPreferences(preferences));
    expect(reopened.getAll().map((b) => b.id), ['hobbit']);
  });

  test('atualizar status de livro ausente lança StateError', () async {
    await expectLater(
      repositoryOn(preferences).updateStatus('nada', ReadingStatus.completed),
      throwsStateError,
    );
  });

  test('lista do mais recente para o mais antigo', () async {
    final repository = repositoryOn(preferences);
    await repository.add(hobbit);
    clock = clock.add(const Duration(days: 1));
    await repository.add(orwell);
    clock = clock.add(const Duration(days: 1));
    await repository.add(dune);

    expect(repository.getAll().map((b) => b.id), ['dune', '1984', 'hobbit']);
  });

  test('ignora item corrompido e carrega os demais', () async {
    final valid = {
      'book': dune.toJson(),
      'status': 'reading',
      'addedAt': '2026-11-02T10:00:00.000Z',
    };
    final prefs = await openPreferences({
      LibraryRepository.storageKey: jsonEncode([
        valid,
        {...valid, 'status': 'abandonado'},
        'não é um objeto',
      ]),
    });

    final books = repositoryOn(prefs).getAll();

    expect(books, hasLength(1));
    expect(books.single.id, 'dune');
  });

  test('biblioteca vazia quando não há nada salvo', () {
    expect(repositoryOn(preferences).getAll(), isEmpty);
  });
}

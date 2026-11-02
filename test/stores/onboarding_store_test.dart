import 'package:bookvault/core/storage/local_storage.dart';
import 'package:bookvault/data/repositories/preferences_repository.dart';
import 'package:bookvault/models/genre.dart';
import 'package:bookvault/models/user_preferences.dart';
import 'package:bookvault/stores/onboarding_store.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_preferences.dart';

void main() {
  late PreferencesRepository repository;
  late OnboardingStore store;

  setUp(() async {
    repository = PreferencesRepository(
      storage: LocalStorage(await openPreferences()),
    );
    store = OnboardingStore(repository);
  });

  test('começa vazio e sem poder enviar', () {
    expect(store.name, isEmpty);
    expect(store.selectedCount, 0);
    expect(store.canSubmit, isFalse);
  });

  test('marca e desmarca gêneros', () {
    store
      ..toggleGenre(Genre.fantasy)
      ..toggleGenre(Genre.history);
    expect(store.selectedCount, 2);

    store.toggleGenre(Genre.fantasy);
    expect(store.selectedGenres, {Genre.history});
  });

  test('exige nome (sem contar espaços) e ao menos um gênero', () {
    store.setName('   ');
    store.toggleGenre(Genre.fantasy);
    expect(store.canSubmit, isFalse);

    store
      ..setName('Gabriel')
      ..toggleGenre(Genre.fantasy);
    expect(store.canSubmit, isFalse);

    store.toggleGenre(Genre.fantasy);
    expect(store.canSubmit, isTrue);
  });

  test('não aceita nome com mais de 40 caracteres', () {
    store
      ..setName('a' * 41)
      ..toggleGenre(Genre.fantasy);

    expect(store.canSubmit, isFalse);
  });

  test('salva nome sem espaços e as chaves dos gêneros', () async {
    store
      ..setName('  Gabriel  ')
      ..toggleGenre(Genre.history)
      ..toggleGenre(Genre.fantasy);

    final saved = await store.submit();

    expect(saved, isTrue);
    expect(
      repository.load(),
      const UserPreferences(name: 'Gabriel', genres: ['fantasy', 'history']),
    );
    expect(store.isSaving, isFalse);
  });

  test('não salva formulário incompleto', () async {
    store.setName('Gabriel');

    expect(await store.submit(), isFalse);
    expect(repository.load(), isNull);
  });
}

import 'package:bookvault/core/storage/local_storage.dart';
import 'package:bookvault/data/repositories/preferences_repository.dart';
import 'package:bookvault/models/user_preferences.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/fake_preferences.dart';

void main() {
  PreferencesRepository repositoryOn(SharedPreferences prefs) =>
      PreferencesRepository(storage: LocalStorage(prefs));

  test('preferências salvas continuam depois de reabrir o app', () async {
    final preferences = await openPreferences();
    const saved = UserPreferences(name: 'Gabriel', genres: ['Fantasia']);

    await repositoryOn(preferences).save(saved);

    final reopened = repositoryOn(await reopenPreferences(preferences));
    expect(reopened.load(), saved);
  });

  test('sem preferências salvas, load devolve null', () async {
    expect(repositoryOn(await openPreferences()).load(), isNull);
  });

  test('preferências corrompidas viram null', () async {
    final preferences = await openPreferences({
      PreferencesRepository.storageKey: '{"genres": ["Fantasia"]}',
    });

    expect(repositoryOn(preferences).load(), isNull);
  });
}

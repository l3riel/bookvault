import 'package:bookvault/core/storage/local_storage.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_preferences.dart';

void main() {
  test('grava e lê JSON por chave', () async {
    final storage = LocalStorage(await openPreferences());

    await storage.writeJson('chave', {
      'lista': [1, 2],
    });

    expect(storage.readJson('chave'), {
      'lista': [1, 2],
    });
  });

  test('devolve null para chave ausente ou JSON inválido', () async {
    final storage = LocalStorage(await openPreferences({'ruim': '{nao-json'}));

    expect(storage.readJson('ausente'), isNull);
    expect(storage.readJson('ruim'), isNull);
  });

  test('remove a chave', () async {
    final storage = LocalStorage(await openPreferences());
    await storage.writeJson('chave', 'valor');

    await storage.remove('chave');

    expect(storage.readJson('chave'), isNull);
  });
}

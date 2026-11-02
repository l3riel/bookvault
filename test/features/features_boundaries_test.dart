import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Telas falam só com Stores: nada de HTTP, persistência, repositórios ou
/// serviços dentro de `lib/features` (plano, seção 4; S09).
void main() {
  test('nenhuma tela importa Dio, SharedPreferences, data/ ou services/', () {
    final files = Directory('lib/features')
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'));
    final forbidden = RegExp(
      r'''import\s+['"](package:dio/|package:shared_preferences/|.*/data/|.*/services/|.*/core/)''',
    );

    expect(files, isNotEmpty);
    for (final file in files) {
      expect(
        forbidden.hasMatch(file.readAsStringSync()),
        isFalse,
        reason: '${file.path} importa uma camada proibida',
      );
    }
  });
}

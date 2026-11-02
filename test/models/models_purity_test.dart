import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Os modelos são Dart puro: não podem depender de Flutter, Dio ou DTOs.
void main() {
  test('nenhum arquivo de lib/models importa Flutter, Dio ou DTOs', () {
    final files = Directory('lib/models')
        .listSync()
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'));
    final forbidden = RegExp(
      r'''import\s+['"](package:flutter/|package:dio/|.*dtos/)''',
    );

    expect(files, isNotEmpty);
    for (final file in files) {
      expect(
        forbidden.hasMatch(file.readAsStringSync()),
        isFalse,
        reason: '${file.path} importa uma dependência proibida',
      );
    }
  });
}

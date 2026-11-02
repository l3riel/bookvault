import 'dart:convert';

import 'package:bookvault/app/app_dependencies.dart';
import 'package:bookvault/core/network/dio_client.dart';
import 'package:bookvault/data/repositories/preferences_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('monta armazenamento, repositórios e Dio da Google Books', () async {
    SharedPreferences.setMockInitialValues({
      PreferencesRepository.storageKey: jsonEncode({
        'name': 'Gabriel',
        'genres': ['Fantasia'],
      }),
    });

    final dependencies = await AppDependencies.create();

    expect(dependencies.preferencesRepository.load()?.name, 'Gabriel');
    expect(dependencies.libraryRepository.getAll(), isEmpty);
    expect(dependencies.booksRepository, isNotNull);
    expect(dependencies.dio.options.baseUrl, googleBooksBaseUrl);
    expect(
      dependencies.dio.options.connectTimeout,
      const Duration(seconds: 10),
    );
  });
}

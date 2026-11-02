import 'dart:convert';

import 'package:bookvault/app/app.dart';
import 'package:bookvault/app/app_dependencies.dart';
import 'package:bookvault/app/router.dart';
import 'package:bookvault/data/repositories/library_repository.dart';
import 'package:bookvault/data/repositories/preferences_repository.dart';
import 'package:bookvault/models/user_book.dart';
import 'package:bookvault/models/user_preferences.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'fake_dio.dart';
import 'fake_preferences.dart';

/// Usuário que já fez o onboarding.
const UserPreferences onboardedUser = UserPreferences(
  name: 'Gabriel',
  genres: ['fantasy'],
);

/// App montado para teste de widget.
class TestApp {
  const TestApp(this.dependencies, this.router, this.api);

  final AppDependencies dependencies;
  final GoRouter router;

  /// Requisições feitas à Google Books (falsa).
  final FakeHttpAdapter api;
}

/// Monta o app inteiro em tela de celular (360×800), sem rede.
///
/// Com [preferences] nulo, simula o primeiro acesso. [library] já vem salva.
/// [api] responde às chamadas da Google Books; sem ele, toda chamada falha
/// como "sem conexão". As requisições feitas ao abrir (recomendações da Home)
/// são descartadas de `api.requests`, salvo com [keepStartupRequests].
Future<TestApp> pumpBookVault(
  WidgetTester tester, {
  UserPreferences? preferences = onboardedUser,
  List<UserBook> library = const [],
  FakeHandler? api,
  bool keepStartupRequests = false,
}) async {
  tester.view
    ..physicalSize = const Size(1080, 2400)
    ..devicePixelRatio = 3;
  addTearDown(tester.view.reset);

  final prefs = await openPreferences({
    if (preferences != null)
      PreferencesRepository.storageKey: jsonEncode(preferences.toJson()),
    if (library.isNotEmpty)
      LibraryRepository.storageKey: jsonEncode([
        for (final userBook in library) userBook.toJson(),
      ]),
  });
  final adapter = FakeHttpAdapter(
    api ?? failWith(DioExceptionType.connectionError),
  );
  final dependencies = AppDependencies(
    preferences: prefs,
    dio: fakeDio(adapter),
  );
  final router = createAppRouter(dependencies);
  await tester.pumpWidget(
    BookVaultApp(dependencies: dependencies, router: router),
  );
  await tester.pumpAndSettle();
  if (!keepStartupRequests) adapter.requests.clear();
  return TestApp(dependencies, router, adapter);
}

import 'dart:convert';

import 'package:bookvault/app/app.dart';
import 'package:bookvault/app/app_dependencies.dart';
import 'package:bookvault/app/router.dart';
import 'package:bookvault/data/repositories/preferences_repository.dart';
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
  const TestApp(this.dependencies, this.router);

  final AppDependencies dependencies;
  final GoRouter router;
}

/// Monta o app inteiro em tela de celular (360×800), sem rede.
///
/// Com [preferences] nulo, simula o primeiro acesso.
Future<TestApp> pumpBookVault(
  WidgetTester tester, {
  UserPreferences? preferences = onboardedUser,
}) async {
  tester.view
    ..physicalSize = const Size(1080, 2400)
    ..devicePixelRatio = 3;
  addTearDown(tester.view.reset);

  final prefs = await openPreferences({
    if (preferences != null)
      PreferencesRepository.storageKey: jsonEncode(preferences.toJson()),
  });
  final dependencies = AppDependencies(
    preferences: prefs,
    dio: fakeDio(FakeHttpAdapter(failWith(DioExceptionType.connectionError))),
  );
  final router = createAppRouter(dependencies);
  await tester.pumpWidget(
    BookVaultApp(dependencies: dependencies, router: router),
  );
  await tester.pumpAndSettle();
  return TestApp(dependencies, router);
}

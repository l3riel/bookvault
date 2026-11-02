import 'package:bookvault/features/home/home_page.dart';
import 'package:bookvault/features/onboarding/onboarding_page.dart';
import 'package:bookvault/models/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  Finder startButton() => find.ancestor(
    of: find.text('Começar'),
    matching: find.byType(FilledButton),
  );

  bool isEnabled(WidgetTester tester) =>
      tester.widget<FilledButton>(startButton()).onPressed != null;

  Future<void> tapText(WidgetTester tester, String text) async {
    await tester.ensureVisible(find.text(text));
    await tester.tap(find.text(text));
    await tester.pumpAndSettle();
  }

  testWidgets('primeiro acesso abre o onboarding em pt-BR', (tester) async {
    await pumpBookVault(tester, preferences: null);

    expect(find.byType(OnboardingPage), findsOneWidget);
    expect(find.text('Como devemos te chamar?'), findsOneWidget);
    expect(find.text('Escolha seus gêneros favoritos'), findsOneWidget);
    expect(find.text('Salvo apenas neste aparelho'), findsOneWidget);
    for (final label in ['Ficção científica', 'Fantasia', 'Suspense']) {
      expect(find.text(label), findsOneWidget);
    }
  });

  testWidgets('contador acompanha os gêneros marcados', (tester) async {
    await pumpBookVault(tester, preferences: null);

    await tapText(tester, 'Fantasia');
    expect(find.text('1 selecionado'), findsOneWidget);

    await tapText(tester, 'História');
    expect(find.text('2 selecionados'), findsOneWidget);

    await tapText(tester, 'Fantasia');
    expect(find.text('1 selecionado'), findsOneWidget);
  });

  testWidgets('botão fica desabilitado sem nome ou sem gênero', (tester) async {
    await pumpBookVault(tester, preferences: null);
    expect(isEnabled(tester), isFalse);

    await tester.enterText(find.byType(TextField), '   ');
    await tapText(tester, 'Fantasia');
    expect(isEnabled(tester), isFalse);

    await tester.enterText(find.byType(TextField), 'Gabriel');
    await tester.pump();
    expect(isEnabled(tester), isTrue);

    await tapText(tester, 'Fantasia');
    expect(isEnabled(tester), isFalse);
  });

  testWidgets('salva as preferências e vai para o Início', (tester) async {
    final app = await pumpBookVault(tester, preferences: null);

    await tester.enterText(find.byType(TextField), '  Gabriel  ');
    await tapText(tester, 'Fantasia');
    await tester.ensureVisible(startButton());
    await tester.tap(startButton());
    await tester.pumpAndSettle();

    expect(find.byType(HomePage), findsOneWidget);
    expect(
      app.dependencies.preferencesRepository.load(),
      const UserPreferences(name: 'Gabriel', genres: ['fantasy']),
    );
  });

  testWidgets('depois do onboarding, reabrir o app vai direto ao Início', (
    tester,
  ) async {
    final app = await pumpBookVault(tester, preferences: null);
    await tester.enterText(find.byType(TextField), 'Gabriel');
    await tapText(tester, 'Fantasia');
    await tester.ensureVisible(startButton());
    await tester.tap(startButton());
    await tester.pumpAndSettle();

    // Reabre o app do zero com o que o onboarding gravou.
    final saved = app.dependencies.preferencesRepository.load();
    expect(saved, isNotNull);
    await pumpBookVault(tester, preferences: saved);

    expect(find.byType(HomePage), findsOneWidget);
    expect(find.byType(OnboardingPage), findsNothing);
  });
}

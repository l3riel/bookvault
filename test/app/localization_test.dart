import 'dart:async';

import 'package:bookvault/app/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_dio.dart';
import '../helpers/google_books_fixtures.dart';
import '../helpers/pump_app.dart';

void main() {
  testWidgets('rótulos do Material ficam em pt-BR', (tester) async {
    final app = await pumpBookVault(
      tester,
      api: (options) => jsonBody(volumeJson(id: 'dune')),
    );

    unawaited(app.router.push(AppRoutes.bookDetailsOf('dune')));
    await tester.pumpAndSettle();

    expect(find.byTooltip('Voltar'), findsOneWidget);
    expect(
      Localizations.localeOf(tester.element(find.byType(Scaffold).first)),
      const Locale('pt', 'BR'),
    );
  });
}

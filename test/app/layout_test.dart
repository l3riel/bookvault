import 'package:bookvault/app/app.dart';
import 'package:bookvault/app/router.dart';
import 'package:bookvault/models/book.dart';
import 'package:bookvault/models/reading_status.dart';
import 'package:bookvault/models/user_book.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/pump_app.dart';

void main() {
  testWidgets('em tela larga o conteúdo fica numa coluna de 600 px', (
    tester,
  ) async {
    await pumpBookVault(tester, logicalSize: const Size(1200, 800));

    final scaffold = tester.getRect(find.byType(Scaffold).first);
    expect(scaffold.width, maxContentWidth);
    expect(scaffold.center.dx, 600);
  });

  testWidgets('no celular o conteúdo ocupa a largura toda', (tester) async {
    await pumpBookVault(tester);

    expect(tester.getSize(find.byType(Scaffold).first).width, 360);
  });

  testWidgets('o fim dos Detalhes não fica sob a barra de gestos', (
    tester,
  ) async {
    final longText = List.filled(40, 'Uma frase longa da sinopse.').join(' ');
    final app = await pumpBookVault(
      tester,
      library: [
        UserBook(
          book: Book(id: 'dune', title: 'Duna', description: longText),
          status: ReadingStatus.reading,
          addedAt: DateTime.utc(2026, 11, 2),
        ),
      ],
    );
    tester.view.padding = const FakeViewPadding(bottom: 48 * 3);
    app.router.go(AppRoutes.bookDetailsOf('dune'));
    await tester.pumpAndSettle();

    await tester.drag(
      find.byType(SingleChildScrollView),
      const Offset(0, -5000),
    );
    await tester.pumpAndSettle();

    // A área de rolagem termina acima da barra de gestos (48 px).
    expect(tester.getRect(find.byType(SingleChildScrollView)).bottom, 800 - 48);
    expect(find.text(longText), findsOneWidget);
  });
}

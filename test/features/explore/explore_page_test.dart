import 'package:bookvault/features/book_details/book_details_page.dart';
import 'package:bookvault/features/explore/widgets/search_result_card.dart';
import 'package:bookvault/models/book.dart';
import 'package:bookvault/models/reading_status.dart';
import 'package:bookvault/models/user_book.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_dio.dart';
import '../../helpers/google_books_fixtures.dart';
import '../../helpers/pump_app.dart';

void main() {
  final twoBooks = searchJson([
    volumeJson(id: 'dune', title: 'Duna', thumbnail: null),
    volumeJson(id: 'hobbit', title: 'O Hobbit', authors: null, thumbnail: null),
  ]);

  Future<TestApp> openExplore(
    WidgetTester tester, {
    FakeHandler? api,
    List<UserBook> library = const [],
  }) async {
    final app = await pumpBookVault(tester, api: api, library: library);
    await tester.tap(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text('Explorar'),
      ),
    );
    await tester.pumpAndSettle();
    return app;
  }

  Future<void> search(WidgetTester tester, String term) async {
    await tester.enterText(find.byType(TextField), term);
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();
  }

  Finder card(String title) => find.byWidgetPredicate(
    (widget) => widget is SearchResultCard && widget.book.title == title,
  );

  testWidgets('antes de buscar mostra a dica e os gêneros do usuário', (
    tester,
  ) async {
    final app = await openExplore(tester);

    expect(find.text('Busque por título ou autor'), findsOneWidget);
    expect(find.widgetWithText(ActionChip, 'Fantasia'), findsOneWidget);
    expect(app.api.requests, isEmpty);
  });

  testWidgets('busca ao confirmar e mostra a grade com a contagem', (
    tester,
  ) async {
    final app = await openExplore(tester, api: (options) => jsonBody(twoBooks));

    await tester.enterText(find.byType(TextField), 'duna');
    await tester.pump();
    expect(app.api.requests, isEmpty, reason: 'só busca ao confirmar');

    await search(tester, 'duna');

    expect(find.text('2 resultados'), findsOneWidget);
    expect(card('Duna'), findsOneWidget);
    expect(find.text('Frank Herbert'), findsOneWidget);
    expect(find.text('Autor desconhecido'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('book-cover-placeholder')),
      findsNWidgets(2),
    );
    expect(app.api.requests.single.queryParameters['q'], 'duna');
  });

  testWidgets('chip de gênero preenche o campo e busca', (tester) async {
    final app = await openExplore(tester, api: (options) => jsonBody(twoBooks));

    await tester.tap(find.widgetWithText(ActionChip, 'Fantasia'));
    await tester.pumpAndSettle();

    expect(app.api.requests.single.queryParameters['q'], 'Fantasia');
    expect(find.text('2 resultados'), findsOneWidget);
  });

  testWidgets('busca sem resultados mostra Nada encontrado', (tester) async {
    await openExplore(tester, api: (options) => jsonBody(searchJson([])));

    await search(tester, 'xyzzy');

    expect(find.text('Nada encontrado'), findsOneWidget);
    expect(find.textContaining('"xyzzy"'), findsOneWidget);
  });

  testWidgets('erro de rede mostra mensagem e Tentar de novo repete', (
    tester,
  ) async {
    final app = await openExplore(tester);

    await search(tester, 'duna');
    expect(find.textContaining('Sem conexão'), findsOneWidget);

    app.api.handler = (options) => jsonBody(twoBooks);
    await tester.tap(find.text('Tentar de novo'));
    await tester.pumpAndSettle();

    expect(find.text('2 resultados'), findsOneWidget);
    expect(app.api.requests, hasLength(2));
  });

  testWidgets('limpar volta à dica', (tester) async {
    await openExplore(tester, api: (options) => jsonBody(twoBooks));
    await search(tester, 'duna');

    await tester.tap(find.byTooltip('Limpar busca'));
    await tester.pumpAndSettle();

    expect(find.text('Busque por título ou autor'), findsOneWidget);
    expect(find.text('2 resultados'), findsNothing);
  });

  testWidgets('livro já salvo mostra o status no resultado', (tester) async {
    await openExplore(
      tester,
      api: (options) => jsonBody(twoBooks),
      library: [
        UserBook(
          book: const Book(id: 'dune', title: 'Duna'),
          status: ReadingStatus.reading,
          addedAt: DateTime.utc(2026, 11, 2),
        ),
      ],
    );

    await search(tester, 'duna');

    expect(
      find.descendant(of: card('Duna'), matching: find.text('Lendo')),
      findsOneWidget,
    );
  });

  testWidgets('tocar no resultado abre os detalhes', (tester) async {
    await openExplore(tester, api: (options) => jsonBody(twoBooks));
    await search(tester, 'duna');

    await tester.tap(card('Duna'));
    await tester.pumpAndSettle();

    expect(find.byType(BookDetailsPage), findsOneWidget);
  });
}

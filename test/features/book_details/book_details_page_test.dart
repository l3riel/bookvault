import 'dart:async';

import 'package:bookvault/app/router.dart';
import 'package:bookvault/features/book_details/book_details_page.dart';
import 'package:bookvault/features/explore/widgets/search_result_card.dart';
import 'package:bookvault/features/library/widgets/library_book_card.dart';
import 'package:bookvault/models/book.dart';
import 'package:bookvault/models/reading_status.dart';
import 'package:bookvault/models/user_book.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_dio.dart';
import '../../helpers/google_books_fixtures.dart';
import '../../helpers/pump_app.dart';

void main() {
  const fullDune = Book(
    id: 'dune',
    title: 'Duna',
    authors: ['Frank Herbert'],
    description: 'No planeta deserto Arrakis…',
    publisher: 'Aleph',
    publishedDate: '1965-08-01',
    pageCount: 612,
  );

  UserBook saved(Book book, ReadingStatus status) =>
      UserBook(book: book, status: status, addedAt: DateTime.utc(2026, 11, 2));

  Future<void> tapTab(WidgetTester tester, String label) async {
    await tester.tap(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text(label),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> openDetails(TestApp app, WidgetTester tester, String id) async {
    unawaited(app.router.push(AppRoutes.bookDetailsOf(id)));
    await tester.pumpAndSettle();
  }

  testWidgets('resultado da busca abre os detalhes sem nova requisição', (
    tester,
  ) async {
    final app = await pumpBookVault(
      tester,
      api: (options) => jsonBody(
        searchJson([
          volumeJson(
            id: 'dune',
            title: 'Duna',
            thumbnail: null,
            publisher: 'Aleph',
            publishedDate: '1965',
            pageCount: 612,
            description: 'Arrakis.',
          ),
        ]),
      ),
    );
    await tapTab(tester, 'Explorar');
    await tester.enterText(find.byType(TextField), 'duna');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(SearchResultCard));
    await tester.pumpAndSettle();

    expect(find.byType(BookDetailsPage), findsOneWidget);
    expect(find.text('1965 • Aleph • 612 páginas'), findsOneWidget);
    expect(find.text('Arrakis.'), findsOneWidget);
    expect(app.api.requests, hasLength(1), reason: 'só a busca');
  });

  testWidgets('link direto busca o livro pelo id', (tester) async {
    final app = await pumpBookVault(
      tester,
      api: (options) => jsonBody(volumeJson(id: 'dune', thumbnail: null)),
    );

    await openDetails(app, tester, 'dune');

    expect(find.text('Duna'), findsWidgets);
    expect(app.api.requests.single.path, 'volumes/dune');
  });

  testWidgets('link direto com erro mostra a mensagem e tenta de novo', (
    tester,
  ) async {
    final app = await pumpBookVault(tester);

    await openDetails(app, tester, 'dune');
    expect(find.textContaining('Sem conexão'), findsOneWidget);

    app.api.handler = (options) => jsonBody(volumeJson(id: 'dune'));
    await tester.tap(find.text('Tentar de novo'));
    await tester.pumpAndSettle();

    expect(find.text('Frank Herbert'), findsOneWidget);
  });

  testWidgets('metadados ausentes são omitidos ou substituídos', (
    tester,
  ) async {
    final app = await pumpBookVault(
      tester,
      api: (options) => jsonBody(
        volumeJson(id: 'x', title: 'Sem nada', authors: null, thumbnail: null),
      ),
    );

    await openDetails(app, tester, 'x');

    expect(find.text('Autor desconhecido'), findsOneWidget);
    expect(find.text('Sem sinopse disponível.'), findsOneWidget);
    expect(find.textContaining('•'), findsNothing);
    expect(find.textContaining('páginas'), findsNothing);
    expect(find.byKey(const ValueKey('book-cover-placeholder')), findsOne);
  });

  testWidgets('adicionar salva como Quero ler e aparece na Biblioteca', (
    tester,
  ) async {
    final app = await pumpBookVault(
      tester,
      api: (options) => jsonBody(volumeJson(id: 'dune', thumbnail: null)),
    );
    await openDetails(app, tester, 'dune');
    expect(find.text('Status de leitura'.toUpperCase()), findsNothing);

    await tester.tap(find.text('Adicionar à biblioteca'));
    await tester.pumpAndSettle();

    expect(find.text('Na sua biblioteca'), findsOneWidget);
    expect(find.text('Remover da biblioteca'), findsOneWidget);
    expect(find.text('STATUS DE LEITURA'), findsOneWidget);
    expect(
      app.dependencies.libraryRepository.findById('dune')?.status,
      ReadingStatus.wantToRead,
    );

    app.router.pop();
    await tester.pumpAndSettle();
    await tapTab(tester, 'Biblioteca');
    expect(find.byType(LibraryBookCard), findsOneWidget);
  });

  testWidgets('livro salvo mostra o status e muda na hora', (tester) async {
    final app = await pumpBookVault(
      tester,
      library: [saved(fullDune, ReadingStatus.wantToRead)],
    );
    await openDetails(app, tester, 'dune');

    await tester.tap(find.text('Concluído'));
    await tester.pumpAndSettle();

    expect(
      app.dependencies.libraryStore.savedBook('dune')?.status,
      ReadingStatus.completed,
    );
    expect(
      app.dependencies.libraryRepository.findById('dune')?.status,
      ReadingStatus.completed,
    );
  });

  testWidgets('remover pede confirmação e volta ao botão Adicionar', (
    tester,
  ) async {
    final app = await pumpBookVault(
      tester,
      library: [saved(fullDune, ReadingStatus.reading)],
    );
    await openDetails(app, tester, 'dune');

    await tester.tap(find.text('Remover da biblioteca'));
    await tester.pumpAndSettle();
    expect(find.text('Remover livro?'), findsOneWidget);
    await tester.tap(find.text('Remover'));
    await tester.pumpAndSettle();

    expect(find.text('Adicionar à biblioteca'), findsOneWidget);
    expect(app.dependencies.libraryRepository.contains('dune'), isFalse);
  });

  testWidgets('livro salvo abre pela Biblioteca sem internet', (tester) async {
    final app = await pumpBookVault(
      tester,
      library: [saved(fullDune, ReadingStatus.reading)],
    );
    await tapTab(tester, 'Biblioteca');

    await tester.tap(find.byType(LibraryBookCard));
    await tester.pumpAndSettle();

    expect(find.text('1965 • Aleph • 612 páginas'), findsOneWidget);
    expect(find.text('No planeta deserto Arrakis…'), findsOneWidget);
    expect(app.api.requests, isEmpty);
  });
}

import 'package:bookvault/features/book_details/book_details_page.dart';
import 'package:bookvault/features/explore/explore_page.dart';
import 'package:bookvault/features/library/widgets/library_book_card.dart';
import 'package:bookvault/features/library/widgets/library_filter_bar.dart';
import 'package:bookvault/models/book.dart';
import 'package:bookvault/models/reading_status.dart';
import 'package:bookvault/models/user_book.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

UserBook _saved(String id, String title, ReadingStatus status, int day) =>
    UserBook(
      book: Book(id: id, title: title, authors: ['Autor $id']),
      status: status,
      addedAt: DateTime.utc(2026, 11, day),
    );

final _library = [
  _saved('dune', 'Duna', ReadingStatus.reading, 3),
  _saved('hobbit', 'O Hobbit', ReadingStatus.wantToRead, 2),
  _saved('1984', '1984', ReadingStatus.completed, 1),
];

void main() {
  Finder card(String title) => find.byWidgetPredicate(
    (widget) =>
        widget is LibraryBookCard && widget.userBook.book.title == title,
  );

  Future<TestApp> openLibrary(
    WidgetTester tester, {
    List<UserBook>? library,
  }) async {
    final app = await pumpBookVault(tester, library: library ?? _library);
    await tester.tap(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text('Biblioteca'),
      ),
    );
    await tester.pumpAndSettle();
    return app;
  }

  double opacityOf(WidgetTester tester, String title) {
    return tester
        .widget<AnimatedOpacity>(
          find.descendant(
            of: card(title),
            matching: find.byType(AnimatedOpacity),
          ),
        )
        .opacity;
  }

  Future<Finder> chip(WidgetTester tester, String label) async {
    final finder = find.text(label);
    await tester.scrollUntilVisible(
      finder,
      120,
      scrollable: find.descendant(
        of: find.byType(LibraryFilterBar),
        matching: find.byType(Scrollable),
      ),
    );
    return finder;
  }

  Future<void> openOptions(WidgetTester tester, String title) async {
    await tester.tap(find.byTooltip('Opções de $title'));
    await tester.pumpAndSettle();
  }

  testWidgets('mostra os livros salvos com título, autor e status', (
    tester,
  ) async {
    await openLibrary(tester);

    expect(find.text('Minha biblioteca'), findsOneWidget);
    expect(find.text('3 livros na biblioteca'), findsOneWidget);
    expect(card('Duna'), findsOneWidget);
    expect(find.text('Autor dune'), findsOneWidget);
    expect(find.text('Lendo'), findsOneWidget);
    expect(find.text('Quero ler'), findsOneWidget);
  });

  testWidgets('biblioteca vazia leva ao Explorar', (tester) async {
    await openLibrary(tester, library: const []);

    expect(find.text('Sua biblioteca está vazia'), findsOneWidget);
    await tester.tap(find.text('Explorar livros'));
    await tester.pumpAndSettle();

    expect(find.byType(ExplorePage), findsOneWidget);
  });

  testWidgets('filtro mostra contagens e apaga os outros status', (
    tester,
  ) async {
    await openLibrary(tester);

    for (final label in [
      'Todos (3)',
      'Quero ler (1)',
      'Lendo (1)',
      'Concluídos (1)',
    ]) {
      expect(await chip(tester, label), findsOneWidget);
    }

    await tester.tap(await chip(tester, 'Lendo (1)'));
    await tester.pumpAndSettle();

    expect(opacityOf(tester, 'Duna'), 1);
    expect(opacityOf(tester, 'O Hobbit'), lessThan(1));
    expect(card('O Hobbit'), findsOneWidget);
  });

  testWidgets('muda o status pela folha e grava no aparelho', (tester) async {
    final app = await openLibrary(tester);

    await openOptions(tester, 'O Hobbit');
    await tester.tap(find.widgetWithText(ListTile, 'Concluído'));
    await tester.pumpAndSettle();

    expect(await chip(tester, 'Concluídos (2)'), findsOneWidget);
    expect(
      app.dependencies.libraryRepository.findById('hobbit')?.status,
      ReadingStatus.completed,
    );
  });

  testWidgets('remove o livro depois de confirmar', (tester) async {
    final app = await openLibrary(tester);

    await openOptions(tester, 'Duna');
    await tester.tap(find.text('Remover da biblioteca'));
    await tester.pumpAndSettle();
    expect(find.text('Remover livro?'), findsOneWidget);

    await tester.tap(find.text('Remover'));
    await tester.pumpAndSettle();

    expect(card('Duna'), findsNothing);
    expect(find.text('2 livros na biblioteca'), findsOneWidget);
    expect(app.dependencies.libraryRepository.contains('dune'), isFalse);
  });

  testWidgets('cancelar a remoção mantém o livro', (tester) async {
    await openLibrary(tester);

    await openOptions(tester, 'Duna');
    await tester.tap(find.text('Remover da biblioteca'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();

    expect(card('Duna'), findsOneWidget);
  });

  testWidgets('tocar no livro abre os detalhes', (tester) async {
    await openLibrary(tester);

    await tester.tap(card('Duna'));
    await tester.pumpAndSettle();

    expect(find.byType(BookDetailsPage), findsOneWidget);
    expect(find.text('dune'), findsOneWidget);
  });

  testWidgets('livro sem capa mostra o marcador', (tester) async {
    await openLibrary(tester);

    expect(
      find.byKey(const ValueKey('book-cover-placeholder')),
      findsNWidgets(3),
    );
  });
}

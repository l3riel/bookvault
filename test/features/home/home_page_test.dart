import 'package:bookvault/features/book_details/book_details_page.dart';
import 'package:bookvault/features/explore/explore_page.dart';
import 'package:bookvault/models/reading_status.dart';
import 'package:bookvault/models/user_preferences.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_dio.dart';
import '../../helpers/google_books_fixtures.dart';
import '../../helpers/pump_app.dart';

const _reader = UserPreferences(
  name: 'Gabriel',
  genres: ['fantasy', 'philosophy'],
);

/// Fantasia: Hobbit, Terramar. Filosofia: Mundo de Sofia. Busca comum: Duna.
ResponseBody _books(RequestOptions options) {
  final q = options.queryParameters['q'] as String;
  final items = switch (q) {
    'subject:fantasy' => [
      volumeJson(
        id: 'hobbit',
        title: 'O Hobbit',
        authors: ['J.R.R. Tolkien'],
        description: 'Bilbo parte numa aventura.',
        thumbnail: null,
      ),
      volumeJson(id: 'earthsea', title: 'Terramar', thumbnail: null),
    ],
    'subject:philosophy' => [
      volumeJson(id: 'sofia', title: 'O Mundo de Sofia', thumbnail: null),
    ],
    _ => [volumeJson(id: 'dune', title: 'Duna', thumbnail: null)],
  };
  return jsonBody(searchJson(items));
}

void main() {
  Future<TestApp> openHome(WidgetTester tester, {FakeHandler? api}) =>
      pumpBookVault(
        tester,
        preferences: _reader,
        api: api ?? _books,
        keepStartupRequests: true,
      );

  Future<void> tapTab(WidgetTester tester, String label) async {
    await tester.tap(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text(label),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('cumprimenta pelo nome e mostra destaque e fileiras', (
    tester,
  ) async {
    final app = await openHome(tester);

    expect(
      find.textContaining(RegExp(r'^Bo(m dia|a tarde|a noite), Gabriel$')),
      findsOneWidget,
    );
    expect(find.text('Destaque para você'), findsOneWidget);
    expect(find.text('Bilbo parte numa aventura.'), findsOneWidget);
    expect(find.text('Fantasia'), findsOneWidget);
    expect(find.text('Terramar'), findsWidgets);
    expect(find.text('Filosofia'), findsOneWidget);
    expect(find.text('O Mundo de Sofia'), findsWidgets);
    expect(
      app.api.requests.map((r) => r.queryParameters['q']),
      unorderedEquals(['subject:fantasy', 'subject:philosophy']),
    );
  });

  testWidgets('falha em tudo mostra erro e Tentar de novo recarrega', (
    tester,
  ) async {
    final app = await openHome(
      tester,
      api: failWith(DioExceptionType.connectionError),
    );

    expect(find.textContaining('Sem conexão'), findsOneWidget);

    app.api.handler = _books;
    await tester.ensureVisible(find.text('Tentar de novo'));
    await tester.tap(find.text('Tentar de novo'));
    await tester.pumpAndSettle();

    expect(find.text('Destaque para você'), findsOneWidget);
  });

  testWidgets('sem livros mostra o vazio, que leva ao Explorar', (
    tester,
  ) async {
    await openHome(tester, api: (options) => jsonBody(searchJson([])));

    expect(find.text('Nenhuma recomendação agora'), findsOneWidget);
    await tester.ensureVisible(find.text('Explorar livros'));
    await tester.tap(find.text('Explorar livros'));
    await tester.pumpAndSettle();

    expect(find.byType(ExplorePage), findsOneWidget);
  });

  testWidgets('Ver livro abre os detalhes sem nova requisição', (tester) async {
    final app = await openHome(tester);
    app.api.requests.clear();

    await tester.tap(find.text('Ver livro'));
    await tester.pumpAndSettle();

    expect(find.byType(BookDetailsPage), findsOneWidget);
    expect(find.text('Bilbo parte numa aventura.'), findsOneWidget);
    expect(app.api.requests, isEmpty);
  });

  testWidgets('livro da fileira abre os detalhes', (tester) async {
    await openHome(tester);

    await tester.ensureVisible(find.text('Terramar').first);
    await tester.tap(find.text('Terramar').first);
    await tester.pumpAndSettle();

    expect(find.byType(BookDetailsPage), findsOneWidget);
  });

  testWidgets('o 🔖 salva o destaque como Quero ler e fica marcado', (
    tester,
  ) async {
    final app = await openHome(tester);

    await tester.tap(find.byTooltip('Salvar na biblioteca'));
    await tester.pumpAndSettle();

    expect(
      app.dependencies.libraryRepository.findById('hobbit')?.status,
      ReadingStatus.wantToRead,
    );
    expect(find.byTooltip('Já está na biblioteca'), findsOneWidget);
  });

  testWidgets('Ver todos abre o Explorar buscando o gênero', (tester) async {
    final app = await openHome(tester);
    app.api.requests.clear();

    final seeAll = find.bySemanticsLabel('Ver todos de Filosofia');
    await tester.ensureVisible(seeAll);
    await tester.pumpAndSettle();
    await tester.tap(seeAll);
    await tester.pumpAndSettle();

    expect(find.byType(ExplorePage), findsOneWidget);
    expect(app.api.requests.single.queryParameters['q'], 'Filosofia');
    expect(find.text('1 resultado'), findsOneWidget);
  });

  testWidgets('campo de busca leva ao Explorar', (tester) async {
    await openHome(tester);

    await tester.tap(find.byKey(const ValueKey('home-search')));
    await tester.pumpAndSettle();

    expect(find.byType(ExplorePage), findsOneWidget);
  });

  testWidgets('trocar de aba e voltar não refaz as buscas', (tester) async {
    final app = await openHome(tester);
    final before = app.api.requests.length;

    await tapTab(tester, 'Biblioteca');
    await tapTab(tester, 'Início');

    expect(find.text('Destaque para você'), findsOneWidget);
    expect(app.api.requests, hasLength(before));
  });
}

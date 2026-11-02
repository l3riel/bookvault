import 'package:bookvault/data/repositories/books_exception.dart';
import 'package:bookvault/data/repositories/books_repository.dart';
import 'package:bookvault/services/books_api_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_dio.dart';
import '../../helpers/google_books_fixtures.dart';

void main() {
  late FakeHttpAdapter adapter;
  late BooksRepository repository;

  setUp(() {
    adapter = FakeHttpAdapter((_) => jsonBody(searchJson([])));
    repository = BooksRepository(api: BooksApiService(fakeDio(adapter)));
  });

  Matcher throwsBooksError(BooksErrorType type) => throwsA(
    isA<BooksException>().having((error) => error.type, 'type', type),
  );

  group('search', () {
    test('converte os volumes encontrados em Book', () async {
      adapter.handler = (_) => jsonBody(
        searchJson([
          volumeJson(),
          volumeJson(id: 'hobbit', title: 'O Hobbit', authors: ['Tolkien']),
        ]),
      );

      final books = await repository.search('duna');

      expect(books, hasLength(2));
      expect(books.first.id, 'zyTCAlFPjgYC');
      expect(books.first.title, 'Duna');
      expect(books.first.authors, ['Frank Herbert']);
      expect(books.first.thumbnailUrl, 'https://books.google.com/capa.jpg');
      expect(books.last.authors, ['Tolkien']);
    });

    test('sem resultados devolve lista vazia', () async {
      expect(await repository.search('xyzxyz'), isEmpty);
    });

    test('termo vazio não chama a API', () async {
      expect(await repository.search(''), isEmpty);
      expect(await repository.search('   '), isEmpty);
      expect(adapter.requests, isEmpty);
    });

    test('envia o termo sem espaços nas pontas', () async {
      await repository.search('  duna  ');

      expect(adapter.requests.single.queryParameters['q'], 'duna');
    });

    test('descarta volume sem título e mantém os demais', () async {
      adapter.handler = (_) =>
          jsonBody(searchJson([volumeJson(title: null), volumeJson(id: 'ok')]));

      final books = await repository.search('duna');

      expect(books.map((b) => b.id), ['ok']);
    });
  });

  group('getById', () {
    test('devolve o livro com editora, data e páginas', () async {
      adapter.handler = (_) => jsonBody(
        volumeJson(publisher: 'Aleph', publishedDate: '2017', pageCount: 680),
      );

      final book = await repository.getById('zyTCAlFPjgYC');

      expect(book.publisher, 'Aleph');
      expect(book.publishedDate, '2017');
      expect(book.pageCount, 680);
    });

    test('HTTP 404 vira notFound', () async {
      adapter.handler = (_) => jsonBody({'error': 'not found'}, status: 404);

      await expectLater(
        repository.getById('nada'),
        throwsBooksError(BooksErrorType.notFound),
      );
    });

    test('volume sem título vira notFound', () async {
      adapter.handler = (_) => jsonBody(volumeJson(title: null));

      await expectLater(
        repository.getById('x'),
        throwsBooksError(BooksErrorType.notFound),
      );
    });
  });

  group('erros', () {
    final cases = {
      DioExceptionType.connectionError: BooksErrorType.noConnection,
      DioExceptionType.unknown: BooksErrorType.noConnection,
      DioExceptionType.connectionTimeout: BooksErrorType.timeout,
      DioExceptionType.receiveTimeout: BooksErrorType.timeout,
    };
    cases.forEach((dioType, expected) {
      test('${dioType.name} vira ${expected.name}', () async {
        adapter.handler = failWith(dioType);

        await expectLater(
          repository.search('duna'),
          throwsBooksError(expected),
        );
      });
    });

    test('HTTP 500 vira server', () async {
      adapter.handler = (_) => jsonBody({'error': 'boom'}, status: 500);

      await expectLater(
        repository.search('duna'),
        throwsBooksError(BooksErrorType.server),
      );
    });

    test('resposta que não é objeto JSON vira server', () async {
      adapter.handler = (_) => jsonBody(['lista', 'inesperada']);

      await expectLater(
        repository.search('duna'),
        throwsBooksError(BooksErrorType.server),
      );
    });

    test('cada tipo de erro tem mensagem em pt-BR', () {
      expect(
        const BooksException(BooksErrorType.noConnection).message,
        startsWith('Sem conexão'),
      );
      for (final type in BooksErrorType.values) {
        expect(type.message, isNotEmpty);
      }
    });
  });
}

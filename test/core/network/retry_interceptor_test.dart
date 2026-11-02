import 'package:bookvault/data/repositories/books_exception.dart';
import 'package:bookvault/data/repositories/books_repository.dart';
import 'package:bookvault/services/books_api_service.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_dio.dart';
import '../../helpers/google_books_fixtures.dart';

void main() {
  BooksRepository repositoryWith(FakeHttpAdapter adapter) =>
      BooksRepository(api: BooksApiService(fakeDio(adapter)));

  test('503 seguido de 200 dá certo sem erro', () async {
    var calls = 0;
    final adapter = FakeHttpAdapter((options) {
      calls++;
      return calls == 1
          ? jsonBody({'error': 'indisponível'}, status: 503)
          : jsonBody(searchJson([volumeJson()]));
    });

    final books = await repositoryWith(adapter).search('duna');

    expect(books.single.title, 'Duna');
    expect(adapter.requests, hasLength(2));
    expect(adapter.requests.last.queryParameters['q'], 'duna');
  });

  test('desiste depois de 2 novas tentativas', () async {
    final adapter = FakeHttpAdapter(
      (options) => jsonBody({'error': 'indisponível'}, status: 503),
    );

    await expectLater(
      repositoryWith(adapter).search('duna'),
      throwsA(
        isA<BooksException>().having(
          (e) => e.type,
          'type',
          BooksErrorType.server,
        ),
      ),
    );
    expect(adapter.requests, hasLength(3));
  });

  test('404 e 429 não são repetidos', () async {
    for (final status in [404, 429]) {
      final adapter = FakeHttpAdapter(
        (options) => jsonBody({'error': 'x'}, status: status),
      );

      await expectLater(
        repositoryWith(adapter).getById('abc'),
        throwsA(isA<BooksException>()),
      );
      expect(adapter.requests, hasLength(1), reason: 'status $status');
    }
  });
}

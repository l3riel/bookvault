import 'package:bookvault/services/books_api_service.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_dio.dart';
import '../helpers/google_books_fixtures.dart';

void main() {
  test('busca com os parâmetros da spec', () async {
    final adapter = FakeHttpAdapter((_) => jsonBody(searchJson([])));
    final service = BooksApiService(fakeDio(adapter));

    await service.searchVolumes('duna');

    final request = adapter.requests.single;
    expect(request.uri.path, '/books/v1/volumes');
    expect(request.uri.host, 'www.googleapis.com');
    expect(request.queryParameters, {
      'q': 'duna',
      'printType': 'books',
      'langRestrict': 'pt',
      'maxResults': 20,
    });
  });

  test('devolve um DTO por item da busca', () async {
    final adapter = FakeHttpAdapter(
      (_) => jsonBody(
        searchJson([volumeJson(), volumeJson(id: 'hobbit', title: 'O Hobbit')]),
      ),
    );

    final volumes = await BooksApiService(fakeDio(adapter)).searchVolumes('x');

    expect(volumes.map((v) => v.id), ['zyTCAlFPjgYC', 'hobbit']);
  });

  test('consulta detalhes em volumes/<id>', () async {
    final adapter = FakeHttpAdapter((_) => jsonBody(volumeJson()));

    final volume = await BooksApiService(fakeDio(adapter))
        .getVolume('zyTCAlFPjgYC');

    expect(adapter.requests.single.uri.path, '/books/v1/volumes/zyTCAlFPjgYC');
    expect(volume.title, 'Duna');
  });
}

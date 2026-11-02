import 'package:bookvault/core/network/dio_client.dart';
import 'package:bookvault/services/books_api_service.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_dio.dart';
import '../../helpers/google_books_fixtures.dart';

void main() {
  FakeHttpAdapter adapterFor() =>
      FakeHttpAdapter((options) => jsonBody(searchJson([volumeJson()])));

  test('com chave, toda chamada leva o parâmetro key', () async {
    final adapter = adapterFor();
    final dio = createDioClient(apiKey: 'chave-de-teste')
      ..httpClientAdapter = adapter;

    await BooksApiService(dio).searchVolumes('duna');

    final params = adapter.requests.single.queryParameters;
    expect(params['key'], 'chave-de-teste');
    expect(params['q'], 'duna');
  });

  test('sem chave, a chamada sai sem o parâmetro key', () async {
    final adapter = adapterFor();
    final dio = createDioClient(apiKey: '')..httpClientAdapter = adapter;

    await BooksApiService(dio).getVolume('abc');

    expect(adapter.requests.single.queryParameters, isNot(contains('key')));
  });
}

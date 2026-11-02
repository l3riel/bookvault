import 'dart:async';
import 'dart:typed_data';

import 'package:bookvault/data/repositories/books_repository.dart';
import 'package:bookvault/services/books_api_service.dart';
import 'package:bookvault/stores/explore_store.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_dio.dart';
import '../helpers/google_books_fixtures.dart';

void main() {
  late FakeHttpAdapter adapter;
  late ExploreStore store;

  setUp(() {
    adapter = FakeHttpAdapter(
      (options) => jsonBody(searchJson([volumeJson()])),
    );
    store = ExploreStore(
      BooksRepository(api: BooksApiService(fakeDio(adapter))),
      suggestions: const [],
    );
  });

  test('começa no estado inicial', () {
    expect(store.status, ExploreStatus.initial);
    expect(store.results, isEmpty);
  });

  test('busca com sucesso preenche os resultados', () async {
    await store.search('  duna ');

    expect(store.status, ExploreStatus.success);
    expect(store.searchedTerm, 'duna');
    expect(store.resultCount, 1);
    expect(store.results.single.title, 'Duna');
    expect(adapter.requests.single.queryParameters['q'], 'duna');
  });

  test('termo em branco não chama a API', () async {
    await store.search('   ');

    expect(store.status, ExploreStatus.initial);
    expect(adapter.requests, isEmpty);
  });

  test('busca sem resultados fica vazia', () async {
    adapter.handler = (options) => jsonBody(searchJson([]));

    await store.search('xyzzy');

    expect(store.status, ExploreStatus.empty);
    expect(store.searchedTerm, 'xyzzy');
  });

  test('falha de rede mostra mensagem e retry repete a busca', () async {
    adapter.handler = failWith(DioExceptionType.connectionError);

    await store.search('duna');
    expect(store.status, ExploreStatus.error);
    expect(store.errorMessage, contains('Sem conexão'));

    adapter.handler = (options) => jsonBody(searchJson([volumeJson()]));
    await store.retry();

    expect(store.status, ExploreStatus.success);
    expect(adapter.requests, hasLength(2));
    expect(adapter.requests.last.queryParameters['q'], 'duna');
  });

  test('resposta atrasada de busca antiga é ignorada', () async {
    final gate = Completer<void>();
    final gated = _GatedAdapter((options) async {
      final term = options.queryParameters['q'];
      if (term == 'antigo') await gate.future;
      return jsonBody(searchJson([volumeJson(id: '$term', title: '$term')]));
    });
    store = ExploreStore(
      BooksRepository(api: BooksApiService(fakeDio(gated))),
      suggestions: const [],
    );

    final old = store.search('antigo');
    await store.search('novo');
    gate.complete();
    await old;

    expect(store.results.single.title, 'novo');
    expect(store.searchedTerm, 'novo');
  });

  test('clear volta ao estado inicial', () async {
    await store.search('duna');
    store.clear();

    expect(store.status, ExploreStatus.initial);
    expect(store.results, isEmpty);
    expect(store.searchedTerm, isEmpty);
  });
}

/// Adaptador com resposta assíncrona, para simular requisições lentas.
class _GatedAdapter extends FakeHttpAdapter {
  _GatedAdapter(this.respond) : super(_unused);

  final Future<ResponseBody> Function(RequestOptions options) respond;

  static ResponseBody _unused(RequestOptions options) =>
      throw UnimplementedError();

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) => respond(options);
}

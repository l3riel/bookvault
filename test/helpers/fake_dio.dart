import 'dart:convert';
import 'dart:typed_data';

import 'package:bookvault/core/network/dio_client.dart';
import 'package:dio/dio.dart';

/// Resposta simulada: devolve um [ResponseBody] ou lança um [DioException].
typedef FakeHandler = ResponseBody Function(RequestOptions options);

/// Adaptador HTTP falso: nenhum teste toca a rede de verdade.
class FakeHttpAdapter implements HttpClientAdapter {
  FakeHttpAdapter(this.handler);

  FakeHandler handler;
  final List<RequestOptions> requests = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    return handler(options);
  }

  @override
  void close({bool force = false}) {}
}

/// Dio igual ao do app (com as novas tentativas, sem pausa), mas respondendo
/// pelo [adapter].
Dio fakeDio(FakeHttpAdapter adapter) =>
    createDioClient(retryDelay: Duration.zero)..httpClientAdapter = adapter;

ResponseBody jsonBody(Object body, {int status = 200}) {
  return ResponseBody.fromString(
    jsonEncode(body),
    status,
    headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    },
  );
}

FakeHandler failWith(DioExceptionType type) =>
    (options) => throw DioException(requestOptions: options, type: type);

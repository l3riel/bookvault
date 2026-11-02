import 'package:dio/dio.dart';

/// Repete chamadas que falharam por instabilidade do servidor (500, 502,
/// 503, 504). A Google Books devolve 503 intermitente (S08, decisão 4).
class RetryInterceptor extends Interceptor {
  RetryInterceptor({
    required this.dio,
    this.maxRetries = 2,
    this.baseDelay = const Duration(milliseconds: 600),
  });

  final Dio dio;
  final int maxRetries;

  /// Pausa antes da 1ª nova tentativa; a n-ésima espera `baseDelay * n`.
  final Duration baseDelay;

  static const Set<int> retryableStatus = {500, 502, 503, 504};
  static const String _attemptKey = 'retry_attempt';

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final options = err.requestOptions;
    final attempt = (options.extra[_attemptKey] as int?) ?? 0;
    final status = err.response?.statusCode;
    final retryable =
        err.type == DioExceptionType.badResponse &&
        retryableStatus.contains(status);
    if (!retryable || attempt >= maxRetries) {
      handler.next(err);
      return;
    }
    await Future<void>.delayed(baseDelay * (attempt + 1));
    options.extra[_attemptKey] = attempt + 1;
    try {
      handler.resolve(await dio.fetch<dynamic>(options));
    } on DioException catch (error) {
      handler.next(error);
    }
  }
}

import 'package:dio/dio.dart';

/// URL base da Google Books API (ADR 0004).
const String googleBooksBaseUrl = 'https://www.googleapis.com/books/v1/';

/// Cria o cliente HTTP usado pelos serviços de livros.
Dio createDioClient() {
  return Dio(
    BaseOptions(
      baseUrl: googleBooksBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      responseType: ResponseType.json,
    ),
  );
}

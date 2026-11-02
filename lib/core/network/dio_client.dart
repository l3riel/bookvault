import 'package:dio/dio.dart';

/// URL base da Google Books API (ADR 0004).
const String googleBooksBaseUrl = 'https://www.googleapis.com/books/v1/';

/// Chave da Google Books, injetada na compilação:
/// `flutter run --dart-define-from-file=config/api_keys.json`.
/// Nunca escreva a chave no código; `config/` fica fora do git.
const String booksApiKey = String.fromEnvironment('BOOKS_API_KEY');

/// Cria o cliente HTTP usado pelos serviços de livros.
///
/// Com [apiKey] vazia, as chamadas saem sem chave (cota anônima, bem menor).
Dio createDioClient({String apiKey = booksApiKey}) {
  return Dio(
    BaseOptions(
      baseUrl: googleBooksBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      responseType: ResponseType.json,
      queryParameters: {if (apiKey.isNotEmpty) 'key': apiKey},
    ),
  );
}

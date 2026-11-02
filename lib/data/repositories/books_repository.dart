import 'package:dio/dio.dart';

import '../../models/book.dart';
import '../../services/books_api_service.dart';
import 'books_exception.dart';

/// Livros da Google Books já convertidos para [Book].
///
/// Qualquer falha vira [BooksException]; o Dio e os DTOs não saem daqui.
class BooksRepository {
  const BooksRepository({required this._api});

  final BooksApiService _api;

  /// Busca por título ou autor. Termo vazio devolve lista vazia sem chamar a
  /// API; volumes sem id ou título são descartados.
  Future<List<Book>> search(String query) async {
    final term = query.trim();
    if (term.isEmpty) return const [];
    final volumes = await _guard(() => _api.searchVolumes(term));
    return [for (final volume in volumes) ?volume.toBook()];
  }

  /// Detalhes de um livro pelo `volumeId`.
  Future<Book> getById(String volumeId) async {
    final volume = await _guard(() => _api.getVolume(volumeId));
    final book = volume.toBook();
    if (book == null) throw const BooksException(BooksErrorType.notFound);
    return book;
  }

  Future<T> _guard<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on DioException catch (error) {
      throw BooksException(_typeOf(error));
    } on FormatException {
      throw const BooksException(BooksErrorType.server);
    }
  }

  static BooksErrorType _typeOf(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return BooksErrorType.timeout;
      case DioExceptionType.connectionError:
        return BooksErrorType.noConnection;
      case DioExceptionType.badResponse:
        return error.response?.statusCode == 404
            ? BooksErrorType.notFound
            : BooksErrorType.server;
      case DioExceptionType.unknown:
        // Sem resposta nenhuma: em geral a rede caiu antes de responder.
        return error.response == null
            ? BooksErrorType.noConnection
            : BooksErrorType.server;
      case DioExceptionType.badCertificate:
      case DioExceptionType.cancel:
        return BooksErrorType.server;
    }
  }
}

import 'package:dio/dio.dart';

import '../data/dtos/google_books_volume_dto.dart';

/// Chamadas HTTP à Google Books API. Devolve DTOs e deixa os erros do Dio
/// subirem: quem traduz é o `BooksRepository`.
class BooksApiService {
  const BooksApiService(this._dio);

  /// Número de resultados por busca (decisão da S04).
  static const int maxResults = 20;

  final Dio _dio;

  /// Busca por título ou autor, só livros em português.
  Future<List<GoogleBooksVolumeDto>> searchVolumes(String query) async {
    final response = await _dio.get<Object?>(
      'volumes',
      queryParameters: {
        'q': query,
        'printType': 'books',
        'langRestrict': 'pt',
        'maxResults': maxResults,
      },
    );
    final items = _asMap(response.data)['items'];
    if (items is! List) return const [];
    return [
      for (final item in items)
        if (item is Map<String, Object?>) GoogleBooksVolumeDto.fromJson(item),
    ];
  }

  Future<GoogleBooksVolumeDto> getVolume(String volumeId) async {
    final response = await _dio.get<Object?>(
      'volumes/${Uri.encodeComponent(volumeId)}',
    );
    return GoogleBooksVolumeDto.fromJson(_asMap(response.data));
  }

  static Map<String, Object?> _asMap(Object? data) {
    if (data is Map<String, Object?>) return data;
    throw const FormatException('Resposta inesperada da Google Books API.');
  }
}

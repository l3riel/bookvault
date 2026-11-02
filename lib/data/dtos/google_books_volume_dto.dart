import '../../models/book.dart';

/// Volume no formato da Google Books API (`items[]` da busca ou o retorno de
/// `volumes/<id>`). Não sai da camada `data`: use [toBook].
class GoogleBooksVolumeDto {
  const GoogleBooksVolumeDto({
    this.id,
    this.title,
    this.authors = const [],
    this.description,
    this.thumbnail,
    this.smallThumbnail,
    this.publisher,
    this.publishedDate,
    this.pageCount,
    this.categories = const [],
  });

  /// Leitura tolerante: campos ausentes ou com tipo errado viram `null`.
  factory GoogleBooksVolumeDto.fromJson(Map<String, Object?> json) {
    final info = _map(json['volumeInfo']);
    final images = _map(info['imageLinks']);
    return GoogleBooksVolumeDto(
      id: _string(json['id']),
      title: _string(info['title']),
      authors: _strings(info['authors']),
      description: _string(info['description']),
      thumbnail: _string(images['thumbnail']),
      smallThumbnail: _string(images['smallThumbnail']),
      publisher: _string(info['publisher']),
      publishedDate: _string(info['publishedDate']),
      pageCount: info['pageCount'] is int ? info['pageCount']! as int : null,
      categories: _strings(info['categories']),
    );
  }

  final String? id;
  final String? title;
  final List<String> authors;
  final String? description;
  final String? thumbnail;
  final String? smallThumbnail;
  final String? publisher;
  final String? publishedDate;
  final int? pageCount;
  final List<String> categories;

  /// Converte para o modelo interno, ou `null` se faltar id ou título.
  Book? toBook() {
    final id = this.id;
    final title = this.title?.trim();
    if (id == null || id.isEmpty || title == null || title.isEmpty) {
      return null;
    }
    return Book(
      id: id,
      title: title,
      authors: authors,
      description: _plainText(description),
      thumbnailUrl: _secure(thumbnail ?? smallThumbnail),
      publisher: publisher,
      publishedDate: publishedDate,
      pageCount: pageCount,
      categories: categories,
    );
  }

  static Map<String, Object?> _map(Object? value) =>
      value is Map<String, Object?> ? value : const {};

  static String? _string(Object? value) => value is String ? value : null;

  static List<String> _strings(Object? value) =>
      value is List ? List.unmodifiable(value.whereType<String>()) : const [];

  /// O Android bloqueia HTTP sem TLS: as capas vêm às vezes com `http://`.
  static String? _secure(String? url) =>
      url?.replaceFirst(RegExp('^http://'), 'https://');

  /// Remove o HTML simples que a API manda em algumas descrições.
  static String? _plainText(String? html) {
    if (html == null) return null;
    final text = html
        .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n')
        .replaceAll(RegExp(r'</p>', caseSensitive: false), '\n')
        .replaceAll(RegExp('<[^>]+>'), '')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&amp;', '&')
        .replaceAll(RegExp(r'\n{3,}'), '\n\n')
        .trim();
    return text.isEmpty ? null : text;
  }
}

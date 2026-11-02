import 'model_helpers.dart';

/// Livro como o app o entende, independente do formato da Google Books.
class Book {
  const Book({
    required this.id,
    required this.title,
    this.authors = const [],
    this.description,
    this.thumbnailUrl,
    this.publisher,
    this.publishedDate,
    this.pageCount,
    this.categories = const [],
  });

  factory Book.fromJson(Json json) {
    return Book(
      id: readRequiredString(json, 'id'),
      title: readRequiredString(json, 'title'),
      authors: readStringList(json, 'authors'),
      description: readOptionalString(json, 'description'),
      thumbnailUrl: readOptionalString(json, 'thumbnailUrl'),
      publisher: readOptionalString(json, 'publisher'),
      publishedDate: readOptionalString(json, 'publishedDate'),
      pageCount: readOptionalInt(json, 'pageCount'),
      categories: readStringList(json, 'categories'),
    );
  }

  /// `volumeId` do Google Books.
  final String id;
  final String title;
  final List<String> authors;
  final String? description;
  final String? thumbnailUrl;
  final String? publisher;

  /// Data como vem da API: '2004', '2004-05' ou '2004-05-12'.
  final String? publishedDate;
  final int? pageCount;
  final List<String> categories;

  Json toJson() => {
    'id': id,
    'title': title,
    'authors': authors,
    'description': description,
    'thumbnailUrl': thumbnailUrl,
    'publisher': publisher,
    'publishedDate': publishedDate,
    'pageCount': pageCount,
    'categories': categories,
  };

  @override
  bool operator ==(Object other) =>
      other is Book &&
      other.id == id &&
      other.title == title &&
      listEquals(other.authors, authors) &&
      other.description == description &&
      other.thumbnailUrl == thumbnailUrl &&
      other.publisher == publisher &&
      other.publishedDate == publishedDate &&
      other.pageCount == pageCount &&
      listEquals(other.categories, categories);

  @override
  int get hashCode => Object.hash(
    id,
    title,
    Object.hashAll(authors),
    description,
    thumbnailUrl,
    publisher,
    publishedDate,
    pageCount,
    Object.hashAll(categories),
  );

  @override
  String toString() => 'Book($id, $title)';
}

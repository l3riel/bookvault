/// Volumes no formato da Google Books API, para os testes.
Map<String, Object?> volumeJson({
  String? id = 'zyTCAlFPjgYC',
  String? title = 'Duna',
  List<String>? authors = const ['Frank Herbert'],
  String? description,
  String? thumbnail = 'http://books.google.com/capa.jpg',
  String? smallThumbnail,
  String? publisher,
  String? publishedDate,
  int? pageCount,
  List<String>? categories,
}) {
  return {
    'id': ?id,
    'volumeInfo': {
      'title': ?title,
      'authors': ?authors,
      'description': ?description,
      'imageLinks': {
        'thumbnail': ?thumbnail,
        'smallThumbnail': ?smallThumbnail,
      },
      'publisher': ?publisher,
      'publishedDate': ?publishedDate,
      'pageCount': ?pageCount,
      'categories': ?categories,
    },
  };
}

Map<String, Object?> searchJson(List<Map<String, Object?>> items) => {
  'kind': 'books#volumes',
  'totalItems': items.length,
  if (items.isNotEmpty) 'items': items,
};

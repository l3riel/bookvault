import 'package:bookvault/data/dtos/google_books_volume_dto.dart';
import 'package:bookvault/models/book.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/google_books_fixtures.dart';

void main() {
  Book? convert(Map<String, Object?> json) =>
      GoogleBooksVolumeDto.fromJson(json).toBook();

  test('converte um volume completo para Book', () {
    final book = convert(
      volumeJson(
        description: 'Um clássico.',
        publisher: 'Aleph',
        publishedDate: '2017-03',
        pageCount: 680,
        categories: ['Fiction'],
      ),
    );

    expect(
      book,
      const Book(
        id: 'zyTCAlFPjgYC',
        title: 'Duna',
        authors: ['Frank Herbert'],
        description: 'Um clássico.',
        thumbnailUrl: 'https://books.google.com/capa.jpg',
        publisher: 'Aleph',
        publishedDate: '2017-03',
        pageCount: 680,
        categories: ['Fiction'],
      ),
    );
  });

  test('campos ausentes viram null sem quebrar', () {
    final book = convert(volumeJson(authors: null, thumbnail: null))!;

    expect(book.authors, isEmpty);
    expect(book.description, isNull);
    expect(book.publisher, isNull);
    expect(book.pageCount, isNull);
    expect(book.thumbnailUrl, isNull);
    expect(book.categories, isEmpty);
  });

  test('sem volumeInfo nenhum, não converte', () {
    expect(convert({'id': 'abc'}), isNull);
  });

  test('sem id ou sem título, não converte', () {
    expect(convert(volumeJson(id: null)), isNull);
    expect(convert(volumeJson(title: null)), isNull);
    expect(convert(volumeJson(title: '   ')), isNull);
  });

  test('capa em http vira https e cai no smallThumbnail', () {
    final semThumbnail = convert(
      volumeJson(
        thumbnail: null,
        smallThumbnail: 'http://books.google.com/pequena.jpg',
      ),
    );

    expect(
      convert(volumeJson())?.thumbnailUrl,
      'https://books.google.com/capa.jpg',
    );
    expect(semThumbnail?.thumbnailUrl, 'https://books.google.com/pequena.jpg');
  });

  test('remove HTML simples da descrição', () {
    final book = convert(
      volumeJson(
        description: '<p>Primeiro <b>parágrafo</b>.</p><p>Linha<br>quebrada &amp; fim</p>',
      ),
    );

    expect(book?.description, 'Primeiro parágrafo.\nLinha\nquebrada & fim');
  });

  test('tipos errados nos campos são ignorados', () {
    final book = convert({
      'id': 'abc',
      'volumeInfo': {'title': 'Ok', 'pageCount': '300', 'authors': 'Fulano'},
    })!;

    expect(book.pageCount, isNull);
    expect(book.authors, isEmpty);
  });
}

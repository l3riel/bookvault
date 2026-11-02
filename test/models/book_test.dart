import 'package:bookvault/models/book.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const fullBook = Book(
    id: 'zyTCAlFPjgYC',
    title: 'Duna',
    authors: ['Frank Herbert'],
    description: 'Um clássico da ficção científica.',
    thumbnailUrl: 'https://books.google.com/capa.jpg',
    publisher: 'Aleph',
    publishedDate: '2017-03',
    pageCount: 680,
    categories: ['Fiction'],
  );

  test('toJson e fromJson preservam um livro completo', () {
    expect(Book.fromJson(fullBook.toJson()), fullBook);
  });

  test('JSON só com id e título deixa opcionais nulos e listas vazias', () {
    final book = Book.fromJson({'id': 'abc', 'title': 'Sem dados'});

    expect(book.id, 'abc');
    expect(book.title, 'Sem dados');
    expect(book.authors, isEmpty);
    expect(book.categories, isEmpty);
    expect(book.description, isNull);
    expect(book.thumbnailUrl, isNull);
    expect(book.publisher, isNull);
    expect(book.publishedDate, isNull);
    expect(book.pageCount, isNull);
  });

  test('lança FormatException sem id ou sem título', () {
    expect(() => Book.fromJson({'title': 'Sem id'}), throwsFormatException);
    expect(() => Book.fromJson({'id': 'abc'}), throwsFormatException);
    expect(
      () => Book.fromJson({'id': '', 'title': 'Id vazio'}),
      throwsFormatException,
    );
  });

  test('ignora tipos errados em campos opcionais', () {
    final book = Book.fromJson({
      'id': 'abc',
      'title': 'Dados ruins',
      'authors': 'não é lista',
      'pageCount': '300',
    });

    expect(book.authors, isEmpty);
    expect(book.pageCount, isNull);
  });

  test('livros com os mesmos dados são iguais', () {
    final copy = Book.fromJson(fullBook.toJson());

    expect(copy, fullBook);
    expect(copy.hashCode, fullBook.hashCode);
  });
}

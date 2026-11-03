import 'package:bookvault/models/book.dart';
import 'package:bookvault/models/reading_status.dart';
import 'package:bookvault/models/user_book.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const book = Book(
    id: 'zyTCAlFPjgYC',
    title: 'Duna',
    authors: ['Frank Herbert'],
    thumbnailUrl: 'https://books.google.com/capa.jpg',
  );
  final userBook = UserBook(
    book: book,
    status: ReadingStatus.wantToRead,
    addedAt: DateTime.utc(2026, 11, 2, 18, 30),
  );

  test('toJson e fromJson preservam snapshot, status e data', () {
    final restored = UserBook.fromJson(userBook.toJson());

    expect(restored, userBook);
    expect(restored.book, book);
    expect(restored.status, ReadingStatus.wantToRead);
    expect(restored.addedAt, DateTime.utc(2026, 11, 2, 18, 30));
  });

  test('grava a data em ISO 8601', () {
    expect(userBook.toJson()['addedAt'], '2026-11-02T18:30:00.000Z');
  });

  test('copyWith muda só o status', () {
    final reading = userBook.copyWith(status: ReadingStatus.reading);

    expect(reading.status, ReadingStatus.reading);
    expect(reading.book, userBook.book);
    expect(reading.addedAt, userBook.addedAt);
  });

  test('expõe o id do livro', () {
    expect(userBook.id, 'zyTCAlFPjgYC');
  });

  test('lança FormatException com status desconhecido', () {
    final json = userBook.toJson()..['status'] = 'abandoned';

    expect(() => UserBook.fromJson(json), throwsFormatException);
  });

  test('lança FormatException sem livro ou com data inválida', () {
    final semLivro = userBook.toJson()..remove('book');
    final dataRuim = userBook.toJson()..['addedAt'] = 'ontem';

    expect(() => UserBook.fromJson(semLivro), throwsFormatException);
    expect(() => UserBook.fromJson(dataRuim), throwsFormatException);
  });

  test('copyWith sem status mantém o status atual', () {
    final later = userBook.copyWith(addedAt: DateTime.utc(2027));

    expect(later.status, ReadingStatus.wantToRead);
    expect(later.addedAt, DateTime.utc(2027));
  });

  test('itens com os mesmos dados são iguais e têm o mesmo hash', () {
    final copy = UserBook.fromJson(userBook.toJson());

    expect(copy.hashCode, userBook.hashCode);
    expect(userBook.copyWith(status: ReadingStatus.completed), isNot(userBook));
  });

  test('toString mostra id e status', () {
    expect(userBook.toString(), 'UserBook(zyTCAlFPjgYC, wantToRead)');
  });
}

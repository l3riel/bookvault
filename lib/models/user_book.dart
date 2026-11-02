import 'book.dart';
import 'model_helpers.dart';
import 'reading_status.dart';

/// Livro salvo na biblioteca: snapshot do [Book], status e data de inclusão.
class UserBook {
  const UserBook({
    required this.book,
    required this.status,
    required this.addedAt,
  });

  factory UserBook.fromJson(Json json) {
    final addedAt = DateTime.tryParse(readRequiredString(json, 'addedAt'));
    if (addedAt == null) {
      throw FormatException('Data de inclusão inválida.', json);
    }
    return UserBook(
      book: Book.fromJson(readRequiredMap(json, 'book')),
      status: ReadingStatus.fromJson(json['status']),
      addedAt: addedAt,
    );
  }

  final Book book;
  final ReadingStatus status;
  final DateTime addedAt;

  /// Atalho para o identificador do livro (`volumeId`).
  String get id => book.id;

  UserBook copyWith({Book? book, ReadingStatus? status, DateTime? addedAt}) {
    return UserBook(
      book: book ?? this.book,
      status: status ?? this.status,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  Json toJson() => {
    'book': book.toJson(),
    'status': status.toJson(),
    'addedAt': addedAt.toIso8601String(),
  };

  @override
  bool operator ==(Object other) =>
      other is UserBook &&
      other.book == book &&
      other.status == status &&
      other.addedAt == addedAt;

  @override
  int get hashCode => Object.hash(book, status, addedAt);

  @override
  String toString() => 'UserBook(${book.id}, ${status.name})';
}

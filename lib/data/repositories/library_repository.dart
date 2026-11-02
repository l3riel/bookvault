import '../../core/storage/local_storage.dart';
import '../../models/book.dart';
import '../../models/reading_status.dart';
import '../../models/user_book.dart';

/// Biblioteca pessoal guardada no aparelho.
///
/// Garante um único registro por livro (`book.id`). Funciona offline.
class LibraryRepository {
  LibraryRepository({required this._storage, DateTime Function()? now})
    : _now = now ?? DateTime.now;

  static const String storageKey = 'library.books';

  final LocalStorage _storage;
  final DateTime Function() _now;

  /// Livros salvos, do mais recente para o mais antigo.
  List<UserBook> getAll() {
    final books = _readAll()..sort((a, b) => b.addedAt.compareTo(a.addedAt));
    return List.unmodifiable(books);
  }

  UserBook? findById(String bookId) {
    for (final userBook in _readAll()) {
      if (userBook.id == bookId) return userBook;
    }
    return null;
  }

  bool contains(String bookId) => findById(bookId) != null;

  /// Lança [StateError] se o livro já estiver na biblioteca.
  Future<UserBook> add(
    Book book, {
    ReadingStatus status = ReadingStatus.wantToRead,
  }) async {
    final books = _readAll();
    if (books.any((userBook) => userBook.id == book.id)) {
      throw StateError('O livro ${book.id} já está na biblioteca.');
    }
    final userBook = UserBook(book: book, status: status, addedAt: _now());
    await _writeAll([...books, userBook]);
    return userBook;
  }

  /// Lança [StateError] se o livro não estiver na biblioteca.
  Future<UserBook> updateStatus(String bookId, ReadingStatus status) async {
    final books = _readAll();
    final index = books.indexWhere((userBook) => userBook.id == bookId);
    if (index == -1) {
      throw StateError('O livro $bookId não está na biblioteca.');
    }
    final updated = books[index].copyWith(status: status);
    books[index] = updated;
    await _writeAll(books);
    return updated;
  }

  /// Remove o livro; não faz nada se ele não estiver na biblioteca.
  Future<void> remove(String bookId) async {
    final books = _readAll();
    final remaining = books.where((userBook) => userBook.id != bookId).toList();
    if (remaining.length != books.length) await _writeAll(remaining);
  }

  /// Lê a lista salva ignorando itens corrompidos (decisão da S03).
  List<UserBook> _readAll() {
    final raw = _storage.readJson(storageKey);
    if (raw is! List) return [];
    final books = <UserBook>[];
    for (final item in raw) {
      if (item is! Map<String, Object?>) continue;
      try {
        books.add(UserBook.fromJson(item));
      } on FormatException {
        continue;
      }
    }
    return books;
  }

  Future<void> _writeAll(List<UserBook> books) {
    return _storage.writeJson(
      storageKey,
      books.map((userBook) => userBook.toJson()).toList(),
    );
  }
}

import 'package:mobx/mobx.dart';

import '../data/repositories/books_exception.dart';
import '../data/repositories/books_repository.dart';
import '../models/book.dart';
import '../models/reading_status.dart';
import '../models/user_book.dart';
import 'library_store.dart';

part 'book_details_store.g.dart';

/// Situação do carregamento dos Detalhes.
enum BookDetailsStatus { loading, loaded, error }

/// Estado da tela de Detalhes do livro (S07).
///
/// Adicionar, mudar status e remover passam pela [LibraryStore] única, então
/// a aba Biblioteca atualiza na hora.
class BookDetailsStore = _BookDetailsStore with _$BookDetailsStore;

abstract class _BookDetailsStore with Store {
  _BookDetailsStore({
    required this.bookId,
    required this._books,
    required this._library,
    required this._initialBook,
  });

  final String bookId;
  final BooksRepository _books;
  final LibraryStore _library;

  /// Livro já carregado por quem abriu a tela (ex.: resultado da busca).
  final Book? _initialBook;

  @observable
  BookDetailsStatus status = BookDetailsStatus.loading;

  @observable
  Book? book;

  @observable
  String? errorMessage;

  /// Gravando na biblioteca (evita toque duplo nos botões).
  @observable
  bool isSaving = false;

  /// O livro como está salvo na biblioteca, ou `null` se não estiver.
  @computed
  UserBook? get savedBook => _library.savedBook(bookId);

  @computed
  bool get isSaved => savedBook != null;

  /// Usa, nesta ordem: o livro recebido, o salvo no aparelho (funciona
  /// offline) e, por fim, a Google Books.
  @action
  Future<void> load() async {
    final known = _initialBook ?? savedBook?.book;
    if (known != null) {
      book = known;
      status = BookDetailsStatus.loaded;
      return;
    }
    status = BookDetailsStatus.loading;
    errorMessage = null;
    try {
      final fetched = await _books.getById(bookId);
      _loaded(fetched);
    } on BooksException catch (error) {
      _failed(error.message);
    }
  }

  @action
  Future<void> add() => _saving(() => _library.add(book!));

  @action
  Future<void> changeStatus(ReadingStatus status) =>
      _saving(() => _library.changeStatus(bookId, status));

  @action
  Future<void> remove() => _saving(() => _library.remove(bookId));

  @action
  void _loaded(Book value) {
    book = value;
    status = BookDetailsStatus.loaded;
  }

  @action
  void _failed(String message) {
    errorMessage = message;
    status = BookDetailsStatus.error;
  }

  Future<void> _saving(Future<void> Function() change) async {
    if (isSaving || book == null) return;
    _setSaving(true);
    try {
      await change();
    } finally {
      _setSaving(false);
    }
  }

  @action
  void _setSaving(bool value) => isSaving = value;
}

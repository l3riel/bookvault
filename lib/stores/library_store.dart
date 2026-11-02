import 'package:mobx/mobx.dart';

import '../data/repositories/library_repository.dart';
import '../models/reading_status.dart';
import '../models/user_book.dart';

part 'library_store.g.dart';

/// Estado da biblioteca pessoal (S06). Uma instância só para o app inteiro.
class LibraryStore = _LibraryStore with _$LibraryStore;

abstract class _LibraryStore with Store {
  _LibraryStore(this._repository);

  final LibraryRepository _repository;

  /// Livros salvos, do mais recente para o mais antigo.
  final ObservableList<UserBook> books = ObservableList<UserBook>();

  /// Filtro ativo; `null` é "Todos".
  @observable
  ReadingStatus? filter;

  @computed
  int get total => books.length;

  @computed
  Map<ReadingStatus, int> get countByStatus => {
    for (final status in ReadingStatus.values)
      status: books.where((book) => book.status == status).length,
  };

  /// Quantos livros o filtro ativo destaca.
  @computed
  int get filteredCount => filter == null ? total : countByStatus[filter]!;

  /// Se o livro fica em destaque com o filtro ativo (os outros ficam apagados).
  bool isHighlighted(UserBook book) => filter == null || book.status == filter;

  @action
  void load() {
    books
      ..clear()
      ..addAll(_repository.getAll());
  }

  @action
  void setFilter(ReadingStatus? status) => filter = status;

  @action
  Future<void> changeStatus(String bookId, ReadingStatus status) async {
    final updated = await _repository.updateStatus(bookId, status);
    final index = books.indexWhere((book) => book.id == bookId);
    if (index != -1) books[index] = updated;
  }

  @action
  Future<void> remove(String bookId) async {
    await _repository.remove(bookId);
    books.removeWhere((book) => book.id == bookId);
  }
}

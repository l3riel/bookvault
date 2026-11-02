import 'package:mobx/mobx.dart';

import '../data/repositories/books_exception.dart';
import '../data/repositories/books_repository.dart';
import '../models/book.dart';
import '../models/genre.dart';

part 'explore_store.g.dart';

/// Situação da tela Explorar.
enum ExploreStatus { initial, loading, success, empty, error }

/// Estado da busca do Explorar (S07).
class ExploreStore = _ExploreStore with _$ExploreStore;

abstract class _ExploreStore with Store {
  _ExploreStore(this._repository, {required this.suggestions});

  final BooksRepository _repository;

  /// Gêneros do onboarding, oferecidos como atalho antes da primeira busca.
  final List<Genre> suggestions;

  /// Cada busca ganha um número; respostas de buscas antigas são ignoradas.
  int _requestId = 0;

  @observable
  ExploreStatus status = ExploreStatus.initial;

  /// Termo da última busca feita (mostrado em "Nada encontrado").
  @observable
  String searchedTerm = '';

  @observable
  List<Book> results = const [];

  @observable
  String? errorMessage;

  @computed
  int get resultCount => results.length;

  /// Busca [query]. Termo em branco não faz nada.
  @action
  Future<void> search(String query) async {
    final term = query.trim();
    if (term.isEmpty) return;
    final requestId = ++_requestId;
    searchedTerm = term;
    status = ExploreStatus.loading;
    errorMessage = null;
    try {
      final books = await _repository.search(term);
      if (requestId != _requestId) return;
      _finish(books);
    } on BooksException catch (error) {
      if (requestId != _requestId) return;
      _fail(error.message);
    }
  }

  /// Repete a última busca (botão "Tentar de novo").
  @action
  Future<void> retry() => search(searchedTerm);

  /// Volta ao estado inicial e descarta buscas em andamento.
  @action
  void clear() {
    _requestId++;
    status = ExploreStatus.initial;
    searchedTerm = '';
    results = const [];
    errorMessage = null;
  }

  @action
  void _finish(List<Book> books) {
    results = books;
    status = books.isEmpty ? ExploreStatus.empty : ExploreStatus.success;
  }

  @action
  void _fail(String message) {
    results = const [];
    errorMessage = message;
    status = ExploreStatus.error;
  }
}

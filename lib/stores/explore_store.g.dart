// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'explore_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ExploreStore on _ExploreStore, Store {
  Computed<int>? _$resultCountComputed;

  @override
  int get resultCount => (_$resultCountComputed ??= Computed<int>(
    () => super.resultCount,
    name: '_ExploreStore.resultCount',
  )).value;

  late final _$statusAtom = Atom(
    name: '_ExploreStore.status',
    context: context,
  );

  @override
  ExploreStatus get status {
    _$statusAtom.reportRead();
    return super.status;
  }

  @override
  set status(ExploreStatus value) {
    _$statusAtom.reportWrite(value, super.status, () {
      super.status = value;
    });
  }

  late final _$searchedTermAtom = Atom(
    name: '_ExploreStore.searchedTerm',
    context: context,
  );

  @override
  String get searchedTerm {
    _$searchedTermAtom.reportRead();
    return super.searchedTerm;
  }

  @override
  set searchedTerm(String value) {
    _$searchedTermAtom.reportWrite(value, super.searchedTerm, () {
      super.searchedTerm = value;
    });
  }

  late final _$resultsAtom = Atom(
    name: '_ExploreStore.results',
    context: context,
  );

  @override
  List<Book> get results {
    _$resultsAtom.reportRead();
    return super.results;
  }

  @override
  set results(List<Book> value) {
    _$resultsAtom.reportWrite(value, super.results, () {
      super.results = value;
    });
  }

  late final _$errorMessageAtom = Atom(
    name: '_ExploreStore.errorMessage',
    context: context,
  );

  @override
  String? get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String? value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$searchAsyncAction = AsyncAction(
    '_ExploreStore.search',
    context: context,
  );

  @override
  Future<void> search(String query) {
    return _$searchAsyncAction.run(() => super.search(query));
  }

  late final _$_ExploreStoreActionController = ActionController(
    name: '_ExploreStore',
    context: context,
  );

  @override
  Future<void> retry() {
    final _$actionInfo = _$_ExploreStoreActionController.startAction(
      name: '_ExploreStore.retry',
    );
    try {
      return super.retry();
    } finally {
      _$_ExploreStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clear() {
    final _$actionInfo = _$_ExploreStoreActionController.startAction(
      name: '_ExploreStore.clear',
    );
    try {
      return super.clear();
    } finally {
      _$_ExploreStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _finish(List<Book> books) {
    final _$actionInfo = _$_ExploreStoreActionController.startAction(
      name: '_ExploreStore._finish',
    );
    try {
      return super._finish(books);
    } finally {
      _$_ExploreStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _fail(String message) {
    final _$actionInfo = _$_ExploreStoreActionController.startAction(
      name: '_ExploreStore._fail',
    );
    try {
      return super._fail(message);
    } finally {
      _$_ExploreStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
status: ${status},
searchedTerm: ${searchedTerm},
results: ${results},
errorMessage: ${errorMessage},
resultCount: ${resultCount}
    ''';
  }
}

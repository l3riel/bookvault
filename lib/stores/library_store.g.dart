// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$LibraryStore on _LibraryStore, Store {
  Computed<int>? _$totalComputed;

  @override
  int get total => (_$totalComputed ??= Computed<int>(
    () => super.total,
    name: '_LibraryStore.total',
  )).value;
  Computed<Map<ReadingStatus, int>>? _$countByStatusComputed;

  @override
  Map<ReadingStatus, int> get countByStatus =>
      (_$countByStatusComputed ??= Computed<Map<ReadingStatus, int>>(
        () => super.countByStatus,
        name: '_LibraryStore.countByStatus',
      )).value;
  Computed<int>? _$filteredCountComputed;

  @override
  int get filteredCount => (_$filteredCountComputed ??= Computed<int>(
    () => super.filteredCount,
    name: '_LibraryStore.filteredCount',
  )).value;

  late final _$filterAtom = Atom(
    name: '_LibraryStore.filter',
    context: context,
  );

  @override
  ReadingStatus? get filter {
    _$filterAtom.reportRead();
    return super.filter;
  }

  @override
  set filter(ReadingStatus? value) {
    _$filterAtom.reportWrite(value, super.filter, () {
      super.filter = value;
    });
  }

  late final _$changeStatusAsyncAction = AsyncAction(
    '_LibraryStore.changeStatus',
    context: context,
  );

  @override
  Future<void> changeStatus(String bookId, ReadingStatus status) {
    return _$changeStatusAsyncAction.run(
      () => super.changeStatus(bookId, status),
    );
  }

  late final _$removeAsyncAction = AsyncAction(
    '_LibraryStore.remove',
    context: context,
  );

  @override
  Future<void> remove(String bookId) {
    return _$removeAsyncAction.run(() => super.remove(bookId));
  }

  late final _$_LibraryStoreActionController = ActionController(
    name: '_LibraryStore',
    context: context,
  );

  @override
  void load() {
    final _$actionInfo = _$_LibraryStoreActionController.startAction(
      name: '_LibraryStore.load',
    );
    try {
      return super.load();
    } finally {
      _$_LibraryStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setFilter(ReadingStatus? status) {
    final _$actionInfo = _$_LibraryStoreActionController.startAction(
      name: '_LibraryStore.setFilter',
    );
    try {
      return super.setFilter(status);
    } finally {
      _$_LibraryStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
filter: ${filter},
total: ${total},
countByStatus: ${countByStatus},
filteredCount: ${filteredCount}
    ''';
  }
}

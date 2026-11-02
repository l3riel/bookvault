// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_details_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$BookDetailsStore on _BookDetailsStore, Store {
  Computed<UserBook?>? _$savedBookComputed;

  @override
  UserBook? get savedBook => (_$savedBookComputed ??= Computed<UserBook?>(
    () => super.savedBook,
    name: '_BookDetailsStore.savedBook',
  )).value;
  Computed<bool>? _$isSavedComputed;

  @override
  bool get isSaved => (_$isSavedComputed ??= Computed<bool>(
    () => super.isSaved,
    name: '_BookDetailsStore.isSaved',
  )).value;

  late final _$statusAtom = Atom(
    name: '_BookDetailsStore.status',
    context: context,
  );

  @override
  BookDetailsStatus get status {
    _$statusAtom.reportRead();
    return super.status;
  }

  @override
  set status(BookDetailsStatus value) {
    _$statusAtom.reportWrite(value, super.status, () {
      super.status = value;
    });
  }

  late final _$bookAtom = Atom(
    name: '_BookDetailsStore.book',
    context: context,
  );

  @override
  Book? get book {
    _$bookAtom.reportRead();
    return super.book;
  }

  @override
  set book(Book? value) {
    _$bookAtom.reportWrite(value, super.book, () {
      super.book = value;
    });
  }

  late final _$errorMessageAtom = Atom(
    name: '_BookDetailsStore.errorMessage',
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

  late final _$isSavingAtom = Atom(
    name: '_BookDetailsStore.isSaving',
    context: context,
  );

  @override
  bool get isSaving {
    _$isSavingAtom.reportRead();
    return super.isSaving;
  }

  @override
  set isSaving(bool value) {
    _$isSavingAtom.reportWrite(value, super.isSaving, () {
      super.isSaving = value;
    });
  }

  late final _$loadAsyncAction = AsyncAction(
    '_BookDetailsStore.load',
    context: context,
  );

  @override
  Future<void> load() {
    return _$loadAsyncAction.run(() => super.load());
  }

  late final _$_BookDetailsStoreActionController = ActionController(
    name: '_BookDetailsStore',
    context: context,
  );

  @override
  Future<void> add() {
    final _$actionInfo = _$_BookDetailsStoreActionController.startAction(
      name: '_BookDetailsStore.add',
    );
    try {
      return super.add();
    } finally {
      _$_BookDetailsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  Future<void> changeStatus(ReadingStatus status) {
    final _$actionInfo = _$_BookDetailsStoreActionController.startAction(
      name: '_BookDetailsStore.changeStatus',
    );
    try {
      return super.changeStatus(status);
    } finally {
      _$_BookDetailsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  Future<void> remove() {
    final _$actionInfo = _$_BookDetailsStoreActionController.startAction(
      name: '_BookDetailsStore.remove',
    );
    try {
      return super.remove();
    } finally {
      _$_BookDetailsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _loaded(Book value) {
    final _$actionInfo = _$_BookDetailsStoreActionController.startAction(
      name: '_BookDetailsStore._loaded',
    );
    try {
      return super._loaded(value);
    } finally {
      _$_BookDetailsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _failed(String message) {
    final _$actionInfo = _$_BookDetailsStoreActionController.startAction(
      name: '_BookDetailsStore._failed',
    );
    try {
      return super._failed(message);
    } finally {
      _$_BookDetailsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _setSaving(bool value) {
    final _$actionInfo = _$_BookDetailsStoreActionController.startAction(
      name: '_BookDetailsStore._setSaving',
    );
    try {
      return super._setSaving(value);
    } finally {
      _$_BookDetailsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
status: ${status},
book: ${book},
errorMessage: ${errorMessage},
isSaving: ${isSaving},
savedBook: ${savedBook},
isSaved: ${isSaved}
    ''';
  }
}

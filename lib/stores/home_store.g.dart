// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$HomeStore on _HomeStore, Store {
  late final _$statusAtom = Atom(name: '_HomeStore.status', context: context);

  @override
  HomeStatus get status {
    _$statusAtom.reportRead();
    return super.status;
  }

  @override
  set status(HomeStatus value) {
    _$statusAtom.reportWrite(value, super.status, () {
      super.status = value;
    });
  }

  late final _$spotlightAtom = Atom(
    name: '_HomeStore.spotlight',
    context: context,
  );

  @override
  Book? get spotlight {
    _$spotlightAtom.reportRead();
    return super.spotlight;
  }

  @override
  set spotlight(Book? value) {
    _$spotlightAtom.reportWrite(value, super.spotlight, () {
      super.spotlight = value;
    });
  }

  late final _$spotlightGenreAtom = Atom(
    name: '_HomeStore.spotlightGenre',
    context: context,
  );

  @override
  Genre? get spotlightGenre {
    _$spotlightGenreAtom.reportRead();
    return super.spotlightGenre;
  }

  @override
  set spotlightGenre(Genre? value) {
    _$spotlightGenreAtom.reportWrite(value, super.spotlightGenre, () {
      super.spotlightGenre = value;
    });
  }

  late final _$shelvesAtom = Atom(name: '_HomeStore.shelves', context: context);

  @override
  List<GenreShelf> get shelves {
    _$shelvesAtom.reportRead();
    return super.shelves;
  }

  @override
  set shelves(List<GenreShelf> value) {
    _$shelvesAtom.reportWrite(value, super.shelves, () {
      super.shelves = value;
    });
  }

  late final _$errorMessageAtom = Atom(
    name: '_HomeStore.errorMessage',
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

  late final _$loadAsyncAction = AsyncAction(
    '_HomeStore.load',
    context: context,
  );

  @override
  Future<void> load() {
    return _$loadAsyncAction.run(() => super.load());
  }

  late final _$_HomeStoreActionController = ActionController(
    name: '_HomeStore',
    context: context,
  );

  @override
  void _show(List<GenreShelf> all) {
    final _$actionInfo = _$_HomeStoreActionController.startAction(
      name: '_HomeStore._show',
    );
    try {
      return super._show(all);
    } finally {
      _$_HomeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _fail(String message) {
    final _$actionInfo = _$_HomeStoreActionController.startAction(
      name: '_HomeStore._fail',
    );
    try {
      return super._fail(message);
    } finally {
      _$_HomeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
status: ${status},
spotlight: ${spotlight},
spotlightGenre: ${spotlightGenre},
shelves: ${shelves},
errorMessage: ${errorMessage}
    ''';
  }
}

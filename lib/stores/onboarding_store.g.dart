// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$OnboardingStore on _OnboardingStore, Store {
  Computed<String>? _$trimmedNameComputed;

  @override
  String get trimmedName => (_$trimmedNameComputed ??= Computed<String>(
    () => super.trimmedName,
    name: '_OnboardingStore.trimmedName',
  )).value;
  Computed<int>? _$selectedCountComputed;

  @override
  int get selectedCount => (_$selectedCountComputed ??= Computed<int>(
    () => super.selectedCount,
    name: '_OnboardingStore.selectedCount',
  )).value;
  Computed<bool>? _$canSubmitComputed;

  @override
  bool get canSubmit => (_$canSubmitComputed ??= Computed<bool>(
    () => super.canSubmit,
    name: '_OnboardingStore.canSubmit',
  )).value;

  late final _$nameAtom = Atom(name: '_OnboardingStore.name', context: context);

  @override
  String get name {
    _$nameAtom.reportRead();
    return super.name;
  }

  @override
  set name(String value) {
    _$nameAtom.reportWrite(value, super.name, () {
      super.name = value;
    });
  }

  late final _$isSavingAtom = Atom(
    name: '_OnboardingStore.isSaving',
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

  late final _$submitAsyncAction = AsyncAction(
    '_OnboardingStore.submit',
    context: context,
  );

  @override
  Future<bool> submit() {
    return _$submitAsyncAction.run(() => super.submit());
  }

  late final _$_OnboardingStoreActionController = ActionController(
    name: '_OnboardingStore',
    context: context,
  );

  @override
  void setName(String value) {
    final _$actionInfo = _$_OnboardingStoreActionController.startAction(
      name: '_OnboardingStore.setName',
    );
    try {
      return super.setName(value);
    } finally {
      _$_OnboardingStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void toggleGenre(Genre genre) {
    final _$actionInfo = _$_OnboardingStoreActionController.startAction(
      name: '_OnboardingStore.toggleGenre',
    );
    try {
      return super.toggleGenre(genre);
    } finally {
      _$_OnboardingStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
name: ${name},
isSaving: ${isSaving},
trimmedName: ${trimmedName},
selectedCount: ${selectedCount},
canSubmit: ${canSubmit}
    ''';
  }
}

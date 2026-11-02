import 'package:mobx/mobx.dart';

import '../data/repositories/preferences_repository.dart';
import '../models/genre.dart';
import '../models/user_preferences.dart';

part 'onboarding_store.g.dart';

/// Estado do onboarding: nome, gêneros escolhidos e envio (S05).
class OnboardingStore = _OnboardingStore with _$OnboardingStore;

abstract class _OnboardingStore with Store {
  _OnboardingStore(this._repository);

  static const int maxNameLength = 40;

  final PreferencesRepository _repository;

  @observable
  String name = '';

  /// Gêneros marcados. A coleção em si é observável.
  final ObservableSet<Genre> selectedGenres = ObservableSet<Genre>();

  @observable
  bool isSaving = false;

  @computed
  String get trimmedName => name.trim();

  @computed
  int get selectedCount => selectedGenres.length;

  @computed
  bool get canSubmit =>
      trimmedName.isNotEmpty &&
      trimmedName.length <= maxNameLength &&
      selectedGenres.isNotEmpty &&
      !isSaving;

  @action
  void setName(String value) => name = value;

  @action
  void toggleGenre(Genre genre) {
    if (!selectedGenres.remove(genre)) selectedGenres.add(genre);
  }

  /// Salva as preferências. Devolve `false` se o formulário estiver incompleto.
  @action
  Future<bool> submit() async {
    if (!canSubmit) return false;
    isSaving = true;
    try {
      await _repository.save(
        UserPreferences(
          name: trimmedName,
          genres: [
            for (final genre in Genre.values)
              if (selectedGenres.contains(genre)) genre.key,
          ],
        ),
      );
      return true;
    } finally {
      isSaving = false;
    }
  }
}

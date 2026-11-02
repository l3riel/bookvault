import '../../core/storage/local_storage.dart';
import '../../models/user_preferences.dart';

/// Preferências do onboarding guardadas no aparelho.
class PreferencesRepository {
  const PreferencesRepository({required this._storage});

  static const String storageKey = 'user.preferences';

  final LocalStorage _storage;

  /// Preferências salvas, ou `null` se não houver (ou se estiverem corrompidas).
  UserPreferences? load() {
    final raw = _storage.readJson(storageKey);
    if (raw is! Map<String, Object?>) return null;
    try {
      return UserPreferences.fromJson(raw);
    } on FormatException {
      return null;
    }
  }

  Future<void> save(UserPreferences preferences) {
    return _storage.writeJson(storageKey, preferences.toJson());
  }
}

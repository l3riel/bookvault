import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Armazenamento local em JSON por chave, sobre o [SharedPreferences].
///
/// É a única classe do app que conhece o SharedPreferences (ADR 0003). Não
/// conhece os modelos: quem converte é o repositório.
class LocalStorage {
  const LocalStorage(this._preferences);

  final SharedPreferences _preferences;

  /// JSON decodificado da [key], ou `null` se não houver valor ou se ele não
  /// for um JSON válido.
  Object? readJson(String key) {
    final raw = _preferences.getString(key);
    if (raw == null) return null;
    try {
      return jsonDecode(raw);
    } on FormatException {
      return null;
    }
  }

  Future<void> writeJson(String key, Object value) async {
    await _preferences.setString(key, jsonEncode(value));
  }

  Future<void> remove(String key) async {
    await _preferences.remove(key);
  }
}

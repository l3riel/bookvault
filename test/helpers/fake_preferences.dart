import 'package:shared_preferences/shared_preferences.dart';

/// Cria um [SharedPreferences] em memória com [values] iniciais.
Future<SharedPreferences> openPreferences([
  Map<String, Object> values = const {},
]) async {
  SharedPreferences.resetStatic();
  SharedPreferences.setMockInitialValues(values);
  return SharedPreferences.getInstance();
}

/// Simula fechar e reabrir o app: copia o que foi gravado em [current] para
/// uma instância nova, lida do zero.
Future<SharedPreferences> reopenPreferences(SharedPreferences current) {
  final saved = <String, Object>{
    for (final key in current.getKeys()) key: current.get(key)!,
  };
  return openPreferences(saved);
}

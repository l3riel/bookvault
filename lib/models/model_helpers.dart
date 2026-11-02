/// Funções de apoio à leitura de JSON e à igualdade dos modelos.
///
/// Leitura estrita: campos obrigatórios ausentes ou com tipo errado lançam
/// [FormatException]; opcionais ausentes viram `null` ou lista vazia.
library;

typedef Json = Map<String, Object?>;

String readRequiredString(Json json, String key) {
  final value = json[key];
  if (value is String && value.isNotEmpty) return value;
  throw FormatException('Campo obrigatório "$key" ausente ou inválido.', json);
}

String? readOptionalString(Json json, String key) {
  final value = json[key];
  return value is String ? value : null;
}

int? readOptionalInt(Json json, String key) {
  final value = json[key];
  return value is int ? value : null;
}

List<String> readStringList(Json json, String key) {
  final value = json[key];
  if (value is! List) return const [];
  return List.unmodifiable(value.whereType<String>());
}

Json readRequiredMap(Json json, String key) {
  final value = json[key];
  if (value is Map<String, Object?>) return value;
  throw FormatException('Campo obrigatório "$key" ausente ou inválido.', json);
}

bool listEquals<T>(List<T> a, List<T> b) {
  if (identical(a, b)) return true;
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

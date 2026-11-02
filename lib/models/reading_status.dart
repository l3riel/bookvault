/// Status de leitura de um livro na biblioteca.
enum ReadingStatus {
  wantToRead('want_to_read', 'Quero ler'),
  reading('reading', 'Lendo'),
  completed('completed', 'Concluído');

  const ReadingStatus(this.jsonValue, this.label);

  /// Valor gravado no JSON de persistência.
  final String jsonValue;

  /// Rótulo exibido na interface.
  final String label;

  String toJson() => jsonValue;

  /// Lança [FormatException] se [value] não for um status conhecido.
  static ReadingStatus fromJson(Object? value) {
    for (final status in values) {
      if (status.jsonValue == value) return status;
    }
    throw FormatException('Status de leitura desconhecido: $value');
  }
}

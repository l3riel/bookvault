import 'package:bookvault/models/reading_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('converte cada status para JSON e de volta', () {
    for (final status in ReadingStatus.values) {
      expect(ReadingStatus.fromJson(status.toJson()), status);
    }
  });

  test('usa os valores de JSON da spec', () {
    expect(ReadingStatus.wantToRead.toJson(), 'want_to_read');
    expect(ReadingStatus.reading.toJson(), 'reading');
    expect(ReadingStatus.completed.toJson(), 'completed');
  });

  test('tem os rótulos em pt-BR', () {
    expect(ReadingStatus.wantToRead.label, 'Quero ler');
    expect(ReadingStatus.reading.label, 'Lendo');
    expect(ReadingStatus.completed.label, 'Concluído');
  });

  test('lança FormatException para status desconhecido', () {
    expect(() => ReadingStatus.fromJson('abandoned'), throwsFormatException);
    expect(() => ReadingStatus.fromJson(null), throwsFormatException);
  });
}

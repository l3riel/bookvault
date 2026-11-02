import 'package:bookvault/models/genre.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('tem os 10 gêneros do protótipo com rótulo pt-BR e termo de busca', () {
    expect(Genre.values, hasLength(10));
    for (final genre in Genre.values) {
      expect(genre.key, isNotEmpty);
      expect(genre.label, isNotEmpty);
      expect(genre.subject, isNotEmpty);
    }
    expect(Genre.scienceFiction.label, 'Ficção científica');
    expect(Genre.thriller.label, 'Suspense');
  });

  test('chaves são únicas', () {
    final keys = Genre.values.map((g) => g.key).toSet();

    expect(keys, hasLength(Genre.values.length));
  });

  test('fromKey encontra pela chave e devolve null se não conhecer', () {
    expect(Genre.fromKey('fantasy'), Genre.fantasy);
    expect(Genre.fromKey('science_fiction'), Genre.scienceFiction);
    expect(Genre.fromKey('romance'), isNull);
  });
}

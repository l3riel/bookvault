import 'package:bookvault/models/user_preferences.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const preferences = UserPreferences(
    name: 'Gabriel',
    genres: ['Fantasia', 'Ficção científica'],
  );

  test('toJson e fromJson preservam nome e gêneros', () {
    final restored = UserPreferences.fromJson(preferences.toJson());

    expect(restored, preferences);
    expect(restored.name, 'Gabriel');
    expect(restored.genres, ['Fantasia', 'Ficção científica']);
  });

  test('lança FormatException sem nome', () {
    expect(
      () => UserPreferences.fromJson({
        'genres': ['Fantasia'],
      }),
      throwsFormatException,
    );
  });

  test('preferências com os mesmos dados são iguais e têm o mesmo hash', () {
    const copy = UserPreferences(
      name: 'Gabriel',
      genres: ['Fantasia', 'Ficção científica'],
    );
    const other = UserPreferences(name: 'Gabriel', genres: ['Fantasia']);

    expect(copy, preferences);
    expect(copy.hashCode, preferences.hashCode);
    expect(other, isNot(preferences));
  });

  test('toString mostra nome e gêneros', () {
    expect(
      preferences.toString(),
      'UserPreferences(Gabriel, [Fantasia, Ficção científica])',
    );
  });
}

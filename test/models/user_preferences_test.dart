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
}

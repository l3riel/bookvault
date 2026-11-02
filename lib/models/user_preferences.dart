import 'model_helpers.dart';

/// Preferências informadas no onboarding.
class UserPreferences {
  const UserPreferences({required this.name, required this.genres});

  factory UserPreferences.fromJson(Json json) {
    return UserPreferences(
      name: readRequiredString(json, 'name'),
      genres: readStringList(json, 'genres'),
    );
  }

  final String name;

  /// Gêneros escolhidos, em texto livre (lista fixa na Etapa 05).
  final List<String> genres;

  Json toJson() => {'name': name, 'genres': genres};

  @override
  bool operator ==(Object other) =>
      other is UserPreferences &&
      other.name == name &&
      listEquals(other.genres, genres);

  @override
  int get hashCode => Object.hash(name, Object.hashAll(genres));

  @override
  String toString() => 'UserPreferences($name, $genres)';
}

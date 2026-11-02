/// Gêneros literários oferecidos no onboarding (S05).
///
/// [key] é o que fica salvo em `UserPreferences.genres`; [label] é o texto da
/// interface; [subject] é o termo de busca da Google Books (Etapa 08).
enum Genre {
  scienceFiction('science_fiction', 'Ficção científica', 'science fiction'),
  philosophy('philosophy', 'Filosofia', 'philosophy'),
  fantasy('fantasy', 'Fantasia', 'fantasy'),
  classics('classics', 'Clássicos', 'classics'),
  technology('technology', 'Tecnologia', 'technology'),
  mystery('mystery', 'Mistério', 'mystery'),
  history('history', 'História', 'history'),
  fiction('fiction', 'Ficção', 'fiction'),
  thriller('thriller', 'Suspense', 'thriller'),
  biography('biography', 'Biografia', 'biography');

  const Genre(this.key, this.label, this.subject);

  final String key;
  final String label;
  final String subject;

  /// Gênero da [key], ou `null` se ela não for conhecida.
  static Genre? fromKey(String key) {
    for (final genre in values) {
      if (genre.key == key) return genre;
    }
    return null;
  }
}

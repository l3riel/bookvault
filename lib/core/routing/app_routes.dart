/// Caminhos das rotas do app.
abstract final class AppRoutes {
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String explore = '/explore';
  static const String library = '/library';
  static const String bookDetails = '/book/:id';

  static String bookDetailsOf(String id) => '/book/${Uri.encodeComponent(id)}';
}

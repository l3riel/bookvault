/// Escala de espaçamento (múltiplos de 4px) do `DESIGN.md`.
abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double gutter = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;

  /// Margem lateral das telas no celular.
  static const double screenMargin = md;

  /// Altura mínima de alvos de toque.
  static const double touchTarget = 48;

  /// Altura da barra de navegação inferior.
  static const double navigationBarHeight = 64;
}

/// Raios de borda do `DESIGN.md`.
abstract final class AppRadius {
  /// Capas de livro.
  static const double sm = 4;

  /// Botões, cards e campos.
  static const double md = 8;
  static const double lg = 16;

  /// Chips e pílulas.
  static const double full = 9999;
}

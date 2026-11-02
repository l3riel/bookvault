/// Tipos de falha ao consultar livros na API.
enum BooksErrorType {
  noConnection(
    'Sem conexão com a internet. Verifique sua rede e tente de novo.',
  ),
  timeout('A consulta demorou demais. Tente de novo.'),
  notFound('Livro não encontrado.'),
  server('Não foi possível carregar os livros agora. Tente mais tarde.');

  const BooksErrorType(this.message);

  /// Mensagem pt-BR para a interface.
  final String message;
}

/// Erro de consulta de livros já traduzido para o app.
class BooksException implements Exception {
  const BooksException(this.type);

  final BooksErrorType type;

  String get message => type.message;

  @override
  String toString() => 'BooksException(${type.name})';
}

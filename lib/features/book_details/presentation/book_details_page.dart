import 'package:flutter/material.dart';

import '../../../shared/widgets/placeholder_view.dart';

/// Tela de detalhes de um livro. Conteúdo real em etapa futura do plano.
class BookDetailsPage extends StatelessWidget {
  const BookDetailsPage({required this.bookId, super.key});

  /// `volumeId` do Google Books.
  final String bookId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: PlaceholderView(title: 'Detalhes do livro', subtitle: bookId),
    );
  }
}

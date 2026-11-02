import 'package:flutter/material.dart';

import '../../app/widgets/placeholder_view.dart';

/// Tela de Início. Conteúdo real em etapa futura do plano.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: PlaceholderView(title: 'Início'));
  }
}

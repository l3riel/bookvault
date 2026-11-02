import 'package:flutter/material.dart';

import '../../app/widgets/placeholder_view.dart';

/// Tela de Boas-vindas. Conteúdo real em etapa futura do plano.
class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: PlaceholderView(title: 'Boas-vindas'));
  }
}

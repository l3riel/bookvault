import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'app_dependencies.dart';
import 'theme/app_colors.dart';
import 'theme/app_theme.dart';

/// Largura máxima do conteúdo: o app é mobile-first; em telas largas (web,
/// tablet) ele vira uma coluna central (S09).
const double maxContentWidth = 600;

/// Widget raiz: aplica o tema e as rotas.
class BookVaultApp extends StatelessWidget {
  const BookVaultApp({
    required this.dependencies,
    required this.router,
    super.key,
  });

  final AppDependencies dependencies;
  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'BookVault',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      routerConfig: router,
      builder: (context, child) => ColoredBox(
        color: AppColors.surfaceBase,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: maxContentWidth),
            child: child,
          ),
        ),
      ),
    );
  }
}

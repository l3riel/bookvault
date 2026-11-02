import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'theme/app_theme.dart';
import 'app_dependencies.dart';

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
    );
  }
}

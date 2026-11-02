import 'package:flutter/material.dart';

import 'app/app.dart';
import 'app/app_dependencies.dart';
import 'core/routing/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dependencies = await AppDependencies.create();

  // Até a Etapa 05 não há preferências salvas: o app abre direto no Início.
  final router = createAppRouter(isOnboarded: () => true);
  runApp(BookVaultApp(dependencies: dependencies, router: router));
}

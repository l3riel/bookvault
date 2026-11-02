import 'package:flutter/material.dart';

import 'app/app.dart';
import 'core/routing/app_router.dart';

void main() {
  // Até a Etapa 05 não há preferências salvas: o app abre direto no Início.
  final router = createAppRouter(isOnboarded: () => true);
  runApp(BookVaultApp(router: router));
}

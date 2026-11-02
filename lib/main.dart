import 'package:flutter/material.dart';

import 'app/app.dart';
import 'app/app_dependencies.dart';
import 'app/router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dependencies = await AppDependencies.create();
  final router = createAppRouter(dependencies);
  runApp(BookVaultApp(dependencies: dependencies, router: router));
}

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/network/dio_client.dart';

/// Objetos compartilhados do app, criados uma vez no `main` e repassados pelo
/// construtor (injeção manual, sem service locator).
///
/// Repositórios e Stores das próximas etapas são montados aqui a partir
/// destes objetos.
class AppDependencies {
  const AppDependencies({required this.preferences, required this.dio});

  final SharedPreferences preferences;
  final Dio dio;

  static Future<AppDependencies> create() async {
    final preferences = await SharedPreferences.getInstance();
    return AppDependencies(preferences: preferences, dio: createDioClient());
  }
}

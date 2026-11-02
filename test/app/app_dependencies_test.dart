import 'package:bookvault/app/app_dependencies.dart';
import 'package:bookvault/core/network/dio_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('cria SharedPreferences e Dio apontando para a Google Books', () async {
    SharedPreferences.setMockInitialValues({'chave': 'valor'});

    final dependencies = await AppDependencies.create();

    expect(dependencies.preferences.getString('chave'), 'valor');
    expect(dependencies.dio.options.baseUrl, googleBooksBaseUrl);
    expect(
      dependencies.dio.options.connectTimeout,
      const Duration(seconds: 10),
    );
  });
}

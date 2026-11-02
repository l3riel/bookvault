import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/network/dio_client.dart';
import '../core/storage/local_storage.dart';
import '../data/repositories/books_repository.dart';
import '../data/repositories/library_repository.dart';
import '../data/repositories/preferences_repository.dart';
import '../services/books_api_service.dart';
import '../stores/library_store.dart';

/// Objetos compartilhados do app, criados uma vez no `main` e repassados pelo
/// construtor (injeção manual, sem service locator).
class AppDependencies {
  AppDependencies({required SharedPreferences preferences, required this.dio})
    : localStorage = LocalStorage(preferences) {
    libraryRepository = LibraryRepository(storage: localStorage);
    preferencesRepository = PreferencesRepository(storage: localStorage);
    booksApiService = BooksApiService(dio);
    booksRepository = BooksRepository(api: booksApiService);
    libraryStore = LibraryStore(libraryRepository)..load();
  }

  final Dio dio;
  final LocalStorage localStorage;
  late final LibraryRepository libraryRepository;
  late final PreferencesRepository preferencesRepository;
  late final BooksApiService booksApiService;
  late final BooksRepository booksRepository;

  /// Única no app: Biblioteca e Detalhes compartilham o mesmo estado.
  late final LibraryStore libraryStore;

  static Future<AppDependencies> create() async {
    final preferences = await SharedPreferences.getInstance();
    return AppDependencies(preferences: preferences, dio: createDioClient());
  }
}

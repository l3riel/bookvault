# lib/ — organização do código

Estrutura do [Plano de Execução](../docs/PLANO.md), organizada por responsabilidade ([ADR 0007](../docs/adr/0007-estrutura-por-responsabilidade.md)).

```
lib/
├── main.dart                 # cria as dependências e chama o App
├── app/
│   ├── app.dart              # MaterialApp.router com tema e rotas
│   ├── router.dart           # GoRouter (rotas e redirect do onboarding)
│   ├── app_shell.dart        # barra de abas Início / Explorar / Biblioteca
│   ├── app_dependencies.dart # injeção manual de dependências
│   ├── widgets/              # widgets do app usados por várias telas
│   └── theme/                # app_theme, app_colors, app_typography, app_spacing
├── core/
│   ├── network/dio_client.dart
│   └── storage/local_storage.dart
├── models/                   # Book, UserBook, UserPreferences, ReadingStatus (Dart puro)
├── data/
│   ├── dtos/                 # GoogleBooksVolumeDto (formato da API)
│   └── repositories/         # BooksRepository, LibraryRepository
├── services/                 # BooksApiService (chamadas HTTP)
├── stores/                   # Stores MobX: onboarding, home, search, library
└── features/                 # uma pasta por tela, com seus componentes
    ├── onboarding/
    ├── home/
    ├── explore/
    ├── book_details/
    └── library/
```

Regras de dependência: `features → stores → data/repositories → (services | core) → models`.
- Widgets não fazem HTTP nem persistência: falam só com a Store.
- `models/` não importa Flutter nem DTOs; a conversão DTO → modelo fica em `data/`.

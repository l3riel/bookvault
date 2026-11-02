# lib/ — organização do código

Arquitetura **feature-first** com camadas dentro de cada feature (ver `docs/ARCHITECTURE.md`).

```
lib/
├── main.dart            # ponto de entrada: inicializa dependências e chama o App
├── app/
│   └── app.dart         # MaterialApp.router com tema e rotas
├── core/                # o que é do app inteiro e não pertence a nenhuma feature
│   ├── theme/           # cores, tipografia, espaçamento, ThemeData
│   ├── routing/         # GoRouter
│   ├── network/         # cliente Dio
│   ├── storage/         # LocalStorage (SharedPreferences)
│   └── utils/           # helpers puros (formatação, validação…)
├── shared/
│   └── widgets/         # widgets reutilizados por mais de uma feature
└── features/
    ├── books/           # só dados: Book, DTO e acesso à Google Books API
    ├── onboarding/
    ├── home/
    ├── explore/
    ├── book_details/
    └── library/
        ├── data/        # repositórios, fontes de dados, DTOs
        ├── domain/      # entidades e regras de negócio (Dart puro, sem Flutter)
        └── presentation/ # telas, widgets e Store MobX da feature
```

Regra de dependência: `presentation → domain ← data`. O `domain` não importa nada de Flutter nem de `data`. Widgets não fazem HTTP nem persistência: falam só com a Store.

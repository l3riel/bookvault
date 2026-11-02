# lib/ — organização do código

Arquitetura **feature-first** com camadas dentro de cada feature (ver `docs/ARCHITECTURE.md`).

```
lib/
├── main.dart            # ponto de entrada: só inicializa e chama o App
├── core/                # o que é do app inteiro e não pertence a nenhuma feature
│   ├── theme/           # cores, tipografia, ThemeData
│   ├── routing/         # rotas/navegação
│   └── utils/           # helpers puros (formatação, validação…)
├── shared/
│   └── widgets/         # widgets reutilizados por mais de uma feature
└── features/
    └── <feature>/       # uma pasta por funcionalidade (ex.: books, reading_list)
        ├── data/        # repositórios, fontes de dados, modelos de persistência
        ├── domain/      # entidades e regras de negócio (Dart puro, sem Flutter)
        └── presentation/ # telas, widgets e estado da feature
```

Regra de dependência: `presentation → domain ← data`. O `domain` não importa nada de Flutter nem de `data`.

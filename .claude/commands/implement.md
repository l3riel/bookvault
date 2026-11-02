---
description: Implementa uma spec aprovada seguindo o CLAUDE.md
argument-hint: <caminho da spec, ex. docs/specs/F1-cadastro.md>
---
Implemente a spec $ARGUMENTS.

1. Confira se o status é `aprovada`; se não for, pare e avise.
2. Mostre o plano (arquivos a criar/alterar e testes) e espere o ok.
3. Implemente em `lib/features/<feature>/` respeitando as camadas e escreva os testes dos critérios de aceite.
4. Rode `dart format .`, `flutter analyze` e `flutter test` até passarem.
5. Atualize o status da spec para `implementada` e faça commits atômicos no padrão do projeto.

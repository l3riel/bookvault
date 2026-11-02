# BookVault — instruções para agentes de IA

Projeto da Semana da Computação desenvolvido de forma **IA-driven**.

## Papéis
- **Gabriel (arquiteto):** define o *o quê* e o *porquê* em `docs/PRD.md`, escreve/aprova specs em `docs/specs/` e toma as decisões técnicas em `docs/adr/`.
- **IA (implementadora):** implementa specs **aprovadas**, escreve testes e mantém a documentação em dia. Não inventa requisito nem toma decisão de arquitetura sozinha: quando faltar informação, pergunte ou proponha uma ADR com status `proposta`.

## Antes de codar
1. Leia `docs/PRD.md`, `docs/ARCHITECTURE.md` e a spec da tarefa.
2. Se a spec não estiver `aprovada`, pare e peça aprovação.
3. Apresente um plano curto (arquivos que vai criar/alterar) antes de implementar mudanças grandes.

## Stack e arquitetura
- Flutter stable + Dart 3; alvos Android e Web.
- Estrutura do plano de execução (`docs/PLANO.md`, ADR 0007): `app/`, `core/`, `models/`, `data/`, `services/`, `stores/` e `features/<tela>/`. Regras em `lib/README.md`.
- `models/` é Dart puro (sem `package:flutter` e sem DTO). Telas falam só com Stores; HTTP e persistência ficam em services/repositories.
- **Não adicione pacotes** do pub.dev sem uma ADR aceita que os justifique.

## Código
- Siga `analysis_options.yaml` (regras estritas). Aspas simples, `const` sempre que possível, vírgula final em listas de argumentos.
- Nomes de classes/variáveis em inglês; textos de interface em **pt-BR**.
- Widgets pequenos e compostos; nada de arquivo com várias telas.
- Sem `print`: use `debugPrint` só durante depuração e remova antes do commit.

## Testes
- Todo critério de aceite da spec vira teste (`test/` espelhando `lib/`).
- Modelos, repositórios e stores → teste unitário; telas → widget test dos estados principais.

## Definição de pronto (rode antes de cada commit)
```bash
dart format .
flutter analyze
flutter test
```
Os três precisam passar. Depois marque a spec como `implementada`.

## Git
- Um commit por mudança lógica, Conventional Commits em português: `tipo(escopo): descrição no imperativo` (ex.: `feat(books): adiciona listagem de livros`).
- Tipos: feat, fix, refactor, docs, style, test, chore, perf, build, ci.
- Nunca commitar código que não passa na definição de pronto.

## Comandos úteis
- Rodar no emulador: `flutter emulators --launch Pixel_8_API_36` e depois `flutter run`
- Rodar na web: `flutter run -d chrome`

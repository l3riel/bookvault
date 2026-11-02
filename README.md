# 📚 BookVault

Projeto da **Semana da Computação**, desenvolvido de forma **IA-driven**: o arquiteto define requisitos, specs e decisões; agentes de IA implementam, testam e documentam.

## Como funciona o fluxo
1. **PRD** — o problema e o escopo do MVP ficam em [`docs/PRD.md`](docs/PRD.md).
2. **Spec** — cada funcionalidade vira uma spec em [`docs/specs/`](docs/specs/) (`/spec <ideia>` no Claude Code gera o rascunho).
3. **Aprovação** — o arquiteto revisa e muda o status para `aprovada`.
4. **Implementação** — a IA implementa (`/implement docs/specs/F1-...md`) seguindo o [`CLAUDE.md`](CLAUDE.md).
5. **Revisão** — `/review` confere o diff contra a spec e a arquitetura; o CI roda format, analyze e testes.

Decisões técnicas ficam registradas em [`docs/adr/`](docs/adr/).

## Rodando
Pré-requisitos: Flutter stable, um emulador Android (ou Chrome) e uma chave da Google Books API.

1. Copie `config/api_keys.example.json` para `config/api_keys.json` e cole a sua chave. A pasta `config/` fica fora do git: **nunca versione a chave**.
2. Rode passando o arquivo (o `launch.json` do VS Code já faz isso):

```bash
flutter pub get
flutter emulators --launch Pixel_8_API_36
flutter run --dart-define-from-file=config/api_keys.json
```

Na web: `flutter run -d chrome --dart-define-from-file=config/api_keys.json`.

Sem a chave o app roda, mas a Google Books usa a cota anônima, que costuma estar esgotada (HTTP 429).

## Definição de pronto
```bash
dart format .
flutter analyze
flutter test
```

## Estrutura
Ver [`lib/README.md`](lib/README.md) e [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md).

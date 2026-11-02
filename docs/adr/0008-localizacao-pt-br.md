# ADR 0008 — Textos do Material em pt-BR com flutter_localizations

- **Data:** 2026-11-02
- **Status:** aceita

## Contexto
Na revisão da Etapa 09, o leitor de tela e as dicas dos componentes do Material apareciam em inglês ("Back", "Close", "Dismiss"), porque o app não carregava as traduções do framework. O PRD pede a interface em pt-BR.

## Decisão
Usar `flutter_localizations`, que vem com o SDK do Flutter (não é pacote do pub.dev), e fixar o app em `pt_BR` com os delegates do Material, Widgets e Cupertino.

## Alternativas consideradas
- Escrever um `LocalizationsDelegate` próprio só com os textos usados: mais código para manter e fácil de esquecer algum rótulo.
- Deixar em inglês: contraria o PRD e prejudica a acessibilidade.

## Consequências
- O pacote `intl` entra como dependência transitiva do SDK.
- Botões e rótulos do sistema ("Voltar", "Fechar"), leitor de tela e seleção de texto ficam em português.
- O app não muda de idioma conforme o aparelho (pt-BR é o único idioma do MVP).

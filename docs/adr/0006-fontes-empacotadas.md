# ADR 0006 — Fontes Newsreader e DM Sans empacotadas no app

- **Data:** 2026-11-02
- **Status:** proposta

## Contexto
O design system usa Newsreader (títulos e textos longos) e DM Sans (interface). O Flutter não traz essas fontes, e o app precisa funcionar offline.

## Decisão
Baixar os arquivos `.ttf` (licença SIL Open Font License) do Google Fonts para `assets/fonts/` e declará-los no `pubspec.yaml`, sem pacote extra.

## Alternativas consideradas
- Pacote `google_fonts`: baixa as fontes em tempo de execução; no primeiro uso offline o app cairia na fonte padrão, e seria mais um pacote.

## Consequências
- O app fica ~1 MB maior.
- Nenhuma dependência nova; tipografia idêntica online e offline.
- Os ícones usam Material Icons (já incluídos no Flutter), equivalentes aos Material Symbols do protótipo.

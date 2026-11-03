# Spec — Integração e acabamento (Etapa 09)

- **ID:** Etapa 09 do [Plano de Execução](../PLANO.md)
- **Status:** implementada
- **Pastas:** `android/app/src/main/`, `web/`, `lib/app/`, telas em `lib/features/`
- **Referência visual:** `design/*.png` (Stitch, Nocturne Editorial)

## Objetivo
Deixar o app inteiro integrado, coerente com o design system e sem arestas: abertura escura, nome certo, SafeArea, layout bom em telas largas (web) e fluxos revisados de ponta a ponta.

## Regras
1. **Abertura nativa escura:** a tela branca do Android antes do Flutter passa a ser `#121214` (fundo do app), no tema claro e no escuro. Na web, `background_color`/`theme_color` e o fundo da página também.
2. **Nome do app:** "BookVault" no launcher do Android, no título da aba e no manifesto da web.
3. **SafeArea:** nenhum conteúdo fica sob a barra de status ou a barra de gestos (inclusive no fim da rolagem dos Detalhes).
4. **Telas largas (web/tablet):** o app é mobile-first; acima de 600 px de largura o conteúdo fica numa coluna central de 600 px sobre o fundo do app, preservando o layout do Stitch.
5. **Revisão de integração:** telas falam só com Stores; nenhum widget faz HTTP ou persistência (conferido por busca no código e por teste).
6. **Offline:** Biblioteca e Detalhes de livros salvos funcionam sem rede; Home e Explorar mostram o erro em pt-BR com "Tentar de novo"; capas viram o marcador.
7. **Comparação com o Stitch:** cada tela conferida contra o PNG correspondente; divergências corrigidas ou registradas abaixo.
8. **Chrome:** o app abre e funciona no Chrome (não só compila).

## Critérios de aceite
- [x] O Android abre com fundo escuro, sem flash branco, e o launcher mostra "BookVault".
- [x] A web tem título "BookVault" e cores do tema.
- [x] Em largura de 1200 px, o conteúdo fica centralizado com no máximo 600 px.
- [x] O fim da rolagem dos Detalhes não fica sob a barra de gestos.
- [x] Nenhum arquivo de `lib/features/` importa Dio, SharedPreferences, `services/` ou `data/`.
- [x] Fluxo completo no emulador: onboarding → Início → Explorar → Detalhes → adicionar → Biblioteca → mudar status → remover, sem exceções no log.
- [x] Modo avião: Biblioteca e Detalhes salvos funcionam; Início e Explorar mostram erro.
- [x] O app roda no Chrome com busca real.

## Fora de escopo
Animações de transição, tema claro, troca de idioma.

## Decisões
Pedido do arquiteto em 02/11/2026: "faça tudo da etapa 09". As escolhas acima (coluna de 600 px na web, cor da abertura) seguem o design system e podem ser revistas.

## Notas da implementação
- **Ícone:** feito sem pacote, em vetor (símbolo `local_library` da barra, latão sobre `#26262C`): ícone adaptativo no Android 8+, PNGs legados e ícones da web gerados do mesmo desenho; também aparece na abertura do Android 12+.
- **Achados da revisão e correções:**
  - rótulos do Material em inglês ("Back") → `flutter_localizations` em pt-BR ([ADR 0008](../adr/0008-localizacao-pt-br.md));
  - capas não carregavam na web (books.google.com sem CORS) → `WebHtmlElementStrategy.fallback` no `BookCover`;
  - Detalhes sem SafeArea embaixo → corrigido.
- **Validação manual (02/11/2026):** fluxo completo no emulador sem exceções no log; modo avião conforme a regra 6; no Chrome, onboarding, Início com capas, Detalhes, adicionar e persistência após recarregar.
- **Divergências aceitas em relação ao Stitch:** subtítulo da Home fixo ("O que vamos ler hoje?") em vez de citar os gêneros; fileiras sem o chip/subtítulo editorial ("PHILOSOPHY · Thought & Dialectics"); contagem do Explorar sem o ponto dourado; a ordem das fileiras segue a ordem dos gêneros na tela de onboarding, não a ordem em que foram tocados.

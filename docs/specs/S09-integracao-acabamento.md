# Spec — Integração e acabamento (Etapa 09)

- **ID:** Etapa 09 do [Plano de Execução](../PLANO.md)
- **Status:** aprovada
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
- [ ] O Android abre com fundo escuro, sem flash branco, e o launcher mostra "BookVault".
- [ ] A web tem título "BookVault" e cores do tema.
- [ ] Em largura de 1200 px, o conteúdo fica centralizado com no máximo 600 px.
- [ ] O fim da rolagem dos Detalhes não fica sob a barra de gestos.
- [ ] Nenhum arquivo de `lib/features/` importa Dio, SharedPreferences, `services/` ou `data/`.
- [ ] Fluxo completo no emulador: onboarding → Início → Explorar → Detalhes → adicionar → Biblioteca → mudar status → remover, sem exceções no log.
- [ ] Modo avião: Biblioteca e Detalhes salvos funcionam; Início e Explorar mostram erro.
- [ ] O app roda no Chrome com busca real.

## Fora de escopo
Ícone próprio do app (exigiria arte nova ou pacote), animações de transição, tema claro.

## Decisões
Pedido do arquiteto em 02/11/2026: "faça tudo da etapa 09". As escolhas acima (coluna de 600 px na web, cor da abertura) seguem o design system e podem ser revistas.

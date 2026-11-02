# Spec — Início com recomendações (Etapa 08)

- **ID:** F5 do `docs/PRD.md` · Etapa 08 do [Plano de Execução](../PLANO.md)
- **Status:** implementada
- **Pastas:** `lib/features/home/`, `lib/stores/home_store.dart`, `lib/app/router.dart`
- **Referência visual:** [`design/home.png`](../../design/home.png)

## Objetivo
Ao abrir o app, o usuário é cumprimentado pelo nome e vê livros recomendados pelos gêneros que escolheu no onboarding, podendo abrir os detalhes de qualquer um.

## Histórias de usuário
- Como leitor, quero ver sugestões dos gêneros de que gosto logo ao abrir o app.
- Como leitor, quero tocar numa sugestão e ver os detalhes para decidir se salvo.

## Regras de negócio
1. **HomeStore** (MobX): nome, gêneros do usuário, recomendações por gênero e estado (`carregando`, `pronto`, `vazio`, `erro`). Usa só o `PreferencesRepository` e o `BooksRepository`.
2. **Saudação pela hora do aparelho:** "Bom dia" (5h–11h59), "Boa tarde" (12h–17h59), "Boa noite" (18h–4h59), seguida do nome. Ex.: "Boa noite, Gabriel".
3. **Recomendações sem IA (regra do plano):** para cada gênero escolhido, busca na Google Books por `subject:<gênero>` (o campo `subject` do enum `Genre`). No máximo **3 gêneros**, na ordem do onboarding, para poupar a cota; as buscas correm em paralelo.
4. Livros repetidos entre gêneros aparecem só no primeiro. Livros já salvos na biblioteca **continuam** aparecendo, com o selo de status.
5. **Carrega uma vez por sessão:** a aba guarda o resultado ao trocar de aba; "puxar para atualizar" recarrega.
6. **Falhas:** se todos os gêneros falharem, a tela mostra o erro em pt-BR com "Tentar de novo"; se só alguns falharem, mostra os que deram certo e omite os outros. Gênero sem nenhum livro é omitido; se nada sobrar, mostra o estado vazio.
7. Tocar em qualquer livro abre `/book/<id>` levando o `Book` (sem nova requisição, como na S07).
8. **Instabilidade da API:** respostas 500, 502, 503 e 504 da Google Books são repetidas automaticamente até 2 vezes, com pausa crescente (0,6 s e 1,2 s), antes de virar erro. Vale para todo o app (Explorar e Detalhes também).

## Interface
Fiel ao protótipo, com textos em pt-BR:

| Protótipo | No app |
|---|---|
| Barra: logo + BookVault + 🔍 | igual (`BrandAppBar`) |
| Good evening, Kelvin + subtítulo | "Boa noite, Gabriel" + "O que vamos ler hoje?" |
| Campo de busca | campo falso "Buscar por título ou autor": tocar leva à aba Explorar |
| Recommended Spotlight | "Destaque para você": cartão com capa, título, autor, 3 linhas da sinopse e o botão "Ver livro" |
| Seção por gênero (ex.: Philosophy) com fileira horizontal de capas | uma fileira por gênero, com o nome do gênero em pt-BR (ex.: "Filosofia") |

- **Destaque:** o primeiro livro do primeiro gênero que tiver livros (sai da fileira desse gênero para não repetir).
- **Carregando:** indicador centralizado abaixo da saudação (a saudação aparece na hora).
- **Vazio:** "Nenhuma recomendação agora" + botão "Explorar livros".
- **"Ver todos"** ao lado de cada gênero: abre a aba Explorar já buscando o nome do gênero (o mesmo que o chip do Explorar faz). O Explorar passa a aceitar o termo pela rota (`/explore?q=<termo>`).
- **🔖 no destaque:** adiciona direto à biblioteca como "Quero ler"; se o livro já estiver salvo, o ícone aparece preenchido e desabilitado.

## Dados
Sem modelo novo. Usa `UserPreferences`, `Genre`, `Book`, `BooksRepository` e a `LibraryStore` (só leitura, para o selo). Pode precisar de um método `BooksRepository.searchBySubject(subject)` que monta `subject:<termo>`.

## Critérios de aceite (viram testes)
- [x] Dado o usuário "Gabriel" às 20h, então vejo "Boa noite, Gabriel" (e "Bom dia"/"Boa tarde" nos outros horários).
- [x] Dados os gêneros Fantasia e Filosofia, então a Home busca por `subject:fantasy` e `subject:philosophy` e mostra o destaque e uma fileira por gênero.
- [x] Dados 5 gêneros escolhidos, então só os 3 primeiros são consultados.
- [x] Dado um livro que aparece em dois gêneros, então ele aparece só uma vez.
- [x] Dada falha de rede em todas as buscas, então vejo o erro em pt-BR e "Tentar de novo" recarrega.
- [x] Dada falha em só um gênero, então os outros gêneros aparecem normalmente.
- [x] Dado um livro recomendado, quando toco nele, então abrem os Detalhes sem nova requisição.
- [x] Dado que troco de aba e volto, então a Home não refaz as buscas.
- [x] Dado "Ver todos" de um gênero, então a aba Explorar abre buscando esse gênero.
- [x] Dado o 🔖 do destaque, então o livro entra na biblioteca como "Quero ler" e o ícone fica marcado.
- [x] Dada uma resposta 503 seguida de 200, então a busca dá certo sem mostrar erro.

## Fora de escopo desta spec
Recomendação por IA (proibida pelo plano), histórico ou "porque você leu X", paginação das fileiras, cache das recomendações entre sessões.

## Decisões do arquiteto
1. Destaque + uma fileira horizontal por gênero, como no protótipo.
2. "Ver todos" leva ao Explorar já buscando o gênero.
3. O 🔖 do destaque salva direto como "Quero ler".
4. Erros 5xx temporários da Google Books ganham até 2 novas tentativas automáticas (503 intermitente visto no emulador em 02/11/2026).

## Notas da implementação
- `RetryInterceptor` em `lib/core/network/` (decisão 4); nos testes a pausa é zero (`fakeDio`).
- `StateMessage` ganhou `actionIcon` e `scrollable: false` para uso dentro de listas que já rolam.
- O `PlaceholderView` saiu: todas as abas têm conteúdo real.
- Conferido no emulador com a chave: saudação, destaque, fileiras de Ficção científica e Filosofia e "Ver todos" abrindo o Explorar com 20 resultados.

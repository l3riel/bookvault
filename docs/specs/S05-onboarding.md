# Spec — Onboarding (Etapa 05)

- **ID:** F1 do `docs/PRD.md` · Etapa 05 do [Plano de Execução](../PLANO.md)
- **Status:** implementada
- **Pastas:** `lib/features/onboarding/`, `lib/stores/onboarding_store.dart`, `lib/models/genre.dart`, `lib/app/router.dart`
- **Referência visual:** [`design/onboarding.png`](../../design/onboarding.png)

## Objetivo
No primeiro acesso, o usuário informa o nome e escolhe um ou mais gêneros; nas próximas vezes o app abre direto no Início.

## Histórias de usuário
- Como novo usuário, quero dizer meu nome e meus gêneros favoritos para receber recomendações do meu gosto.
- Como usuário que já fez o onboarding, quero abrir o app direto no Início.

## Regras de negócio
1. **Gêneros:** lista fixa com os 10 gêneros do protótipo, em `lib/models/genre.dart` (enum `Genre`). Cada um tem rótulo pt-BR e o termo de busca da Google Books, usado na Etapa 08:

   | Chave | Rótulo | Termo (`subject:`) |
   |---|---|---|
   | `science_fiction` | Ficção científica | science fiction |
   | `philosophy` | Filosofia | philosophy |
   | `fantasy` | Fantasia | fantasy |
   | `classics` | Clássicos | classics |
   | `technology` | Tecnologia | technology |
   | `mystery` | Mistério | mystery |
   | `history` | História | history |
   | `fiction` | Ficção | fiction |
   | `thriller` | Suspense | thriller |
   | `biography` | Biografia | biography |

2. `UserPreferences.genres` continua `List<String>` (decisão da S02) e guarda a **chave** do gênero (`'fantasy'`), não o rótulo, para que mudar um texto da interface não estrague dados salvos.
3. **Validação:** nome obrigatório (sem espaços nas pontas, até 40 caracteres) e pelo menos um gênero.
4. Ao confirmar, as preferências são salvas pelo `PreferencesRepository` e o app vai para o Início, sem permitir voltar ao onboarding pelo botão "voltar".
5. **Rota inicial:** o `redirect` do GoRouter consulta o `PreferencesRepository`; sem preferências salvas → `/onboarding`; com preferências → Início. Substitui o `isOnboarded: () => true` provisório da S01.
6. **Estado:** `OnboardingStore` (MobX) com `name`, `selectedGenres`, `canSubmit` (computado), `isSaving` e as ações `setName`, `toggleGenre` e `submit`. A tela só fala com a Store.
7. Arquivos gerados pelo MobX (`*.g.dart`) são versionados (ADR 0002).

## Interface
Fiel ao protótipo, com textos em pt-BR:

| Protótipo | No app |
|---|---|
| PRIVATE COLLECTION | COLEÇÃO PARTICULAR |
| BookVault | BookVault |
| Your private literary sanctuary… | Seu refúgio literário particular. Suas preferências ficam salvas no aparelho para personalizar as recomendações. |
| What should we call you? | Como devemos te chamar? |
| Used to personalize your daily reading feed. | Usado para personalizar suas recomendações. |
| (campo) | placeholder "Seu nome", ícone de livro à esquerda |
| Select your preferred genres | Escolha seus gêneros favoritos |
| 2 selected | 2 selecionados (1 selecionado) |
| Pick one or more… | Escolha um ou mais para montar suas primeiras recomendações. |
| Get Started → | Começar → |
| 🔒 Stored locally on this device | 🔒 Salvo apenas neste aparelho |

- Ícone no topo em quadrado elevado; chips em pílula com ✓ e borda/texto brass quando selecionados (ver `DESIGN.md`, "Filter Chips").
- Botão "Começar" brass, 48px+, com seta. Mostra carregando enquanto salva.
- Tela rolável, respeitando SafeArea e o teclado.

## Dados
Sem modelo novo além do enum `Genre`. Grava `UserPreferences(name, genres: [chaves])` na chave `user.preferences`.

## Critérios de aceite (viram testes)
- [x] Dado o primeiro acesso (sem preferências), quando o app abre, então aparece o onboarding.
- [x] Dadas preferências salvas, quando o app abre, então aparece o Início.
- [x] Dado o onboarding, quando seleciono dois gêneros, então o contador mostra "2 selecionados"; tocar de novo num gênero o desmarca.
- [x] Dado nome vazio (ou só espaços) ou nenhum gênero, então o botão "Começar" fica desabilitado.
- [x] Dado nome "  Gabriel  " e o gênero Fantasia, quando toco em Começar, então é salvo `UserPreferences(name: 'Gabriel', genres: ['fantasy'])` e o app vai para o Início.
- [x] Dado o onboarding concluído, quando o app é reaberto, então abre direto no Início.
- [x] Cada `Genre` tem rótulo pt-BR e termo de busca; `Genre.fromKey` devolve `null` para chave desconhecida.

## Fora de escopo desta spec
Editar nome e gêneros depois (perfil), conteúdo do Início (Etapa 08), animações além do básico do Material.

## Decisões do arquiteto
1. Botão "Começar" desabilitado até haver nome e pelo menos um gênero.
2. Lista de gêneros aprovada como está na tabela.

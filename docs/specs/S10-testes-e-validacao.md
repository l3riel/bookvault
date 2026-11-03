# Spec — Testes e validação (Etapa 10)

- **ID:** Etapa 10 do [Plano de Execução](../PLANO.md)
- **Status:** rascunho
- **Pastas:** `test/`, `docs/`

## Objetivo
Fechar o MVP com evidência: cobrir com teste os comportamentos que ainda não têm, validar os fluxos principais no emulador seguindo um roteiro escrito e marcar a Definition of Done do [PLANO §5](../PLANO.md) item por item.

## Situação de partida (02/11/2026)
- 157 testes passando, `flutter analyze` limpo.
- Cobertura de linhas: **98,1%** (1332/1358, sem os `.g.dart`).
- Todas as camadas do plano já têm teste: modelos, repositórios, persistência, serviço da API, stores e telas.
- A CI (`.github/workflows/ci.yml`) roda format, analyze e test. Só que a `main` local está **78 commits à frente** do GitHub, então as Etapas 05–09 ainda não passaram pela CI.

## Regras
1. **Comportamento sem teste vira teste.** As lacunas encontradas na medição de cobertura:
   - **Biblioteca:** filtro com resultado vazio ("Nenhum livro em X.").
   - **Barra superior:** o botão de busca abre o Explorar.
   - **Fileiras da Home:** livro salvo mostra o selo de status.
   - **Home:** sem gêneros salvos, mostra o estado vazio.
   - **Repositório:** o erro de certificado ou cancelamento é traduzido para `BooksException`.
   - **Modelos:** `==` e `hashCode` coerentes em `UserPreferences` e `UserBook`; `copyWith` de `UserBook` mantendo o status.
2. **`toString` não ganha teste.** É só depuração; perseguir 100% não é meta.
3. **Roteiro manual escrito** em `docs/TESTES-MANUAIS.md`. Cada passo tem o que fazer e o que deve aparecer. Ele cobre os fluxos do §5, o modo avião e o Chrome, e é executado no emulador nesta etapa.
4. **DoD marcada com evidência:** cada item do §5 recebe `[x]` e aponta para o teste ou o passo do roteiro que o comprova.
5. A definição de pronto (`dart format`, `flutter analyze`, `flutter test`) passa em cada commit.

## Critérios de aceite
- [ ] Cada lacuna da regra 1 tem teste e o teste passa.
- [ ] `docs/TESTES-MANUAIS.md` existe e foi executado no emulador, sem exceções no log.
- [ ] Todos os itens do PLANO §5 marcados, cada um com a sua evidência.
- [ ] Format, analyze e test limpos; cobertura registrada nas notas.

## Fora de escopo
Testes de performance, testes de golden (imagem), testes em iOS.

## Decisões para o arquiteto
1. **Lacunas de cobertura:**
   - **a)** Testar só as lacunas de comportamento da regra 1. *(recomendado)*
   - **b)** Perseguir 100% de linhas, incluindo `toString`.
2. **Fluxos de ponta a ponta:**
   - **a)** Roteiro manual executado no emulador, sem pacote novo. *(recomendado)*
   - **b)** Adicionar `integration_test` (vem com o Flutter) com 1 ou 2 fluxos automatizados. Exige uma ADR, como foi com a 0008.
3. **Cobertura:**
   - **a)** Só medir e registrar o número na spec. *(recomendado)*
   - **b)** Fazer a CI falhar abaixo de um mínimo (ex.: 95%).
4. **GitHub:** a `main` tem 78 commits que nunca passaram pela CI.
   - **a)** Ao final, eu faço o push e confiro a CI verde. *(recomendado)*
   - **b)** Você faz o push quando quiser.

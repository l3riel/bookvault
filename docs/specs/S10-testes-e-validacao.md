# Spec — Testes e validação (Etapa 10)

- **ID:** Etapa 10 do [Plano de Execução](../PLANO.md)
- **Status:** implementada
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
2. **Meta de 100% das linhas** (sem os `.g.dart`), incluindo `toString`: um texto de depuração legível também é contrato.
3. **Roteiro manual escrito** em `docs/TESTES-MANUAIS.md`. Cada passo tem o que fazer e o que deve aparecer. Ele cobre os fluxos do §5, o modo avião e o Chrome, e é executado no emulador nesta etapa.
4. **DoD marcada com evidência:** cada item do §5 recebe `[x]` e aponta para o teste ou o passo do roteiro que o comprova.
5. A definição de pronto (`dart format`, `flutter analyze`, `flutter test`) passa em cada commit.

## Critérios de aceite
- [x] Cada lacuna da regra 1 tem teste e o teste passa.
- [x] `docs/TESTES-MANUAIS.md` existe e foi executado no emulador, sem exceções no log.
- [x] Todos os itens do PLANO §5 marcados, cada um com a sua evidência.
- [x] Format, analyze e test limpos; cobertura de 100% registrada nas notas.
- [x] Os commits estão no GitHub e a CI passou.

## Fora de escopo
Testes de performance, testes de golden (imagem), testes em iOS.

## Decisões
Respostas do arquiteto em 02/11/2026: **1b 2a 3a 4a**.
1. Cobertura de 100% das linhas, `toString` incluído.
2. Fluxos de ponta a ponta por roteiro manual no emulador, sem `integration_test`.
3. Cobertura medida e registrada, sem gate na CI.
4. Ao final, a IA faz o push e confere a CI verde.

## Notas da implementação
- **Resultado:** 170 testes (eram 157) e **100% das linhas** cobertas (1358/1358, sem os `.g.dart`). `dart format`, `flutter analyze` e `flutter test` limpos.
- **Testes novos:** igualdade, hash, `copyWith` e `toString` dos modelos; erro de certificado e cancelamento; `toString` do `BooksException`; Home sem gêneros; aviso de filtro vazio na Biblioteca; lupa da barra superior; selo de status na fileira da Home.
- **Roteiro manual:** [TESTES-MANUAIS.md](../TESTES-MANUAIS.md), executado em 02/11/2026 num Pixel 8 (API 36) com instalação limpa. Os blocos A–F passaram, sem exceções no log. O bloco G (Chrome) foi validado na S09, no mesmo dia, e o código web não mudou depois disso.
- **DoD:** todos os itens do [PLANO §5](../PLANO.md) marcados, cada um com a sua evidência.
- **GitHub:** push dos commits; a CI (`41553828431`) passou.
- **Pendência fora do escopo:** a CI avisa que `actions/checkout@v4` usa Node 20, que está descontinuado. Ainda funciona; atualizar para a versão nova é um `ci:` separado.

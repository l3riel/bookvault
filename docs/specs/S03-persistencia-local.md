# Spec — Persistência local (Etapa 03)

- **ID:** Etapa 03 do [Plano de Execução](../PLANO.md) (base de F1 e F2 do `docs/PRD.md`)
- **Status:** rascunho
- **Pastas:** `lib/core/storage/`, `lib/data/repositories/`, `lib/app/app_dependencies.dart`

## Objetivo
Guardar no aparelho a biblioteca e as preferências do usuário, para que sobrevivam ao fechamento do app e funcionem sem internet.

## Histórias de usuário
- Como usuário, quero que os livros que salvei e seus status continuem lá quando eu reabrir o app, mesmo offline.
- Como usuário, quero informar meu nome e meus gêneros uma vez só.

## Regras de negócio
1. `LocalStorage` (`core/storage/local_storage.dart`) é a única classe que usa `SharedPreferences`. Ela lê e grava JSON por chave e não conhece os modelos.
2. `LibraryRepository` (`data/repositories/library_repository.dart`) usa o `LocalStorage` e trabalha só com `Book`, `UserBook` e `ReadingStatus`.
3. A biblioteca é gravada como uma lista JSON de `UserBook` na chave `library.books`; as preferências, na chave `user.preferences`.
4. **Unicidade:** nunca existem dois `UserBook` com o mesmo `book.id`.
5. Ao adicionar um livro, o status inicial é `Quero ler` (ou o informado) e `addedAt` é o momento atual. A hora vem de um relógio injetável, para os testes.
6. A listagem vem ordenada do mais recente para o mais antigo (`addedAt` decrescente).
7. Leituras são síncronas (o `SharedPreferences` já está em memória); gravações são `Future`.
8. `AppDependencies` passa a criar o `LocalStorage` e os repositórios; nenhum widget acessa armazenamento.

## Interface
Nenhuma tela nesta etapa.

## Dados
```text
LocalStorage
  Object? readJson(String key)
  Future<void> writeJson(String key, Object value)
  Future<void> remove(String key)

LibraryRepository
  List<UserBook> getAll()
  UserBook? findById(String bookId)
  bool contains(String bookId)
  Future<UserBook> add(Book book, {ReadingStatus status = ReadingStatus.wantToRead})
  Future<UserBook> updateStatus(String bookId, ReadingStatus status)
  Future<void> remove(String bookId)

PreferencesRepository (ver pendência 1)
  UserPreferences? load()
  Future<void> save(UserPreferences preferences)
```

## Critérios de aceite (viram testes)
- [ ] Dado um livro adicionado, quando o app é reaberto (novo repositório sobre os mesmos dados), então o livro continua na biblioteca com o mesmo status e data.
- [ ] Dado um livro já na biblioteca, quando o adiciono de novo, então a biblioteca continua com um único registro dele.
- [ ] Dado um livro na biblioteca, quando atualizo o status para `Lendo`, então a mudança persiste após reabrir.
- [ ] Dado um livro na biblioteca, quando o removo, então ele some da listagem e não volta após reabrir.
- [ ] Dado um id que não está na biblioteca, quando atualizo o status, então é lançado `StateError`.
- [ ] Dados três livros adicionados em momentos diferentes, quando listo, então vêm do mais recente para o mais antigo.
- [ ] Dadas preferências salvas, quando o app é reaberto, então `load()` devolve o mesmo nome e gêneros; sem preferências salvas, devolve `null`.
- [ ] Nenhum dos testes usa rede (o armazenamento funciona offline por construção).

## Fora de escopo desta spec
Telas de biblioteca e onboarding (Etapas 05 e 06), Stores MobX, API do Google Books.

## Pendências para aprovar
1. **Onde ficam as preferências?** O plano lista só `books_repository` e `library_repository`. Proposta: um `preferences_repository.dart` pequeno em `data/repositories/`, porque preferências não são biblioteca. Alternativa: métodos dentro do `LibraryRepository`, fiel à lista do plano.
2. **Adicionar um livro que já existe:** proposta: devolver o registro existente sem mudar nada (status e data preservados). Alternativa: lançar erro.
3. **Dado salvo corrompido** (ex.: um item com status desconhecido): proposta: ignorar só o item ruim e carregar o resto, para o usuário não perder a biblioteca inteira. Alternativa: lançar erro e não carregar nada, coerente com a decisão da S02.

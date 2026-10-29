# Country Explorer — N2 Faixa 8

**Estudante:** Eduardo Macedo

Explorador de países em Flutter. Os países **não estão cadastrados no código**:
são carregados de uma API externa real ao abrir o app.

## API utilizada

- **apicountries.com** — API pública e gratuita de países (não exige chave),
  no mesmo formato da REST Countries.
- **Endpoint:** `GET https://www.apicountries.com/countries` (lista com os 250 países).
- **Bandeiras:** imagens do `flagcdn.com`, montadas com o código do país
  (ex.: `https://flagcdn.com/w160/br.png`).
- Motivo da escolha: a REST Countries passou a exigir chave de acesso
  (os endpoints públicos `v3.1` foram desativados). O enunciado pede
  "uma API pública de informações sobre países, **como** a REST Countries".

Dados usados: nome (em português), bandeira, capital, região e sub-região,
população, área e idiomas.

## Funcionalidades

- **Tela inicial:** nome e ícone do app, resumo dos dados carregados (total de
  países, países por região, quantidade de favoritos, país visto recentemente),
  botões "Explorar países" e "Meus favoritos".
- **Estados da requisição:** carregando (`CircularProgressIndicator`), dados
  carregados e erro (mensagem + botão "Tentar novamente").
- **Lista** (`ListView.builder`): bandeira, nome e região. Ao tocar, abre os detalhes.
- **Pesquisa** por parte do nome, sem diferenciar maiúsculas e acentos
  ("japao" encontra "Japão"), e **filtro por região** (Américas, Europa, Ásia,
  África, Oceania).
- **Detalhes:** bandeira, nome, capital, região, população, área e idiomas.
- **Favoritos:** coração na lista e nos detalhes. A interface muda na hora, e
  dá para ver só os favoritos (chave "Mostrar somente favoritos" ou botão
  "Meus favoritos"). Ficam em memória enquanto o app está aberto.

## Organização

```
lib/
 ├── main.dart                     # cria o store com o serviço REAL e inicia o app
 ├── app.dart                      # MaterialApp
 ├── models/country.dart           # classe Country + Country.fromJson
 ├── services/country_service.dart # requisição HTTP, endpoint, JSON e erros
 ├── state/country_store.dart      # estado: países, status, favoritos, último visto
 ├── screens/
 │    ├── home_page.dart           # tela inicial
 │    ├── countries_page.dart      # lista + pesquisa + filtros
 │    └── country_details_page.dart# detalhes
 ├── widgets/                      # country_card, country_flag, state_views
 └── utils/country_filters.dart    # filtro, normalização de acentos, formatação
test/                              # testes unitários e de widget
integration_test/app_test.dart     # teste de integração
```

## Onde está cada coisa (para a arguição)

| Pergunta | Onde / como |
|---|---|
| Onde ocorre a requisição HTTP? | `ApiCountryService.fetchCountries()` em `lib/services/country_service.dart` (`_client.get(...)`). |
| Qual endpoint? | `ApiCountryService.endpoint` = `https://www.apicountries.com/countries`. |
| Como a resposta é recebida? | `await _client.get(...)` devolve um `http.Response`; o código confere o `statusCode == 200`. |
| Onde o JSON é convertido? | `jsonDecode(...)` no serviço, e cada item vira objeto em `Country.fromJson` (`lib/models/country.dart`). |
| async e await | `fetchCountries()` e `loadCountries()` são `async` e retornam `Future`. O `await` espera a resposta sem travar a interface; enquanto isso a tela mostra "Carregando". |
| Como os erros são tratados? | No serviço: timeout, falta de conexão, status ≠ 200 e JSON inválido viram `ApiException` com mensagem amigável. O `CountryStore.loadCountries()` captura e muda para `LoadStatus.error`; a `HomePage` mostra o `ErrorView`. |
| Como o estado da tela é atualizado? | `CountryStore` estende `ChangeNotifier` e chama `notifyListeners()`. As telas usam `ListenableBuilder` e se redesenham. Na `CountriesPage`, pesquisa e filtros usam `setState()`. |
| Como os dados chegam aos widgets? | `main.dart` cria o `CountryStore` e passa por construtor: `CountryExplorerApp` → `HomePage` → `CountriesPage` → `CountryDetailsPage`. O `CountryCard` recebe o `Country`. |
| Onde ocorre a navegação? | `Navigator.push` + `MaterialPageRoute` em `home_page.dart` e `countries_page.dart`. `Navigator.pop` no botão "Voltar" dos detalhes. |
| Onde é feito o filtro? | `filterCountries()` em `lib/utils/country_filters.dart`, chamado no `build` da `CountriesPage`. |
| Como funcionam os favoritos? | `Set<String> _favorites` no `CountryStore`, com os códigos dos países (ex.: "BRA"). `toggleFavorite()` adiciona/remove e chama `notifyListeners()`, então o coração muda na hora. |

## Testes (17)

| Tipo | Arquivo | O que verifica |
|---|---|---|
| Unitário | `test/country_test.dart` | Conversão do JSON para `Country`, inclusive com campos ausentes. |
| Unitário | `test/country_filters_test.dart` | Pesquisa (com acentos), filtro por região, filtro de favoritos e formatação da população. |
| Unitário | `test/country_store_test.dart` | Carregamento com sucesso, estado de erro e marcar/desmarcar favoritos. |
| Unitário | `test/country_service_test.dart` | Serviço HTTP com `MockClient`: conversão da resposta, erro HTTP e falha de conexão. |
| Widget | `test/widget_test.dart` | Carregando → resumo, erro + "Tentar novamente", pesquisa atualizando a lista, favorito mudando o ícone e filtro por região. |
| Integração | `integration_test/app_test.dart` | Abrir app → lista → pesquisar → abrir detalhes → conferir dados → favoritar → voltar → conferir favoritos. |

**Diferença entre os tipos:** o unitário testa uma função ou classe isolada,
sem interface. O de widget monta uma parte da interface e simula toques e
digitação. O de integração percorre um fluxo completo do app, de tela em tela.

**Testes x API real:** o app de verdade usa `ApiCountryService` (internet). Os
testes usam `FakeCountryService` (`test/helpers/fake_country_service.dart`), com
4 países simulados, ou `MockClient`. Assim os testes dão sempre o mesmo
resultado e não falham se a API ou a internet estiverem fora do ar.

## Como executar

```bash
flutter pub get
flutter run                                    # com o emulador Android aberto
flutter test                                   # unitários e de widget
flutter test test/country_test.dart            # um teste específico
flutter test integration_test/app_test.dart    # integração (com o emulador aberto)
```

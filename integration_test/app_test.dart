import 'package:country_explorer/app.dart';
import 'package:country_explorer/state/country_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../test/helpers/fake_country_service.dart';

/// Teste de integracao do fluxo principal:
/// abrir o app -> acessar a lista -> pesquisar -> selecionar pais ->
/// abrir detalhes -> verificar informacoes -> favoritar -> conferir favoritos.
///
/// Usa o servico falso para nao depender da API estar no ar.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('fluxo: lista, pesquisa, detalhes e favorito', (tester) async {
    final store = CountryStore(FakeCountryService());
    store.loadCountries();

    // Abrir o aplicativo
    await tester.pumpWidget(CountryExplorerApp(store: store));
    await tester.pumpAndSettle();
    expect(find.text('4 países carregados'), findsOneWidget);

    // Acessar a lista
    await tester.tap(find.byKey(const Key('exploreButton')));
    await tester.pumpAndSettle();
    expect(find.text('4 país(es) encontrado(s)'), findsOneWidget);

    // Pesquisar
    await tester.enterText(find.byKey(const Key('searchField')), 'japao');
    await tester.pumpAndSettle();

    // Selecionar o pais e abrir os detalhes
    await tester.tap(find.text('Japão'));
    await tester.pumpAndSettle();

    // Verificar as informacoes apresentadas
    expect(find.text('Tokyo'), findsOneWidget);
    expect(find.text('125.836.021 habitantes'), findsOneWidget);
    expect(find.text('Japanese'), findsOneWidget);

    // Executar uma acao: favoritar
    await tester.tap(find.byKey(const Key('detailsFavoriteButton')));
    await tester.pumpAndSettle();
    expect(find.text('Japão adicionado aos favoritos.'), findsOneWidget);

    // Voltar ate a tela inicial e conferir o resultado
    await tester.tap(find.text('Voltar'));
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();

    expect(find.text('Favoritos: 1'), findsOneWidget);
    expect(find.text('Visto recentemente'), findsOneWidget);

    await tester.tap(find.byKey(const Key('favoritesButton')));
    await tester.pumpAndSettle();
    expect(find.text('1 país(es) encontrado(s)'), findsOneWidget);
    expect(find.text('Japão'), findsOneWidget);
  });
}

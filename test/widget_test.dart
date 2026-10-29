import 'dart:async';

import 'package:country_explorer/app.dart';
import 'package:country_explorer/screens/countries_page.dart';
import 'package:country_explorer/state/country_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/fake_country_service.dart';

/// Testes de widget: constroem a interface e verificam o comportamento.
void main() {
  testWidgets('mostra carregamento e depois o resumo na tela inicial',
      (tester) async {
    final service = FakeCountryService()..gate = Completer<void>();
    final store = CountryStore(service);
    store.loadCountries();

    await tester.pumpWidget(CountryExplorerApp(store: store));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Carregando países...'), findsOneWidget);

    service.gate!.complete();
    await tester.pumpAndSettle();

    expect(find.text('4 países carregados'), findsOneWidget);
    expect(find.text('Américas: 2 países'), findsOneWidget);
    expect(find.byKey(const Key('exploreButton')), findsOneWidget);
  });

  testWidgets('em caso de erro mostra a mensagem e o botao tentar novamente',
      (tester) async {
    final service = FakeCountryService(fail: true);
    final store = CountryStore(service);
    await store.loadCountries();

    await tester.pumpWidget(CountryExplorerApp(store: store));

    expect(find.text('Nao foi possivel conectar. Verifique sua internet.'),
        findsOneWidget);

    service.fail = false;
    await tester.tap(find.byKey(const Key('retryButton')));
    await tester.pumpAndSettle();

    expect(find.text('4 países carregados'), findsOneWidget);
  });

  testWidgets('a pesquisa atualiza a lista e o favorito muda na hora',
      (tester) async {
    final store = CountryStore(FakeCountryService());
    await store.loadCountries();

    await tester.pumpWidget(MaterialApp(home: CountriesPage(store: store)));

    expect(find.text('4 país(es) encontrado(s)'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('searchField')), 'bra');
    await tester.pump();

    expect(find.text('Brasil'), findsOneWidget);
    expect(find.text('Japão'), findsNothing);
    expect(find.text('1 país(es) encontrado(s)'), findsOneWidget);

    expect(find.byIcon(Icons.favorite_border), findsOneWidget);
    await tester.tap(find.byKey(const Key('favorite_BRA')));
    await tester.pump();

    expect(find.byIcon(Icons.favorite), findsOneWidget);
    expect(store.isFavorite('BRA'), isTrue);
  });

  testWidgets('filtro por regiao mostra apenas os paises da regiao',
      (tester) async {
    final store = CountryStore(FakeCountryService());
    await store.loadCountries();

    await tester.pumpWidget(MaterialApp(home: CountriesPage(store: store)));
    await tester.tap(find.byKey(const Key('region_Europe')));
    await tester.pump();

    expect(find.text('França'), findsOneWidget);
    expect(find.text('Brasil'), findsNothing);
  });
}

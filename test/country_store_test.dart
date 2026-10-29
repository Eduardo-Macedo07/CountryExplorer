import 'package:country_explorer/state/country_store.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/fake_country_service.dart';

/// Testes unitarios do estado do app (carregamento e favoritos).
void main() {
  test('carrega os paises e passa para o estado de sucesso', () async {
    final store = CountryStore(FakeCountryService());

    expect(store.status, LoadStatus.loading);
    await store.loadCountries();

    expect(store.status, LoadStatus.success);
    expect(store.countries.length, 4);
    expect(store.countByRegion('Americas'), 2);
  });

  test('falha da API vira estado de erro com mensagem', () async {
    final store = CountryStore(FakeCountryService(fail: true));

    await store.loadCountries();

    expect(store.status, LoadStatus.error);
    expect(store.errorMessage, contains('Verifique sua internet'));
  });

  test('marca e desmarca favoritos', () async {
    final store = CountryStore(FakeCountryService());
    await store.loadCountries();

    store.toggleFavorite('BRA');
    expect(store.isFavorite('BRA'), isTrue);
    expect(store.favoriteCountries.single.name, 'Brasil');

    store.toggleFavorite('BRA');
    expect(store.isFavorite('BRA'), isFalse);
  });
}

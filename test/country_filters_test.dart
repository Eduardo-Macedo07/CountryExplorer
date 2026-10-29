import 'package:country_explorer/utils/country_filters.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/fake_country_service.dart';

/// Testes unitarios do filtro e da formatacao.
void main() {
  test('pesquisa por parte do nome, ignorando maiusculas e acentos', () {
    final resultado = filterCountries(fakeCountries, query: 'japao');

    expect(resultado.map((c) => c.name), ['Japão']);
    expect(
        filterCountries(fakeCountries, query: 'ARG').single.name, 'Argentina');
    // Tambem encontra pelo nome em ingles.
    expect(
        filterCountries(fakeCountries, query: 'france').single.name, 'França');
  });

  test('filtra por regiao e devolve em ordem alfabetica', () {
    final americas = filterCountries(fakeCountries, region: 'Americas');

    expect(americas.map((c) => c.name), ['Argentina', 'Brasil']);
  });

  test('filtra somente os favoritos', () {
    final favoritos = filterCountries(
      fakeCountries,
      onlyFavorites: true,
      favorites: {'JPN', 'FRA'},
    );

    expect(favoritos.map((c) => c.code), ['FRA', 'JPN']);
  });

  test('formatPopulation separa os milhares com ponto', () {
    expect(formatPopulation(212559409), '212.559.409');
    expect(formatPopulation(1000), '1.000');
    expect(formatPopulation(999), '999');
  });
}

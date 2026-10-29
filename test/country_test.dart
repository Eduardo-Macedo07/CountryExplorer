import 'package:country_explorer/models/country.dart';
import 'package:flutter_test/flutter_test.dart';

/// Teste unitario: conversao do JSON da API para o objeto Country.
void main() {
  test('Country.fromJson converte o JSON da API em um objeto Country', () {
    final json = {
      'name': 'Brazil',
      'alpha2Code': 'BR',
      'alpha3Code': 'BRA',
      'capital': 'Brasília',
      'region': 'Americas',
      'subregion': 'South America',
      'population': 212559409,
      'area': 8515767.0,
      'flag': '🇧🇷',
      'languages': [
        {'name': 'Portuguese', 'iso639_1': 'pt'},
      ],
      'translations': {'pt': 'Brasil', 'es': 'Brasil'},
    };

    final country = Country.fromJson(json);

    expect(country.code, 'BRA');
    expect(country.name, 'Brasil');
    expect(country.englishName, 'Brazil');
    expect(country.capital, 'Brasília');
    expect(country.region, 'Americas');
    expect(country.population, 212559409);
    expect(country.languages, ['Portuguese']);
    expect(country.flagUrl, 'https://flagcdn.com/w160/br.png');
  });

  test('Country.fromJson trata campos ausentes', () {
    final json = {
      'name': 'Antarctica',
      'alpha3Code': 'ATA',
      'region': 'Polar',
      'population': 1000,
    };

    final country = Country.fromJson(json);

    // Sem traducao, usa o nome em ingles; sem capital e idiomas, fica vazio.
    expect(country.name, 'Antarctica');
    expect(country.capital, isNull);
    expect(country.languages, isEmpty);
    expect(country.flagUrl, isNull);
  });
}

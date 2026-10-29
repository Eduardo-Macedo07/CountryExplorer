import 'dart:async';

import 'package:country_explorer/models/country.dart';
import 'package:country_explorer/services/country_service.dart';

/// Dados simulados: sempre os mesmos, para os testes serem previsiveis.
const fakeCountries = [
  Country(
    code: 'BRA',
    name: 'Brasil',
    englishName: 'Brazil',
    capital: 'Brasília',
    region: 'Americas',
    subregion: 'South America',
    population: 212559409,
    area: 8515767,
    languages: ['Portuguese'],
    flagEmoji: '🇧🇷',
  ),
  Country(
    code: 'JPN',
    name: 'Japão',
    englishName: 'Japan',
    capital: 'Tokyo',
    region: 'Asia',
    subregion: 'Eastern Asia',
    population: 125836021,
    languages: ['Japanese'],
    flagEmoji: '🇯🇵',
  ),
  Country(
    code: 'ARG',
    name: 'Argentina',
    englishName: 'Argentina',
    capital: 'Buenos Aires',
    region: 'Americas',
    population: 45376763,
    languages: ['Spanish', 'Guaraní'],
    flagEmoji: '🇦🇷',
  ),
  Country(
    code: 'FRA',
    name: 'França',
    englishName: 'France',
    capital: 'Paris',
    region: 'Europe',
    population: 67391582,
    languages: ['French'],
    flagEmoji: '🇫🇷',
  ),
];

/// Servico falso: mesmo contrato do servico real, mas sem internet.
class FakeCountryService implements CountryService {
  FakeCountryService({this.fail = false});

  /// Quando true, simula falha da API.
  bool fail;

  /// Quando definido, a resposta so chega quando o teste completar o Completer.
  Completer<void>? gate;

  int calls = 0;

  @override
  Future<List<Country>> fetchCountries() async {
    calls++;
    if (gate != null) await gate!.future;
    if (fail) {
      throw const ApiException(
          'Nao foi possivel conectar. Verifique sua internet.');
    }
    return fakeCountries;
  }
}

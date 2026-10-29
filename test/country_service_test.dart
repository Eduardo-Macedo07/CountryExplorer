import 'dart:convert';

import 'package:country_explorer/services/country_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

/// Testa o servico real usando um cliente HTTP falso (MockClient):
/// nenhuma requisicao vai para a internet.
void main() {
  test('converte a resposta da API em uma lista de Country', () async {
    final client = MockClient((request) async {
      expect(request.url.toString(), ApiCountryService.endpoint);
      return http.Response.bytes(
        utf8.encode(jsonEncode([
          {
            'name': 'Japan',
            'alpha2Code': 'JP',
            'alpha3Code': 'JPN',
            'region': 'Asia',
            'population': 125836021,
            'translations': {'pt': 'Japão'},
          },
        ])),
        200,
      );
    });

    final paises = await ApiCountryService(client: client).fetchCountries();

    expect(paises.single.name, 'Japão');
  });

  test('erro HTTP vira ApiException', () async {
    final client = MockClient((_) async => http.Response('erro', 500));

    expect(
      ApiCountryService(client: client).fetchCountries(),
      throwsA(isA<ApiException>()),
    );
  });

  test('falha de conexao vira ApiException com mensagem amigavel', () async {
    final client = MockClient((_) async => throw http.ClientException('off'));

    expect(
      ApiCountryService(client: client).fetchCountries(),
      throwsA(isA<ApiException>()
          .having((e) => e.message, 'message', contains('conectar'))),
    );
  });
}

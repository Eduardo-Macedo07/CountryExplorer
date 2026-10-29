import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/country.dart';

/// Contrato do servico de paises.
///
/// O app usa ApiCountryService (API real). Os testes usam um servico falso
/// com dados simulados, para nao depender da internet.
abstract class CountryService {
  Future<List<Country>> fetchCountries();
}

/// Erro com mensagem amigavel para mostrar ao usuario.
class ApiException implements Exception {
  const ApiException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Implementacao real: API publica apicountries.com (nao exige chave).
class ApiCountryService implements CountryService {
  ApiCountryService({http.Client? client}) : _client = client ?? http.Client();

  /// Endpoint utilizado: devolve todos os paises em uma lista JSON.
  static const endpoint = 'https://www.apicountries.com/countries';

  final http.Client _client;

  @override
  Future<List<Country>> fetchCountries() async {
    final http.Response response;

    // 1. Requisicao HTTP (assincrona: o await espera a resposta sem travar a tela).
    try {
      response = await _client
          .get(Uri.parse(endpoint))
          .timeout(const Duration(seconds: 15));
    } on TimeoutException {
      throw const ApiException(
          'O servidor demorou para responder. Tente novamente.');
    } catch (_) {
      throw const ApiException(
          'Nao foi possivel conectar. Verifique sua internet.');
    }

    // 2. Verifica se a resposta foi bem-sucedida.
    if (response.statusCode != 200) {
      throw ApiException(
          'Erro ao consultar a API (codigo ${response.statusCode}).');
    }

    // 3. Converte o texto JSON em objetos Dart.
    try {
      final dados = jsonDecode(utf8.decode(response.bodyBytes));
      if (dados is! List) {
        throw const FormatException('Era esperada uma lista.');
      }
      return dados
          .map((item) => Country.fromJson(item as Map<String, dynamic>))
          .toList();
    } on FormatException {
      throw const ApiException('A API retornou dados em formato invalido.');
    }
  }
}

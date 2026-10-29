import 'package:flutter/foundation.dart';

import '../models/country.dart';
import '../services/country_service.dart';

/// Estados possiveis do carregamento dos dados.
enum LoadStatus { loading, success, error }

/// Estado compartilhado do app: paises carregados, favoritos e ultimo pais
/// visto. Ao mudar, chama notifyListeners() e as telas que escutam
/// (ListenableBuilder) sao redesenhadas.
class CountryStore extends ChangeNotifier {
  CountryStore(this._service);

  final CountryService _service;

  LoadStatus status = LoadStatus.loading;
  String errorMessage = '';
  List<Country> countries = [];
  Country? lastViewed;

  /// Codigos (ex.: "BRA") dos paises favoritos. Ficam so em memoria.
  final Set<String> _favorites = {};

  Set<String> get favorites => Set.unmodifiable(_favorites);

  /// Busca os paises na API e atualiza o estado: carregando -> sucesso/erro.
  Future<void> loadCountries() async {
    status = LoadStatus.loading;
    notifyListeners();

    try {
      countries = await _service.fetchCountries();
      status = LoadStatus.success;
    } on ApiException catch (e) {
      errorMessage = e.message;
      status = LoadStatus.error;
    } catch (_) {
      errorMessage = 'Ocorreu um erro inesperado.';
      status = LoadStatus.error;
    }
    notifyListeners();
  }

  bool isFavorite(String code) => _favorites.contains(code);

  /// Marca ou desmarca um pais como favorito.
  void toggleFavorite(String code) {
    if (!_favorites.remove(code)) _favorites.add(code);
    notifyListeners();
  }

  List<Country> get favoriteCountries =>
      countries.where((c) => _favorites.contains(c.code)).toList();

  void markViewed(Country country) {
    lastViewed = country;
    notifyListeners();
  }

  /// Quantidade de paises de uma regiao (usado no resumo da tela inicial).
  int countByRegion(String region) =>
      countries.where((c) => c.region == region).length;
}

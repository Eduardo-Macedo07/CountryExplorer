import 'package:flutter/material.dart';

import 'app.dart';
import 'services/country_service.dart';
import 'state/country_store.dart';

void main() {
  // No app real, o store usa o servico que acessa a API externa.
  final store = CountryStore(ApiCountryService())..loadCountries();

  runApp(CountryExplorerApp(store: store));
}

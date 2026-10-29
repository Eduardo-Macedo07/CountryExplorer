import 'package:flutter/material.dart';

import 'screens/home_page.dart';
import 'state/country_store.dart';

/// Raiz do aplicativo. Recebe o CountryStore por parametro:
/// no app real ele usa a API; nos testes, um servico falso.
class CountryExplorerApp extends StatelessWidget {
  const CountryExplorerApp({super.key, required this.store});

  final CountryStore store;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Country Explorer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.teal,
        useMaterial3: true,
      ),
      home: HomePage(store: store),
    );
  }
}

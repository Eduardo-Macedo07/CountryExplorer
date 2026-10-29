import 'package:flutter/material.dart';

import '../state/country_store.dart';
import '../utils/country_filters.dart';
import '../widgets/country_flag.dart';
import '../widgets/state_views.dart';
import 'countries_page.dart';
import 'country_details_page.dart';

/// Tela inicial: identificacao do app, resumo dos dados carregados
/// e acesso a lista de paises e aos favoritos.
class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.store});

  final CountryStore store;

  void _openCountries(BuildContext context, {bool onlyFavorites = false}) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) =>
            CountriesPage(store: store, onlyFavorites: onlyFavorites),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Country Explorer')),
      body: SafeArea(
        // Reconstroi a tela sempre que o CountryStore notificar mudancas.
        child: ListenableBuilder(
          listenable: store,
          builder: (context, _) {
            switch (store.status) {
              case LoadStatus.loading:
                return const LoadingView();
              case LoadStatus.error:
                return ErrorView(
                  message: store.errorMessage,
                  onRetry: store.loadCountries,
                );
              case LoadStatus.success:
                return _buildSummary(context);
            }
          },
        ),
      ),
    );
  }

  Widget _buildSummary(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    final ultimo = store.lastViewed;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Center(child: Icon(Icons.public, size: 72, color: colors.primary)),
        const SizedBox(height: 8),
        Center(child: Text('Country Explorer', style: textTheme.headlineSmall)),
        const Center(child: Text('Explore os países do mundo')),
        const SizedBox(height: 20),
        Card(
          color: colors.primaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${store.countries.length} países carregados',
                  key: const Key('totalCountries'),
                  style: textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                ...regionLabels.entries.map(
                  (regiao) => Text(
                      '${regiao.value}: ${store.countByRegion(regiao.key)} países'),
                ),
                const SizedBox(height: 8),
                Text('Favoritos: ${store.favorites.length}',
                    key: const Key('favoritesCount')),
              ],
            ),
          ),
        ),
        if (ultimo != null)
          Card(
            child: ListTile(
              leading: CountryFlag(country: ultimo, width: 44),
              title: const Text('Visto recentemente'),
              subtitle: Text(ultimo.name),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) =>
                      CountryDetailsPage(store: store, country: ultimo),
                ),
              ),
            ),
          ),
        const SizedBox(height: 16),
        FilledButton.icon(
          key: const Key('exploreButton'),
          onPressed: () => _openCountries(context),
          icon: const Icon(Icons.travel_explore),
          label: const Text('Explorar países'),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          key: const Key('favoritesButton'),
          onPressed: () => _openCountries(context, onlyFavorites: true),
          icon: const Icon(Icons.favorite),
          label: const Text('Meus favoritos'),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

import '../models/country.dart';
import '../state/country_store.dart';
import '../utils/country_filters.dart';
import '../widgets/country_card.dart';
import 'country_details_page.dart';

/// Lista de paises com pesquisa por nome, filtro por regiao e por favoritos.
class CountriesPage extends StatefulWidget {
  const CountriesPage({
    super.key,
    required this.store,
    this.onlyFavorites = false,
  });

  final CountryStore store;
  final bool onlyFavorites;

  @override
  State<CountriesPage> createState() => _CountriesPageState();
}

class _CountriesPageState extends State<CountriesPage> {
  final _searchController = TextEditingController();
  String? _region;
  late bool _onlyFavorites = widget.onlyFavorites;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openDetails(Country country) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) =>
            CountryDetailsPage(store: widget.store, country: country),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_onlyFavorites ? 'Meus favoritos' : 'Países'),
      ),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: widget.store,
          builder: (context, _) {
            final store = widget.store;
            final visiveis = filterCountries(
              store.countries,
              query: _searchController.text,
              region: _region,
              onlyFavorites: _onlyFavorites,
              favorites: store.favorites,
            );

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: TextField(
                    key: const Key('searchField'),
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      labelText: 'Pesquisar país',
                      hintText: 'Ex.: Brasil, Japão, Canadá',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 52,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: ChoiceChip(
                          label: const Text('Todas'),
                          selected: _region == null,
                          onSelected: (_) => setState(() => _region = null),
                        ),
                      ),
                      ...regionLabels.entries.map(
                        (regiao) => Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: ChoiceChip(
                            key: Key('region_${regiao.key}'),
                            label: Text(regiao.value),
                            selected: _region == regiao.key,
                            onSelected: (_) =>
                                setState(() => _region = regiao.key),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SwitchListTile(
                  key: const Key('onlyFavoritesSwitch'),
                  dense: true,
                  title: const Text('Mostrar somente favoritos'),
                  value: _onlyFavorites,
                  onChanged: (valor) => setState(() => _onlyFavorites = valor),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('${visiveis.length} país(es) encontrado(s)',
                        key: const Key('resultCount')),
                  ),
                ),
                Expanded(
                  child: visiveis.isEmpty
                      ? Center(
                          child: Text(
                            _onlyFavorites && store.favorites.isEmpty
                                ? 'Você ainda não tem favoritos.'
                                : 'Nenhum país encontrado.',
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: visiveis.length,
                          itemBuilder: (context, index) {
                            final country = visiveis[index];
                            return CountryCard(
                              key: Key('country_${country.code}'),
                              country: country,
                              isFavorite: store.isFavorite(country.code),
                              onTap: () => _openDetails(country),
                              onFavoriteToggle: () =>
                                  store.toggleFavorite(country.code),
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../models/country.dart';
import '../state/country_store.dart';
import '../utils/country_filters.dart';
import '../widgets/country_flag.dart';

/// Detalhes do pais selecionado (dados vindos do objeto Country da API).
class CountryDetailsPage extends StatefulWidget {
  const CountryDetailsPage({
    super.key,
    required this.store,
    required this.country,
  });

  final CountryStore store;
  final Country country;

  @override
  State<CountryDetailsPage> createState() => _CountryDetailsPageState();
}

class _CountryDetailsPageState extends State<CountryDetailsPage> {
  @override
  void initState() {
    super.initState();
    // Registra o pais como "visto recentemente" (aparece na tela inicial).
    // Feito apos o primeiro frame para nao notificar durante o build.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.store.markViewed(widget.country);
    });
  }

  @override
  Widget build(BuildContext context) {
    final country = widget.country;
    final store = widget.store;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(country.name),
        actions: [
          ListenableBuilder(
            listenable: store,
            builder: (context, _) {
              final favorito = store.isFavorite(country.code);
              return IconButton(
                key: const Key('detailsFavoriteButton'),
                tooltip: favorito ? 'Remover dos favoritos' : 'Favoritar',
                onPressed: () {
                  store.toggleFavorite(country.code);
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(SnackBar(
                      content: Text(favorito
                          ? '${country.name} removido dos favoritos.'
                          : '${country.name} adicionado aos favoritos.'),
                    ));
                },
                icon: Icon(
                  favorito ? Icons.favorite : Icons.favorite_border,
                  color: favorito ? Colors.red : null,
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Center(child: CountryFlag(country: country, width: 220)),
            const SizedBox(height: 16),
            Center(child: Text(country.name, style: textTheme.headlineSmall)),
            if (country.englishName != country.name)
              Center(child: Text(country.englishName)),
            const SizedBox(height: 16),
            _InfoTile(
              icon: Icons.location_city,
              label: 'Capital',
              value: country.capital ?? 'Não possui',
            ),
            _InfoTile(
              icon: Icons.public,
              label: 'Região',
              value: country.subregion == null
                  ? regionLabel(country.region)
                  : '${regionLabel(country.region)} (${country.subregion})',
            ),
            _InfoTile(
              icon: Icons.groups,
              label: 'População',
              value: '${formatPopulation(country.population)} habitantes',
            ),
            if (country.area != null)
              _InfoTile(
                icon: Icons.straighten,
                label: 'Área',
                value: '${formatPopulation(country.area!.round())} km²',
              ),
            _InfoTile(
              icon: Icons.translate,
              label: 'Idiomas',
              value: country.languages.isEmpty
                  ? 'Não informado'
                  : country.languages.join(', '),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Voltar'),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(label),
        subtitle: Text(value),
      ),
    );
  }
}

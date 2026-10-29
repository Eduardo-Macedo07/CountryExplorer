import 'package:flutter/material.dart';

import '../models/country.dart';
import '../utils/country_filters.dart';
import 'country_flag.dart';

/// Item da lista: bandeira, nome, regiao e botao de favorito.
class CountryCard extends StatelessWidget {
  const CountryCard({
    super.key,
    required this.country,
    required this.isFavorite,
    required this.onTap,
    required this.onFavoriteToggle,
  });

  final Country country;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: CountryFlag(country: country, width: 48),
        title: Text(country.name),
        subtitle: Text(regionLabel(country.region)),
        trailing: IconButton(
          key: Key('favorite_${country.code}'),
          tooltip: isFavorite ? 'Remover dos favoritos' : 'Favoritar',
          onPressed: onFavoriteToggle,
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.red : null,
          ),
        ),
      ),
    );
  }
}

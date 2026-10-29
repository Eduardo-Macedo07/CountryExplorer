import 'package:flutter/material.dart';

import '../models/country.dart';

/// Bandeira do pais. Se a imagem nao carregar, mostra o emoji da bandeira.
class CountryFlag extends StatelessWidget {
  const CountryFlag({super.key, required this.country, this.width = 56});

  final Country country;
  final double width;

  @override
  Widget build(BuildContext context) {
    final height = width * 2 / 3;
    final reserva = SizedBox(
      width: width,
      height: height,
      child: Center(
        child: Text(
          country.flagEmoji.isEmpty ? '🏳️' : country.flagEmoji,
          style: TextStyle(fontSize: height * 0.7),
        ),
      ),
    );

    if (country.flagUrl == null) return reserva;

    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Image.network(
        country.flagUrl!,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => reserva,
      ),
    );
  }
}

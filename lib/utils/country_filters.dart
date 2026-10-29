import '../models/country.dart';

/// Regioes usadas nos filtros, com o nome em portugues.
const regionLabels = {
  'Americas': 'Américas',
  'Europe': 'Europa',
  'Asia': 'Ásia',
  'Africa': 'África',
  'Oceania': 'Oceania',
};

/// Nome da regiao em portugues (as regioes polares viram "Antártida").
String regionLabel(String region) {
  if (regionLabels.containsKey(region)) return regionLabels[region]!;
  if (region.startsWith('Antarctic') || region == 'Polar') return 'Antártida';
  return region;
}

/// Deixa o texto em minusculas e sem acentos, para que "japao" encontre "Japão".
String normalize(String texto) {
  const comAcento = 'áàâãäéèêëíìîïóòôõöúùûüçñ';
  const semAcento = 'aaaaaeeeeiiiiooooouuuucn';
  final buffer = StringBuffer();
  for (final letra in texto.toLowerCase().split('')) {
    final i = comAcento.indexOf(letra);
    buffer.write(i >= 0 ? semAcento[i] : letra);
  }
  return buffer.toString().trim();
}

/// Aplica a pesquisa por nome, o filtro de regiao e o filtro de favoritos.
/// Devolve uma nova lista em ordem alfabetica.
List<Country> filterCountries(
  List<Country> countries, {
  String query = '',
  String? region,
  bool onlyFavorites = false,
  Set<String> favorites = const {},
}) {
  final busca = normalize(query);

  final resultado = countries.where((country) {
    final atendeBusca = busca.isEmpty ||
        normalize(country.name).contains(busca) ||
        normalize(country.englishName).contains(busca);
    final atendeRegiao = region == null || country.region == region;
    final atendeFavorito = !onlyFavorites || favorites.contains(country.code);
    return atendeBusca && atendeRegiao && atendeFavorito;
  }).toList();

  resultado.sort((a, b) => normalize(a.name).compareTo(normalize(b.name)));
  return resultado;
}

/// Formata a populacao com pontos: 212559409 -> "212.559.409".
String formatPopulation(int valor) {
  final digitos = valor.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digitos.length; i++) {
    if (i > 0 && (digitos.length - i) % 3 == 0) buffer.write('.');
    buffer.write(digitos[i]);
  }
  return buffer.toString();
}

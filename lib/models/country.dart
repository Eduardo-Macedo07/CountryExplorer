/// Representa um pais recebido da API.
class Country {
  const Country({
    required this.code,
    required this.name,
    required this.englishName,
    required this.region,
    required this.population,
    required this.languages,
    this.capital,
    this.subregion,
    this.area,
    this.flagUrl,
    this.flagEmoji = '',
  });

  /// Codigo de 3 letras (ex.: "BRA"). Usado como identificador unico.
  final String code;

  /// Nome em portugues (ou em ingles, se nao houver traducao).
  final String name;
  final String englishName;
  final String? capital;
  final String region;
  final String? subregion;
  final int population;
  final double? area;
  final List<String> languages;
  final String? flagUrl;
  final String flagEmoji;

  /// Cria um Country a partir de um item do JSON da API.
  ///
  /// Exemplo do JSON recebido (resumido):
  /// {"name": "Brazil", "alpha2Code": "BR", "alpha3Code": "BRA",
  ///  "capital": "Brasília", "region": "Americas", "population": 212559409,
  ///  "languages": [{"name": "Portuguese"}], "translations": {"pt": "Brasil"},
  ///  "flag": "🇧🇷"}
  factory Country.fromJson(Map<String, dynamic> json) {
    final englishName = json['name'] as String? ?? 'Desconhecido';
    final translations = json['translations'] as Map<String, dynamic>?;
    final alpha2 = json['alpha2Code'] as String?;
    final capital = json['capital'] as String?;

    return Country(
      code: json['alpha3Code'] as String? ?? englishName,
      name: translations?['pt'] as String? ?? englishName,
      englishName: englishName,
      capital: (capital == null || capital.isEmpty) ? null : capital,
      region: json['region'] as String? ?? 'Desconhecida',
      subregion: json['subregion'] as String?,
      population: (json['population'] as num?)?.toInt() ?? 0,
      area: (json['area'] as num?)?.toDouble(),
      languages: (json['languages'] as List<dynamic>? ?? [])
          .map((idioma) => (idioma as Map<String, dynamic>)['name'] as String)
          .toList(),
      // Imagem da bandeira montada a partir do codigo de 2 letras.
      flagUrl: alpha2 == null
          ? null
          : 'https://flagcdn.com/w160/${alpha2.toLowerCase()}.png',
      flagEmoji: json['flag'] as String? ?? '',
    );
  }
}

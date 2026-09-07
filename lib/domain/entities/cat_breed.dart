class CatBreed {
  const CatBreed({
    required this.id,
    required this.name,
    required this.speciesId,
    required this.lifeSpan,
    required this.temperament,
    required this.origin,
    required this.countryCodes,
    required this.countryCode,
    required this.description,
    required this.bredFor,
    required this.perfectFor,
    required this.breedGroup,
    required this.history,
    required this.referenceImageId,
    required this.weight,
    required this.height,
    required this.image,
  });

  final String id;
  final String name;
  final String? speciesId;
  final String lifeSpan;
  final String temperament;
  final String origin;
  final String? countryCodes;
  final String? countryCode;
  final String description;
  final String? bredFor;
  final String? perfectFor;
  final String? breedGroup;
  final String? history;
  final String? referenceImageId;
  final Measurement weight;
  final Measurement height;
  final CatImage? image;
}

class Measurement {
  const Measurement({required this.imperial, required this.metric});
  final String imperial;
  final String metric;
}

class CatImage {
  const CatImage({
    required this.id,
    required this.url,
    required this.width,
    required this.height,
  });
  final String id;
  final String url;
  final int width;
  final int height;
}

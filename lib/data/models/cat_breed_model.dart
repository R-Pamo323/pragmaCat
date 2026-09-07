import '../../domain/entities/cat_breed.dart';

class CatBreedModel {
  const CatBreedModel({
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
  final MeasurementModel weight;
  final MeasurementModel height;
  final CatImageModel? image;

  factory CatBreedModel.fromJson(Map<String, dynamic> json) {
    return CatBreedModel(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      speciesId: json['species_id'] as String?,
      lifeSpan: json['life_span'] as String? ?? '',
      temperament: json['temperament'] as String? ?? '',
      origin: json['origin'] as String? ?? 'Unknown',
      countryCodes: json['country_codes'] as String?,
      countryCode: json['country_code'] as String?,
      description: json['description'] as String? ?? '',
      bredFor: json['bred_for']?.toString(),
      perfectFor: json['perfect_for']?.toString(),
      breedGroup: json['breed_group'] as String?,
      history: json['history'] as String?,
      referenceImageId: json['reference_image_id'] as String?,
      weight: json['weight'] == null
          ? const MeasurementModel(imperial: '', metric: '')
          : MeasurementModel.fromJson(json['weight'] as Map<String, dynamic>),
      height: json['height'] == null
          ? const MeasurementModel(imperial: '', metric: '')
          : MeasurementModel.fromJson(json['height'] as Map<String, dynamic>),
      image: json['image'] == null
          ? null
          : CatImageModel.fromJson(json['image'] as Map<String, dynamic>),
    );
  }

  CatBreed toEntity() {
    return CatBreed(
      id: id,
      name: name,
      speciesId: speciesId,
      lifeSpan: lifeSpan,
      temperament: temperament,
      origin: origin,
      countryCodes: countryCodes,
      countryCode: countryCode,
      description: description,
      bredFor: bredFor,
      perfectFor: perfectFor,
      breedGroup: breedGroup,
      history: history,
      referenceImageId: referenceImageId,
      weight: weight.toEntity(),
      height: height.toEntity(),
      image: image?.toEntity(),
    );
  }
}

class MeasurementModel {
  const MeasurementModel({required this.imperial, required this.metric});

  final String imperial;
  final String metric;

  factory MeasurementModel.fromJson(Map<String, dynamic> json) {
    return MeasurementModel(
      imperial: json['imperial'] as String? ?? '',
      metric: json['metric'] as String? ?? '',
    );
  }

  Measurement toEntity() => Measurement(imperial: imperial, metric: metric);
}

class CatImageModel {
  const CatImageModel({
    required this.id,
    required this.url,
    required this.width,
    required this.height,
  });

  final String id;
  final String url;
  final int width;
  final int height;

  factory CatImageModel.fromJson(Map<String, dynamic> json) {
    return CatImageModel(
      id: json['id'] as String? ?? '',
      url: json['url'] as String? ?? '',
      width: (json['width'] as num?)?.toInt() ?? 0,
      height: (json['height'] as num?)?.toInt() ?? 0,
    );
  }

  CatImage toEntity() =>
      CatImage(id: id, url: url, width: width, height: height);
}

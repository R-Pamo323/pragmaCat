import '../../core/constants/api_constants.dart';
import '../../core/errors/app_exception.dart';
import '../../core/network/dio_client.dart';
import '../models/cat_breed_model.dart';

class CatRemoteDataSource {
  const CatRemoteDataSource(this._dioClient);

  final DioClient _dioClient;

  Future<List<CatBreedModel>> getBreeds({
    required int page,
    required int limit,
  }) async {
    final dynamic data = await _dioClient.get(
      ApiConstants.breedsEndpoint,
      queryParameters: {'page': page, 'limit': limit},
    );

    if (data is! List) {
      throw const InvalidResponseException();
    }

    return data
        .whereType<Map<String, dynamic>>()
        .map(CatBreedModel.fromJson)
        .toList();
  }

  Future<List<CatBreedModel>> searchBreeds(String query) async {
    final dynamic data = await _dioClient.get(
      '${ApiConstants.breedsEndpoint}/search',
      queryParameters: {'q': query},
    );

    if (data is! List) {
      throw const InvalidResponseException();
    }

    return data
        .whereType<Map<String, dynamic>>()
        .map(CatBreedModel.fromJson)
        .toList();
  }
}

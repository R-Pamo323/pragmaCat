import '../entities/cat_breed.dart';
import '../../core/errors/app_exception.dart';

abstract interface class CatRepository {
  Future<Result<List<CatBreed>>> getBreeds({
    required int page,
    required int limit,
  });

  Future<Result<List<CatBreed>>> searchBreeds(String query);
}

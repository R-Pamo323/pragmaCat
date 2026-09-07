import '../../core/errors/app_exception.dart';
import '../entities/cat_breed.dart';
import '../repositories/cat_repository.dart';

class GetCatBreeds {
  const GetCatBreeds(this._repository);

  final CatRepository _repository;

  Future<Result<List<CatBreed>>> call({required int page, required int limit}) {
    return _repository.getBreeds(page: page, limit: limit);
  }
}

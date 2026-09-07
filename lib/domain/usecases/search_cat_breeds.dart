import '../../core/errors/app_exception.dart';
import '../entities/cat_breed.dart';
import '../repositories/cat_repository.dart';

class SearchCatBreeds {
  const SearchCatBreeds(this._repository);

  final CatRepository _repository;

  Future<Result<List<CatBreed>>> call(String query) {
    return _repository.searchBreeds(query);
  }
}

import '../../core/errors/app_exception.dart';
import '../../domain/entities/cat_breed.dart';
import '../../domain/repositories/cat_repository.dart';
import '../datasources/cat_remote_data_source.dart';

class CatRepositoryImpl implements CatRepository {
  const CatRepositoryImpl(this._remoteDataSource);

  final CatRemoteDataSource _remoteDataSource;

  @override
  Future<Result<List<CatBreed>>> getBreeds({
    required int page,
    required int limit,
  }) async {
    try {
      final models = await _remoteDataSource.getBreeds(
        page: page,
        limit: limit,
      );
      return Success(models.map((model) => model.toEntity()).toList());
    } on AppException catch (exception) {
      return Failure(exception);
    }
  }

  @override
  Future<Result<List<CatBreed>>> searchBreeds(String query) async {
    try {
      final models = await _remoteDataSource.searchBreeds(query);
      return Success(models.map((model) => model.toEntity()).toList());
    } on AppException catch (exception) {
      return Failure(exception);
    }
  }
}

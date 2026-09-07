import 'core/network/dio_client.dart';
import 'data/datasources/cat_remote_data_source.dart';
import 'data/repositories/cat_repository_impl.dart';
import 'domain/repositories/cat_repository.dart';
import 'domain/usecases/get_cat_breeds.dart';
import 'domain/usecases/search_cat_breeds.dart';

class InjectionContainer {
  const InjectionContainer._internal();

  static final DioClient dioClient = DioClient();
  static final CatRemoteDataSource remoteDataSource = CatRemoteDataSource(
    dioClient,
  );
  static final CatRepository catRepository = CatRepositoryImpl(
    remoteDataSource,
  );
  static final GetCatBreeds getCatBreeds = GetCatBreeds(catRepository);
  static final SearchCatBreeds searchCatBreeds = SearchCatBreeds(catRepository);
}

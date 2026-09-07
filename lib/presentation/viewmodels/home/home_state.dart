import '../../../domain/entities/cat_breed.dart';

enum HomeStatus { initial, loading, loaded, loadingMore, error }

class HomeState {
  const HomeState({
    this.status = HomeStatus.initial,
    this.breeds = const [],
    this.filteredBreeds = const [],
    this.currentPage = 0,
    this.hasReachedEnd = false,
    this.searchQuery = '',
    this.errorMessage,
  });

  final HomeStatus status;
  final List<CatBreed> breeds;
  final List<CatBreed> filteredBreeds;
  final int currentPage;
  final bool hasReachedEnd;
  final String searchQuery;
  final String? errorMessage;

  bool get isLoadingMore => status == HomeStatus.loadingMore;

  bool get isInitialLoading =>
      status == HomeStatus.loading || status == HomeStatus.initial;

  HomeState copyWith({
    HomeStatus? status,
    List<CatBreed>? breeds,
    List<CatBreed>? filteredBreeds,
    int? currentPage,
    bool? hasReachedEnd,
    String? searchQuery,
    String? errorMessage,
    bool clearError = false,
  }) {
    return HomeState(
      status: status ?? this.status,
      breeds: breeds ?? this.breeds,
      filteredBreeds: filteredBreeds ?? this.filteredBreeds,
      currentPage: currentPage ?? this.currentPage,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

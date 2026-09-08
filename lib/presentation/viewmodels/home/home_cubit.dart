import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pragma_cat/domain/usecases/search_cat_breeds.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/errors/app_exception.dart';

import '../../../domain/entities/cat_breed.dart';
import '../../../domain/usecases/get_cat_breeds.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._getCatBreeds, this._searchCatBreeds)
    : super(const HomeState()) {
    loadInitial();
  }

  final GetCatBreeds _getCatBreeds;
  final SearchCatBreeds _searchCatBreeds;

  Timer? _debounce;

  Future<void> loadInitial() async {
    emit(state.copyWith(status: HomeStatus.loading, clearError: true));

    final result = await _getCatBreeds(
      page: ApiConstants.initialPage,
      limit: ApiConstants.pageSize,
    );

    switch (result) {
      case Success(:final data):
        emit(
          state.copyWith(
            status: HomeStatus.loaded,
            breeds: data,
            filteredBreeds: data,
            currentPage: ApiConstants.initialPage,
            hasReachedEnd: data.length < ApiConstants.pageSize,
            clearError: true,
          ),
        );
      case Failure(:final exception):
        emit(
          state.copyWith(
            status: HomeStatus.error,
            errorMessage: exception.message,
          ),
        );
    }
  }

  Future<void> loadMore() async {
    if (state.searchQuery.isNotEmpty) return;
    if (state.isLoadingMore || state.isInitialLoading || state.hasReachedEnd) {
      return;
    }

    emit(state.copyWith(status: HomeStatus.loadingMore));

    final int nextPage = state.currentPage + 1;
    final result = await _getCatBreeds(
      page: nextPage,
      limit: ApiConstants.pageSize,
    );

    switch (result) {
      case Success(:final data):
        final List<CatBreed> allBreeds = [...state.breeds, ...data];
        emit(
          state.copyWith(
            status: HomeStatus.loaded,
            breeds: allBreeds,
            filteredBreeds: allBreeds,
            currentPage: nextPage,
            hasReachedEnd: data.length < ApiConstants.pageSize,
            clearError: true,
          ),
        );
      case Failure(:final exception):
        emit(
          state.copyWith(
            status: HomeStatus.loaded,
            errorMessage: exception.message,
          ),
        );
    }
  }

  void retry() {
    if (state.searchQuery.isNotEmpty) {
      _search(state.searchQuery);
    } else if (state.breeds.isEmpty) {
      loadInitial();
    } else {
      loadMore();
    }
  }

  void onSearchChanged(String query) {
    _debounce?.cancel();
    final String trimmed = query.trim();

    if (trimmed.isEmpty) {
      emit(
        state.copyWith(
          searchQuery: '',
          filteredBreeds: state.breeds,
          clearError: true,
        ),
      );
      return;
    }

    emit(state.copyWith(searchQuery: trimmed));

    _debounce = Timer(
      const Duration(milliseconds: AppConstants.searchDebounceMilliseconds),
      () => _search(trimmed),
    );
  }

  Future<void> _search(String query) async {
    emit(state.copyWith(status: HomeStatus.loading));

    final result = await _searchCatBreeds(query);

    if (state.searchQuery != query) return;

    switch (result) {
      case Success(:final data):
        emit(
          state.copyWith(
            status: HomeStatus.loaded,
            filteredBreeds: data,
            clearError: true,
          ),
        );
      case Failure(:final exception):
        emit(
          state.copyWith(
            status: HomeStatus.error,
            errorMessage: exception.message,
          ),
        );
    }
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}

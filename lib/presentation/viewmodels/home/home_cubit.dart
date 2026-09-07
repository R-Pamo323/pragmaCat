import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/utils/string_similarity.dart';
import '../../../domain/entities/cat_breed.dart';
import '../../../domain/usecases/get_cat_breeds.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._getCatBreeds) : super(const HomeState()) {
    loadInitial();
  }

  final GetCatBreeds _getCatBreeds;

  Timer? _debounce;
  bool _isLoadingAll = false;

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
            filteredBreeds: _filterBreeds(data, state.searchQuery),
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
    if (state.isLoadingMore || state.isInitialLoading || state.hasReachedEnd) {
      return;
    }
    if (_isLoadingAll) return;

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
            filteredBreeds: _filterBreeds(allBreeds, state.searchQuery),
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
    if (state.breeds.isEmpty) {
      loadInitial();
    } else {
      loadMore();
    }
  }

  void onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(
      const Duration(milliseconds: AppConstants.searchDebounceMilliseconds),
      () => _applySearch(query.trim()),
    );
  }

  void _applySearch(String query) {
    emit(state.copyWith(searchQuery: query, clearSuggestion: true));

    if (query.isEmpty) {
      emit(state.copyWith(filteredBreeds: state.breeds));
      return;
    }

    final List<CatBreed> filtered = _filterBreeds(state.breeds, query);
    if (filtered.isNotEmpty) {
      emit(state.copyWith(filteredBreeds: filtered));
      return;
    }

    if (!state.hasReachedEnd) {
      emit(state.copyWith(filteredBreeds: const []));
      unawaited(_ensureFullDataset());
      return;
    }

    emit(
      state.copyWith(
        filteredBreeds: const [],
        suggestion: _suggestionFor(query),
      ),
    );
  }

  Future<void> _ensureFullDataset() async {
    if (_isLoadingAll) return;
    _isLoadingAll = true;

    try {
      while (!state.hasReachedEnd) {
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
                filteredBreeds: _filterBreeds(allBreeds, state.searchQuery),
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
            return;
        }
      }

      if (state.searchQuery.isEmpty) return;

      final List<CatBreed> filtered = _filterBreeds(
        state.breeds,
        state.searchQuery,
      );
      if (filtered.isNotEmpty) {
        emit(state.copyWith(filteredBreeds: filtered));
      } else {
        emit(
          state.copyWith(
            filteredBreeds: const [],
            suggestion: _suggestionFor(state.searchQuery),
          ),
        );
      }
    } finally {
      _isLoadingAll = false;
    }
  }

  List<CatBreed> _filterBreeds(List<CatBreed> breeds, String query) {
    final String normalized = query.toLowerCase();
    if (normalized.isEmpty) return breeds;

    return breeds
        .where(
          (CatBreed breed) => breed.name.toLowerCase().contains(normalized),
        )
        .toList();
  }

  String? _suggestionFor(String query) {
    return StringSimilarity.findClosestMatch(
      query,
      state.breeds.map((CatBreed breed) => breed.name).toList(),
    );
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}

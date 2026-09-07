import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_fonts.dart';
import '../../../domain/entities/cat_breed.dart';
import '../../../injection_container.dart';
import '../../viewmodels/home/home_cubit.dart';
import '../../viewmodels/home/home_state.dart';
import '../../widgets/cat_card.dart';
import '../../widgets/cat_search_bar.dart';
import '../../widgets/error_message.dart';
import '../../widgets/loading_indicator.dart';
import '../cat_detail/cat_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  String? _lastShownError;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.extentAfter < 300) {
      context.read<HomeCubit>().loadMore();
    }
  }

  void _onSuggestionTap(String suggestion) {
    _searchController.text = suggestion;
    _searchController.selection = TextSelection.collapsed(
      offset: suggestion.length,
    );
    context.read<HomeCubit>().onSearchChanged(suggestion);
  }

  void _showPaginationError(String message) {
    if (message == _lastShownError) return;
    _lastShownError = message;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        titleTextStyle: AppFonts.pageTitle.copyWith(color: Colors.white),
      ),
      body: SafeArea(
        child: BlocProvider<HomeCubit>(
          create: (_) => HomeCubit(InjectionContainer.getCatBreeds),
          child: BlocConsumer<HomeCubit, HomeState>(
            listener: (BuildContext context, HomeState state) {
              if (state.status != HomeStatus.error &&
                  state.errorMessage != null &&
                  state.breeds.isNotEmpty) {
                _showPaginationError(state.errorMessage!);
              }
            },
            builder: (BuildContext context, HomeState state) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(AppConstants.defaultPadding),
                    child: CatSearchBar(
                      onChanged: context.read<HomeCubit>().onSearchChanged,
                      suggestion: state.suggestion,
                      onSuggestionTap:
                          state.suggestion == null || state.suggestion!.isEmpty
                          ? null
                          : () => _onSuggestionTap(state.suggestion!),
                    ),
                  ),
                  Expanded(child: _buildContent(context, state)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, HomeState state) {
    if (state.isInitialLoading && state.breeds.isEmpty) {
      return const LoadingIndicator();
    }

    if (state.status == HomeStatus.error && state.breeds.isEmpty) {
      return ErrorMessage(
        message: state.errorMessage ?? 'Something went wrong.',
        onRetry: context.read<HomeCubit>().retry,
      );
    }

    if (state.filteredBreeds.isEmpty && state.searchQuery.isNotEmpty) {
      return _EmptyState(query: state.searchQuery);
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(
        AppConstants.defaultPadding,
        0,
        AppConstants.defaultPadding,
        AppConstants.defaultPadding,
      ),
      itemCount: state.isLoadingMore
          ? state.filteredBreeds.length + 1
          : state.filteredBreeds.length,
      itemBuilder: (BuildContext context, int index) {
        if (index >= state.filteredBreeds.length) {
          return const _BottomLoadingIndicator();
        }

        final breed = state.filteredBreeds[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: CatCard(breed: breed, onMorePressed: () => _openDetail(breed)),
        );
      },
    );
  }

  void _openDetail(CatBreed breed) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => CatDetailPage(breed: breed)),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.search_off,
            size: 56,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: 16),
          Text(
            'No breeds found for "$query".',
            style: AppFonts.body,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _BottomLoadingIndicator extends StatelessWidget {
  const _BottomLoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_paper_app/core/errors/exceptions.dart';
import 'package:news_paper_app/domain/entities/article.dart';
import 'package:news_paper_app/domain/entities/search_filter.dart';
import 'package:news_paper_app/domain/repositories/base_search_repository.dart';
import 'package:news_paper_app/domain/usecases/search/get_everthing_use_case.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit(this.getEverythingUseCase, this.baseSearchRepository)
    : super(SearchInitial());

  final GetEverythingUseCase getEverythingUseCase;
  final BaseSearchRepository baseSearchRepository;

  String _query = '';

  SearchFilter _filter = const SearchFilter();

  int _currentPage = 1;

  int _searchRequestId = 0;

  int _suggestionsRequestId = 0;

  int _totalPages = 1;
  static const int _pageSize = 12;

  Future<void> search(String query, {SearchFilter? filter}) async {
    final trimmedQuery = query.trim();
    if (trimmedQuery.isEmpty) return;

    final currentRequestId = ++_searchRequestId;

    _query = trimmedQuery;
    if (filter != null) _filter = filter;

    _currentPage = 1;

    emit(SearchLoading());

    await _fetchPage(_currentPage, currentRequestId);
  }

  Future<void> goToPage(int page) async {
    if (page == _currentPage || page < 1 || page > _totalPages) return;

    final currentRequestId = ++_searchRequestId;

    emit(SearchLoadingPage(page: page));

    await _fetchPage(page, currentRequestId);
  }

  Future<void> _fetchPage(int page, int requestId) async {
    try {
      final result = await getEverythingUseCase(
        query: _query,
        page: page,
        pageSize: _pageSize,
        sortBy: _filter.sortBy,
        language: _filter.language,
        from: _filter.from,
        to: _filter.to,
        sources: _filter.sources,
      );

      if (requestId != _searchRequestId) return;

      _currentPage = page;
      _totalPages = (result.totalResults / _pageSize).ceil().clamp(1, 999999);

      emit(
        SearchLoaded(
          articles: List.unmodifiable(result.articles),
          currentPage: _currentPage,
          totalPages: _totalPages,
        ),
      );

      if (page == 1) {
        await saveRecentSearch(_query);
      }
    } on NetworkException catch (e) {
      if (requestId != _searchRequestId) return;
      emit(SearchError(message: e.message));
    } on ServerException catch (e) {
      if (requestId != _searchRequestId) return;
      emit(SearchError(message: e.message));
    } on CacheException catch (e) {
      if (requestId != _searchRequestId) return;
      emit(SearchError(message: e.message));
    } catch (_) {
      if (requestId != _searchRequestId) return;
      emit(
        const SearchError(message: 'Something went wrong. Please try again.'),
      );
    }
  }

  Future<void> getRecentSearches() async {
    emit(SearchLoading());

    try {
      final searches = await baseSearchRepository.getRecentSearches();

      emit(RecentSearchesLoaded(searches: List.unmodifiable(searches)));
    } on CacheException catch (e) {
      emit(SearchError(message: e.message));
    } catch (_) {
      emit(
        const SearchError(message: 'Something went wrong. Please try again.'),
      );
    }
  }

  Future<void> saveRecentSearch(String query) async {
    try {
      await baseSearchRepository.saveRecentSearch(query);
    } on CacheException catch (e) {
      emit(SearchError(message: e.message));
    } catch (_) {
      emit(
        const SearchError(message: 'Something went wrong. Please try again.'),
      );
    }
  }

  Future<void> removeSearch(String query) async {
    try {
      await baseSearchRepository.removeSearch(query);

      await getRecentSearches();
    } on CacheException catch (e) {
      emit(SearchError(message: e.message));
    } catch (_) {
      emit(
        const SearchError(message: 'Something went wrong. Please try again.'),
      );
    }
  }

  Future<void> clearSearches() async {
    try {
      await baseSearchRepository.clearSearches();

      emit(const RecentSearchesLoaded(searches: []));
    } on CacheException catch (e) {
      emit(SearchError(message: e.message));
    } catch (_) {
      emit(
        const SearchError(message: 'Something went wrong. Please try again.'),
      );
    }
  }

  void updateFilter({
    String? sortBy,
    String? language,
    DateTime? from,
    DateTime? to,
    String? sources,
  }) {
    _filter = _filter.copyWith(
      sortBy: sortBy,
      language: language,
      from: from,
      to: to,
      sources: sources,
    );
  }

  Future<void> getSuggestions(String query) async {
    final trimmedQuery = query.trim();

    if (trimmedQuery.isEmpty) {
      emit(const SearchSuggestionsLoaded(suggestions: []));
      return;
    }

    final currentRequestId = ++_suggestionsRequestId;

    try {
      final result = await getEverythingUseCase(
        query: trimmedQuery,
        page: 1,
        pageSize: 10,
      );

      if (currentRequestId != _suggestionsRequestId) return;

      final suggestions =
          result.articles
              .map((a) => a.title)
              .whereType<String>()
              .toSet()
              .take(6)
              .toList();

      emit(SearchSuggestionsLoaded(suggestions: suggestions));
    } catch (_) {
      if (currentRequestId != _suggestionsRequestId) return;
      emit(const SearchSuggestionsLoaded(suggestions: []));
    }
  }

  Future<void> applyFilters() async {
    if (_query.isEmpty) return;

    await search(_query, filter: _filter);
  }

  void clearFilters() {
    _filter = const SearchFilter();
  }
}

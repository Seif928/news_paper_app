import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_paper_app/core/errors/exceptions.dart';
import 'package:news_paper_app/domain/entities/article.dart';
import 'package:news_paper_app/domain/entities/search_filter.dart';
import 'package:news_paper_app/domain/usecases/news/get_everthing_use_case.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit(this.getEverythingUseCase) : super(SearchInitial());

  final GetEverythingUseCase getEverythingUseCase;

  final List<Article> _articles = [];

  String _query = '';

  SearchFilter _filter = const SearchFilter();

  int _currentPage = 1;

  bool _hasMore = true;

  bool _isLoadingMore = false;

  int _searchRequestId = 0;

  List<Article> get articles => List.unmodifiable(_articles);

  Future<void> search(String query, {SearchFilter? filter}) async {
    final trimmedQuery = query.trim();

    if (trimmedQuery.isEmpty) return;

    final currentRequestId = ++_searchRequestId;

    _query = trimmedQuery;

    if (filter != null) {
      _filter = filter;
    }

    _currentPage = 1;
    _hasMore = true;
    _isLoadingMore = false;

    _articles.clear();

    emit(SearchLoading());

    try {
      final result = await getEverythingUseCase(
        query: _query,
        page: _currentPage,
        pageSize: 12,
        sortBy: _filter.sortBy,
        language: _filter.language,
        from: _filter.from,
        to: _filter.to,
        sources: _filter.sources,
      );

      if (currentRequestId != _searchRequestId) {
        return;
      }

      _articles.addAll(result.articles);

      _hasMore = _articles.length < result.totalResults;

      emit(
        SearchLoaded(articles: List.unmodifiable(_articles), hasMore: _hasMore),
      );
    } on NetworkException catch (e) {
      if (currentRequestId != _searchRequestId) return;

      emit(SearchError(message: e.message));
    } on ServerException catch (e) {
      if (currentRequestId != _searchRequestId) return;

      emit(SearchError(message: e.message));
    } on CacheException catch (e) {
      if (currentRequestId != _searchRequestId) return;

      emit(SearchError(message: e.message));
    } catch (_) {
      if (currentRequestId != _searchRequestId) return;

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

  Future<void> applyFilters() async {
    if (_query.isEmpty) return;

    await search(_query, filter: _filter);
  }

  void clearFilters() {
    _filter = const SearchFilter();
  }

  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasMore || _query.isEmpty) {
      return;
    }

    _isLoadingMore = true;

    emit(
      SearchLoadingMore(
        articles: List.unmodifiable(_articles),
        hasMore: _hasMore,
      ),
    );

    try {
      final nextPage = _currentPage + 1;

      final result = await getEverythingUseCase(
        query: _query,
        page: nextPage,
        pageSize: 12,
        sortBy: _filter.sortBy,
        language: _filter.language,
        from: _filter.from,
        to: _filter.to,
        sources: _filter.sources,
      );

      final newArticles = result.articles;

      if (newArticles.isEmpty) {
        _hasMore = false;
      } else {
        _currentPage = nextPage;

        _articles.addAll(newArticles);

        _hasMore = _articles.length < result.totalResults;
      }

      emit(
        SearchLoaded(articles: List.unmodifiable(_articles), hasMore: _hasMore),
      );
    } on NetworkException catch (_) {
      emit(
        SearchLoaded(articles: List.unmodifiable(_articles), hasMore: _hasMore),
      );
    } on ServerException catch (_) {
      emit(
        SearchLoaded(articles: List.unmodifiable(_articles), hasMore: _hasMore),
      );
    } on CacheException catch (_) {
      emit(
        SearchLoaded(articles: List.unmodifiable(_articles), hasMore: _hasMore),
      );
    } catch (_) {
      emit(
        SearchLoaded(articles: List.unmodifiable(_articles), hasMore: _hasMore),
      );
    } finally {
      _isLoadingMore = false;
    }
  }
}

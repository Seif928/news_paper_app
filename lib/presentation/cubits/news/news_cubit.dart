import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_paper_app/core/errors/exceptions.dart';
import 'package:news_paper_app/domain/entities/article.dart';
import 'package:news_paper_app/domain/usecases/news/get_top_headlines_use_case.dart';
import 'package:news_paper_app/presentation/cubits/news/news_state.dart';

class NewsCubit extends Cubit<NewsState> {
  final GetTopHeadlinesUseCase getTopHeadlinesUseCase;

  NewsCubit(this.getTopHeadlinesUseCase) : super(const NewsInitial());

  final List<Article> _articles = [];

  String? _country;
  int _currentPage = 1;
  int _totalResult = 0;

  bool _isLoadingMore = false;

  bool _hasMore = true;

  List<Article> get articles => List.unmodifiable(_articles);

  bool get hasMore => _hasMore;

  Future<void> getTopHeadlines({
    String? country,
    String? category,
    bool refresh = false,
  }) async {
    if (country != null) {
      final newCountryCode = country.toLowerCase();

      if (newCountryCode != _country) {
        _country = newCountryCode;

        // إعادة ضبط الصفحات عند تغيير الدولة.
        _currentPage = 1;
        _totalResult = 0;
        _isLoadingMore = false;
        _hasMore = true;
      }
    }
    print('GET TOP HEADLINES CALLED');
    if (_isLoadingMore) return;

    if (refresh) {
      _currentPage = 1;
      _totalResult = 0;
      _hasMore = true;
      _articles.clear();
    }

    emit(const NewsLoading());

    try {
      print('API RESULT RECEIVED');
      final result = await getTopHeadlinesUseCase(
        country: country,
        category: category,
        page: _currentPage,
        pageSize: 12,
      );

      final newArticles = result.articles;
      print('Total Results: ${result.totalResults}');
      print('Articles Count: ${newArticles.length}');
      _totalResult = result.totalResults;

      _articles
        ..clear()
        ..addAll(newArticles);

      _hasMore = newArticles.length == 12;
      emit(NewsLoaded(List.unmodifiable(_articles), hasMore: _hasMore));
    } on NetworkException catch (e) {
      emit(NewsError(e.message));
    } on ServerException catch (e) {
      emit(NewsError(e.message));
    } on CacheException catch (e) {
      emit(NewsError(e.message));
    } catch (_) {
      emit(const NewsError('Something went wrong. Please try again.'));
    }
  }

  Future<void> loadMore({String country = 'us', String? category}) async {
    if (_isLoadingMore || !_hasMore) {
      return;
    }

    _isLoadingMore = true;

    emit(NewsLoadingMore(List.unmodifiable(_articles), hasMore: _hasMore));

    try {
      final nextPage = _currentPage + 1;

      final result = await getTopHeadlinesUseCase(
        country: country,
        category: category,
        page: nextPage,
        pageSize: 12,
      );
      final newArticles = result.articles;
      if (newArticles.isEmpty) {
        _hasMore = false;
      } else {
        _currentPage = nextPage;

        _articles.addAll(newArticles);
        _totalResult = result.totalResults;
        _hasMore = _articles.length < _totalResult;
      }

      emit(NewsLoaded(List.unmodifiable(_articles), hasMore: _hasMore));
    } on NetworkException catch (_) {
      emit(NewsLoaded(List.unmodifiable(_articles), hasMore: _hasMore));
    } on ServerException catch (_) {
      emit(NewsLoaded(List.unmodifiable(_articles), hasMore: _hasMore));
    } catch (_) {
      emit(NewsLoaded(List.unmodifiable(_articles), hasMore: _hasMore));
    } finally {
      _isLoadingMore = false;
    }
  }
}

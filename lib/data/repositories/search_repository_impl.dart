import 'package:dartz/dartz.dart';
import 'package:news_paper_app/core/errors/exceptions.dart';
import 'package:news_paper_app/core/errors/failuer.dart';
import 'package:news_paper_app/data/datasource/local_data/search_local_data_sorce.dart';
import 'package:news_paper_app/data/datasource/remote_data/news_remote_data_source.dart';
import 'package:news_paper_app/domain/entities/news_result.dart';
import 'package:news_paper_app/domain/repositories/base_search_repository.dart';

class SearchRepositoryImpl implements BaseSearchRepository {
  final SearchLocalDataSource searchLocalDataSource;
  final NewsRemoteDataSource remoteDataSource;

  SearchRepositoryImpl(this.searchLocalDataSource, this.remoteDataSource);
  @override
  Future<Either<Failure, NewsResult>> getEverything({
    required String query,
    String? sources,
    String? language,
    DateTime? from,
    DateTime? to,
    String? sortBy,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final remoteNews = await remoteDataSource.getEverything(
        query: query,
        page: page,
        pageSize: pageSize,
        language: language,
        sortBy: sortBy,
        from: from,
        to: to,
        sources: sources,
      );
      return Right(
        NewsResult(
          totalResults: remoteNews.totalResults,
          articles: remoteNews.articles,
        ),
      );
    } on NetworkException {
      return Left(NetworkFailure(message: 'check your internet connection.'));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<void> clearSearches() => searchLocalDataSource.clearSearches();

  @override
  Future<List<String>> getRecentSearches() =>
      searchLocalDataSource.getRecentSearches();

  @override
  Future<void> removeSearch(String query) =>
      searchLocalDataSource.removeSearch(query);

  @override
  Future<void> saveRecentSearch(String query) =>
      searchLocalDataSource.saveRecentSearches(query);
}

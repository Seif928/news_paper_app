import 'package:dartz/dartz.dart';
import 'package:news_paper_app/core/errors/exceptions.dart';
import 'package:news_paper_app/core/errors/failuer.dart';
import 'package:news_paper_app/data/datasource/local_data/news_local_data_source.dart';
import 'package:news_paper_app/data/datasource/remote_data/news_remote_data_source.dart';
import 'package:news_paper_app/data/models/article_model.dart';
import 'package:news_paper_app/domain/entities/article.dart';
import 'package:news_paper_app/domain/entities/news_result.dart';
import 'package:news_paper_app/domain/repositories/base_newspapers_repository.dart';

class NewsRepositoryImpl implements BaseNewspapersRepository {
  final NewsRemoteDataSource remoteDataSource;
  final NewsLocalDataSource localDataSource;

  NewsRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<Either<Failure, NewsResult>> getTopHeadlines({
    String? country,
    String? category,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final remoteNews = await remoteDataSource.getTopHeadLines(
        country: country ?? 'us',
        category: category,
        page: page,
        pageSize: pageSize,
      );

      // Cache the fetched articles
      final articleModels =
          remoteNews.articles
              .map(
                (article) => ArticleModel(
                  sourceId: article.sourceId,
                  sourceName: article.sourceName,
                  author: article.author,
                  title: article.title,
                  description: article.description,
                  url: article.url,
                  imageUrl: article.imageUrl,
                  publishedAt: article.publishedAt,
                  content: article.content,
                ),
              )
              .toList();
      await localDataSource.cacheArticles(articleModels);

      return Right(
        NewsResult(
          totalResults: remoteNews.totalResults,
          articles: remoteNews.articles,
        ),
      );
    } on NetworkException {
      // Fallback to cache on network timeout/loss
      try {
        final cachedArticles = await localDataSource.getCachedArticles();
        return Right(
          NewsResult(
            totalResults: cachedArticles.length,
            articles: cachedArticles,
          ),
        );
      } on CacheException catch (cacheError) {
        return Left(DatabaseFailure(message: cacheError.message));
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

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
  Future<Either<Failure, List<Article>>> getSources() async {
    return const Right([]);
  }
}

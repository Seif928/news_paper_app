import 'package:dartz/dartz.dart';
import 'package:news_paper_app/core/errors/failuer.dart';
import 'package:news_paper_app/domain/entities/news_result.dart';

abstract class BaseSearchRepository {
  Future<Either<Failure, NewsResult>> getEverything({
    required String query,
    String? sources,
    String? language,
    DateTime? from,
    DateTime? to,
    String? sortBy,
    int page = 1,
    int pageSize = 20,
  });
  Future<List<String>> getRecentSearches();
  Future<void> saveRecentSearch(String query);
  Future<void> removeSearch(String query);
  Future<void> clearSearches();
}

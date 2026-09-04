import 'package:news_paper_app/data/datasource/local_data/search_local_data_sorce.dart';
import 'package:news_paper_app/domain/repositories/base_search_repository.dart';

class SearchRepositoryImpl implements BaseSearchRepository {
  final SearchLocalDataSource searchLocalDataSource;

  SearchRepositoryImpl({required this.searchLocalDataSource});
  @override
  Future<void> clearSearches() => searchLocalDataSource.clearSearches();

  @override
  Future<List<String>> getRecentSearches() =>
      searchLocalDataSource.getRecentSearches();

  @override
  Future<void> removeSearch(String query) =>
      searchLocalDataSource.removeSearch(query);

  @override
  Future<void> saveRecentSearches(String query) =>
      searchLocalDataSource.saveRecentSearches(query);
}

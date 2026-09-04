import 'package:news_paper_app/domain/repositories/base_search_repository.dart';

class GetRecentSearchesUseCase {
  final BaseSearchRepository repository;

  GetRecentSearchesUseCase(this.repository);

  Future<List<String>> call() => repository.getRecentSearches();
}

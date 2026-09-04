import 'package:news_paper_app/domain/repositories/base_search_repository.dart';

class SaveRecentSearchesUseCase {
  final BaseSearchRepository repository;

  SaveRecentSearchesUseCase(this.repository);

  Future<void> call(String query) => repository.saveRecentSearches(query);
}

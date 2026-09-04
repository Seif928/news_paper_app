import 'package:news_paper_app/domain/repositories/base_search_repository.dart';

class ClearSearchesUseCase {
  final BaseSearchRepository repository;

  ClearSearchesUseCase(this.repository);

  Future<void> call() => repository.clearSearches();
}

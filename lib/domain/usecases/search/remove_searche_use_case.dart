import 'package:news_paper_app/domain/repositories/base_search_repository.dart';

class RemoveSearchUseCase {
  final BaseSearchRepository repository;

  RemoveSearchUseCase(this.repository);

  Future<void> call(String query) => repository.removeSearch(query);
}

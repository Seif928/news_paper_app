import 'package:news_paper_app/core/errors/exceptions.dart';
import 'package:news_paper_app/core/errors/failuer.dart';
import 'package:news_paper_app/domain/entities/news_result.dart';
import 'package:news_paper_app/domain/repositories/base_newspapers_repository.dart';

class GetEverythingUseCase {
  final BaseNewspapersRepository repository;
  GetEverythingUseCase(this.repository);
  Future<NewsResult> call({
    required String query,
    String? sources,
    String? language,
    DateTime? from,
    DateTime? to,
    String? sortBy,
    int page = 1,
    int pageSize = 20,
  }) async {
    final result = await repository.getEverything(
      query: query,
      sources: sources,
      language: language,
      from: from,
      to: to,
      sortBy: sortBy,
      page: page,
      pageSize: pageSize,
    );

    return result.fold((failure) {
      if (failure is ServerFailure) {
        throw ServerException(failure.message);
      } else if (failure is DatabaseFailure) {
        throw CacheException(failure.message);
      } else {
        throw ServerException(failure.message);
      }
    }, (newsResult) => newsResult);
  }
}

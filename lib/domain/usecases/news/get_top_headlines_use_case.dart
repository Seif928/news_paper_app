import 'package:news_paper_app/core/errors/exceptions.dart';
import 'package:news_paper_app/core/errors/failuer.dart';
import 'package:news_paper_app/domain/entities/news_result.dart';
import 'package:news_paper_app/domain/repositories/base_newspapers_repository.dart';

class GetTopHeadlinesUseCase {
  final BaseNewspapersRepository repository;

  GetTopHeadlinesUseCase(this.repository);

  Future<NewsResult> call({
    String? country,
    String? category,
    int page = 1,
    int pageSize = 20,
  }) async {
    final result = await repository.getTopHeadlines(
      country: country ?? 'us',
      category: category,
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

import 'package:news_paper_app/data/datasource/remote_data/news_api_service.dart';
import 'package:news_paper_app/data/models/news_response_model.dart';

class NewsRemoteDataSource {
  final NewsApiService _newsApiService;

  NewsRemoteDataSource(this._newsApiService);

  Future<NewsResponseModel> getTopHeadLines({
    String country = 'us',
    String? category,
    String? source,
    int page = 1,
    int pageSize = 20,
  }) async {
    final response = await _newsApiService.getTopHeadlines(
      country: country,
      category: category,
      page: page,
      pageSize: pageSize,
      source: source,
    );

    return NewsResponseModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<NewsResponseModel> getEverything({
    required String query,
    String? sources,
    String? language,
    String? sortBy,
    DateTime? from,
    DateTime? to,
    int page = 1,
    int pageSize = 20,
  }) async {
    final response = await _newsApiService.getEverything(
      query: query,
      language: language,
      sortBy: sortBy,
      from: from,
      to: to,
      sources: sources,
      page: page,
      pageSize: pageSize,
    );

    return NewsResponseModel.fromJson(response.data as Map<String, dynamic>);
  }
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:news_paper_app/data/models/article_model.dart';

class NewsResponseModel {
  final String status;
  final int totalResults;
  final List<ArticleModel> articles;

  const NewsResponseModel({
    required this.status,
    required this.totalResults,
    required this.articles,
  });

  factory NewsResponseModel.fromJson(Map<String, dynamic> json) {
    final articlesJson = json['articles'] as List<dynamic>? ?? [];
    final articles =
        articlesJson
            .map(
              (article) =>
                  ArticleModel.fromJson(article as Map<String, dynamic>),
            )
            .where(
              (article) =>
                  article.imageUrl != null &&
                  article.imageUrl!.trim().isNotEmpty,
            )
            .toList();

    return NewsResponseModel(
      status: json['status'] as String? ?? 'error',
      totalResults: json['totalResults'] as int? ?? 0,
      articles: articles,
    );
  }

  NewsResponseModel copyWith({
    String? status,
    int? totalResults,
    List<ArticleModel>? articles,
  }) {
    return NewsResponseModel(
      status: status ?? this.status,
      totalResults: totalResults ?? this.totalResults,
      articles: articles ?? this.articles,
    );
  }
}

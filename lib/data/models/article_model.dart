import 'package:news_paper_app/core/utils/date_utils.dart';
import 'package:news_paper_app/domain/entities/article.dart';

class ArticleModel extends Article {
  const ArticleModel({
    required super.sourceId,
    required super.sourceName,
    required super.author,
    required super.title,
    required super.description,
    required super.url,
    required super.imageUrl,
    required super.publishedAt,
    required super.content,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    final source = json['source'] as Map<String, dynamic>?;

    return ArticleModel(
      sourceId: source?['id'] as String?,
      sourceName: source?['name'] as String? ?? 'Unknown Source',
      author: json['author'] as String?,
      title: json['title'] as String? ?? 'No title',
      description: json['description'] as String?,
      url: json['url'] as String? ?? '',
      imageUrl: json['urlToImage'] as String?,
      publishedAt: DateUtilsApp.parseDate(json['publishedAt'] as String?),
      content: json['content'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'source': {'id': sourceId, 'name': sourceName},
      'author': author,
      'title': title,
      'description': description,
      'url': url,
      'urlToImage': imageUrl,
      'publishedAt': publishedAt?.toIso8601String(),
      'content': content,
    };
  }
}

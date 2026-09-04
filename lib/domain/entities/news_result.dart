import 'article.dart';

class NewsResult {
  final List<Article> articles;
  final int totalResults;

  const NewsResult({required this.articles, required this.totalResults});
}

import 'package:news_paper_app/domain/entities/article.dart';

abstract class BaseFavoriteRepository {
  Future<List<Article>> getFavorites();

  Future<void> addFavorite(Article article);

  Future<void> removeFavorite(String url);

  Future<bool> isFavorite(String url);
}

import 'package:news_paper_app/data/datasource/local_data/favorite_local_data_source.dart';
import 'package:news_paper_app/data/models/article_model.dart';
import 'package:news_paper_app/domain/entities/article.dart';
import 'package:news_paper_app/domain/repositories/base_favorite_reposirotry.dart';

class FavoriteRepositoryImpl implements BaseFavoriteRepository {
  final FavoriteLocalDataSource localDataSource;

  FavoriteRepositoryImpl(this.localDataSource);

  @override
  Future<List<Article>> getFavorites() async {
    return await localDataSource.getFavorites();
  }

  @override
  Future<void> addFavorite(Article article) async {
    final articleModel = ArticleModel(
      sourceId: article.sourceId,
      sourceName: article.sourceName,
      author: article.author,
      title: article.title,
      description: article.description,
      url: article.url,
      imageUrl: article.imageUrl,
      publishedAt: article.publishedAt,
      content: article.content,
    );

    await localDataSource.addFavorite(articleModel);
  }

  @override
  Future<void> removeFavorite(String url) async {
    await localDataSource.removeFavorite(url);
  }

  @override
  Future<bool> isFavorite(String url) async {
    return await localDataSource.isFavorite(url);
  }
}

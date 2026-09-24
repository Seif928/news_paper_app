import 'package:news_paper_app/data/datasource/local_data/saved_local_data_source.dart';
import 'package:news_paper_app/data/models/article_model.dart';
import 'package:news_paper_app/domain/entities/article.dart';
import 'package:news_paper_app/domain/repositories/base_saved_reposirotry.dart';

class SavedRepositoryImpl implements BaseSavedRepository {
  final SavedLocalDataSource localDataSource;

  SavedRepositoryImpl(this.localDataSource);

  @override
  Future<List<Article>> getSaved() async {
    return await localDataSource.getSaved();
  }

  @override
  Future<void> clearSaved() async {
    await localDataSource.clearSaved();
  }

  @override
  Future<void> addSaved(Article article) async {
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

    await localDataSource.addSaved(articleModel);
  }

  @override
  Future<void> removeSaved(String url) async {
    await localDataSource.removeSaved(url);
  }

  @override
  Future<bool> isSaved(String url) async {
    return await localDataSource.isSaved(url);
  }
}

import 'package:news_paper_app/domain/entities/article.dart';

abstract class BaseSavedRepository {
  Future<List<Article>> getSaved();

  Future<void> addSaved(Article article);

  Future<void> removeSaved(String url);

  Future<bool> isSaved(String url);

  Future<void> clearSaved();
}

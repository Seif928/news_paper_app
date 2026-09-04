import 'package:news_paper_app/domain/entities/article.dart';
import 'package:news_paper_app/domain/repositories/base_favorite_reposirotry.dart';

class AddFavoriteUseCase {
  final BaseFavoriteRepository repository;

  AddFavoriteUseCase(this.repository);

  Future<void> call(Article article) {
    return repository.addFavorite(article);
  }
}

import 'package:news_paper_app/domain/entities/article.dart';
import 'package:news_paper_app/domain/repositories/base_favorite_reposirotry.dart';

class GetFavoritesUseCase {
  final BaseFavoriteRepository repository;

  GetFavoritesUseCase(this.repository);

  Future<List<Article>> call() {
    return repository.getFavorites();
  }
}

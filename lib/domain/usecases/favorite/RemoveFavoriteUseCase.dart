import 'package:news_paper_app/domain/repositories/base_favorite_reposirotry.dart';

class RemoveFavoriteUseCase {
  final BaseFavoriteRepository repository;

  RemoveFavoriteUseCase(this.repository);

  Future<void> call(String url) {
    return repository.removeFavorite(url);
  }
}

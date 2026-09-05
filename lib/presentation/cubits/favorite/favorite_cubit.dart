import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_paper_app/core/errors/exceptions.dart';
import 'package:news_paper_app/domain/entities/article.dart' show Article;
import 'package:news_paper_app/domain/repositories/base_favorite_reposirotry.dart';
part 'favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  final BaseFavoriteRepository favoriteRepository;
  FavoriteCubit(this.favoriteRepository) : super(FavoriteInitial());

  final List<Article> _favorites = [];

  List<Article> get favorites => List.unmodifiable(_favorites);

  bool isFavorite(String url) {
    return _favorites.any((article) => article.url == url);
  }

  Future<void> getFavorites() async {
    emit(FavoriteLoading());

    try {
      final articles = await favoriteRepository.getFavorites();

      _favorites
        ..clear()
        ..addAll(articles);

      emit(FavoriteLoaded(List.unmodifiable(_favorites)));
    } on CacheException catch (e) {
      emit(FavoriteError(e.message));
    } catch (_) {
      emit(const FavoriteError('Something went wrong. Please try again.'));
    }
  }

  Future<void> addFavorite(Article article) async {
    if (isFavorite(article.url)) {
      return;
    }

    try {
      await favoriteRepository.addFavorite(article);

      _favorites.add(article);

      emit(FavoriteLoaded(List.unmodifiable(_favorites)));
    } on CacheException catch (e) {
      emit(FavoriteError(e.message));
    } catch (_) {
      emit(const FavoriteError('Failed to add favorite.'));
    }
  }

  Future<void> removeFavorite(String url) async {
    try {
      await favoriteRepository.removeFavorite(url);

      _favorites.removeWhere((article) => article.url == url);

      emit(FavoriteLoaded(List.unmodifiable(_favorites)));
    } on CacheException catch (e) {
      emit(FavoriteError(e.message));
    } catch (_) {
      emit(const FavoriteError('Failed to remove favorite.'));
    }
  }

  Future<void> toggleFavorite(Article article) async {
    if (isFavorite(article.url)) {
      await removeFavorite(article.url);
    } else {
      await addFavorite(article);
    }
  }
}

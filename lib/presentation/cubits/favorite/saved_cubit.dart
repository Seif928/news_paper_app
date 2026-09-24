import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_paper_app/core/errors/exceptions.dart';
import 'package:news_paper_app/domain/entities/article.dart' show Article;
import 'package:news_paper_app/domain/repositories/base_saved_reposirotry.dart';
part 'saved_state.dart';

class SavedCubit extends Cubit<SavedState> {
  final BaseSavedRepository favoriteRepository;
  SavedCubit(this.favoriteRepository) : super(SavedInitial());

  final List<Article> _favorites = [];

  List<Article> get favorites => List.unmodifiable(_favorites);

  bool isSaved(String url) {
    return _favorites.any((article) => article.url == url);
  }

  Future<void> getSaved() async {
    emit(SavedLoading());

    try {
      final articles = await favoriteRepository.getSaved();

      _favorites
        ..clear()
        ..addAll(articles);

      emit(SavedLoaded(List.unmodifiable(_favorites)));
    } on CacheException catch (e) {
      emit(SavedError(e.message));
    } catch (_) {
      emit(const SavedError('Something went wrong. Please try again.'));
    }
  }

  Future<void> addSaved(Article article) async {
    if (isSaved(article.url)) {
      return;
    }

    try {
      await favoriteRepository.addSaved(article);

      _favorites.add(article);

      emit(SavedLoaded(List.unmodifiable(_favorites)));
    } on CacheException catch (e) {
      emit(SavedError(e.message));
    } catch (_) {
      emit(const SavedError('Failed to add favorite.'));
    }
  }

  Future<void> removeSaved(String url) async {
    try {
      await favoriteRepository.removeSaved(url);

      _favorites.removeWhere((article) => article.url == url);

      emit(SavedLoaded(List.unmodifiable(_favorites)));
    } on CacheException catch (e) {
      emit(SavedError(e.message));
    } catch (_) {
      emit(const SavedError('Failed to remove favorite.'));
    }
  }

  Future<void> clearSaved() async {
    emit(SavedLoading());

    try {
      await favoriteRepository.clearSaved();
      _favorites.clear();
      emit(SavedLoaded(List.unmodifiable(_favorites)));
    } on CacheException catch (e) {
      emit(SavedError(e.message));
    } catch (_) {
      emit(const SavedError('Failed to clear favorites.'));
    }
  }

  Future<void> toggleSaved(Article article) async {
    if (isSaved(article.url)) {
      await removeSaved(article.url);
    } else {
      await addSaved(article);
    }
  }
}

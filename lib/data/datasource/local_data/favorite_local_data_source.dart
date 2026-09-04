import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:news_paper_app/core/errors/exceptions.dart';
import 'package:news_paper_app/data/models/article_model.dart';

class FavoriteLocalDataSource {
  static const String _boxName = 'news_cache';
  static const String _favoritesKey = 'favorite_articles';

  Future<List<ArticleModel>> getFavorites() async {
    try {
      final box = Hive.box<String>(_boxName);

      final favoritesData = box.get(_favoritesKey);

      if (favoritesData == null) {
        return [];
      }

      final List<dynamic> decoded = jsonDecode(favoritesData);

      return decoded
          .map(
            (article) =>
                ArticleModel.fromJson(Map<String, dynamic>.from(article)),
          )
          .toList();
    } catch (e) {
      throw const CacheException('Failed to load favorite articles.');
    }
  }

  Future<void> addFavorite(ArticleModel article) async {
    try {
      final favorites = await getFavorites();
      final exists = favorites.any((item) => item.url == article.url);
      if (exists) return;
      favorites.add(article);
      await _saveFavorites(favorites);
    } catch (e) {
      throw const CacheException('Failed to add favorite article.');
    }
  }

  Future<void> removeFavorite(String articleUrl) async {
    try {
      final favorites = await getFavorites();
      favorites.removeWhere((article) => article.url == articleUrl);
      await _saveFavorites(favorites);
    } catch (e) {
      throw const CacheException('Failed to remove favorite article.');
    }
  }

  Future<bool> isFavorite(String url) async {
    try {
      final favorites = await getFavorites();

      return favorites.any((article) => article.url == url);
    } catch (e) {
      throw const CacheException('Failed to check favorite article.');
    }
  }

  Future<void> _saveFavorites(List<ArticleModel> favorites) async {
    final box = Hive.box<String>(_boxName);

    final data = favorites.map((article) => article.toJson()).toList();

    await box.put(_favoritesKey, jsonEncode(data));
  }

  Future<void> clearFavorites() async {
    try {
      final box = Hive.box<String>(_boxName);

      await box.delete(_favoritesKey);
    } catch (e) {
      throw const CacheException('Failed to clear favorites.');
    }
  }
}

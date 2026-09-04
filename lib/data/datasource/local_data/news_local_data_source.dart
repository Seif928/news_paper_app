import 'dart:convert';

import 'package:hive_flutter/adapters.dart';
import 'package:news_paper_app/core/errors/exceptions.dart';
import 'package:news_paper_app/data/models/article_model.dart';

class NewsLocalDataSource {
  static const String _boxName = 'news_cache';
  static const String _articlesKey = 'cached_articles';

  Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox<String>(_boxName);
  }

  Future<void> cacheArticles(List<ArticleModel> articles) async {
    try {
      final box = Hive.box<String>(_boxName);

      final existingArticles = await getCachedArticles();

      final Map<String, ArticleModel> uniqueArticles = {
        for (final article in existingArticles) article.url: article,
      };

      for (final article in articles) {
        uniqueArticles[article.url] = article;
      }

      final allArticles = uniqueArticles.values.toList();

      final articlesJson =
          allArticles.map((article) => article.toJson()).toList();

      await box.put(_articlesKey, jsonEncode(articlesJson));
    } catch (e) {
      throw const CacheException('Failed to cache articles.');
    }
  }

  Future<List<ArticleModel>> getCachedArticles() async {
    try {
      final box = Hive.box<String>(_boxName);

      final cachedData = box.get(_articlesKey);

      if (cachedData == null) {
        return [];
      }

      final List<dynamic> decoded = jsonDecode(cachedData);

      return decoded
          .map(
            (article) => ArticleModel.fromJson(article as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      throw const CacheException('Failed to load cached articles.');
    }
  }

  Future<void> clearCache() async {
    final box = Hive.box<String>(_boxName);

    await box.delete(_articlesKey);
  }
}

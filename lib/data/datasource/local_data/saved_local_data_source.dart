import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:news_paper_app/core/errors/exceptions.dart';
import 'package:news_paper_app/core/utils/date_utils.dart';
import 'package:news_paper_app/data/models/article_model.dart';
import 'package:news_paper_app/presentation/widgets/notification_widgets/empty_state.dart';

class SavedLocalDataSource {
  static const String _boxName = 'news_cache';
  static const String _savedKey = 'saved_articles';

  Future<List<ArticleModel>> getSaved() async {
    try {
      final entries = await _getEntries();

      return entries.map((e) => e['article'] as ArticleModel).toList();
    } catch (e) {
      if (e is CacheException) rethrow;
      if (e is EmptyState) rethrow;
      throw const CacheException('Failed to load favorite articles.');
    }
  }

  Future<void> addSaved(ArticleModel article) async {
    try {
      final entries = await _getEntries();

      final exists = entries.any(
        (e) => (e['article'] as ArticleModel).url == article.url,
      );
      if (exists) return;

      entries.add({'article': article, 'savedAt': DateTime.now()});
      await _persist(entries);
    } catch (e) {
      if (e is CacheException) rethrow;
      throw const CacheException('Failed to add favorite article.');
    }
  }

  Future<void> removeSaved(String articleUrl) async {
    try {
      final entries = await _getEntries();

      entries.removeWhere(
        (e) => (e['article'] as ArticleModel).url == articleUrl,
      );
      await _persist(entries);
    } catch (e) {
      if (e is CacheException) rethrow;
      throw const CacheException('Failed to remove favorite article.');
    }
  }

  Future<bool> isSaved(String url) async {
    try {
      final entries = await _getEntries();

      return entries.any((e) => (e['article'] as ArticleModel).url == url);
    } catch (e) {
      if (e is CacheException) rethrow;
      throw const CacheException('Failed to check favorite article.');
    }
  }

  Future<void> clearSaved() async {
    try {
      final box = Hive.box<String>(_boxName);

      await box.delete(_savedKey);
    } catch (e) {
      throw const CacheException('Failed to clear favorites.');
    }
  }

  Future<List<Map<String, dynamic>>> _getEntries() async {
    final box = Hive.box<String>(_boxName);

    final raw = box.get(_savedKey);

    if (raw == null) return [];

    final decoded = jsonDecode(raw) as List<dynamic>;

    return decoded.map((item) {
      return {
        'article': ArticleModel.fromJson(item['article']),
        'savedAt': DateUtilsApp.parseDate(item['savedAt']),
      };
    }).toList();
  }

  Future<void> _persist(List<Map<String, dynamic>> entries) async {
    final box = Hive.box<String>(_boxName);

    final list =
        entries
            .map(
              (e) => {
                'article': (e['article'] as ArticleModel).toJson(),
                'savedAt': DateUtilsApp.formatDate(e['savedAt']),
              },
            )
            .toList();

    await box.put(_savedKey, jsonEncode(list));
  }
}

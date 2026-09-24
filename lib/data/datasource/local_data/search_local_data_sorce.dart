import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:news_paper_app/core/errors/exceptions.dart';

class SearchLocalDataSource {
  static const String boxName = 'search_cache';
  static const String recentSearchesKey = 'recent_searches';

  Future<void> init() async {
    await Hive.openBox<String>(boxName);
  }

  Future<List<String>> getRecentSearches() async {
    try {
      final box = Hive.box<String>(boxName);

      final searchesData = box.get(recentSearchesKey);

      if (searchesData == null) {
        return [];
      }

      final List<dynamic> decoded = jsonDecode(searchesData);

      return decoded.whereType<String>().toList();
    } catch (e) {
      if (e is CacheException) {
        rethrow;
      }
      throw const CacheException('Failed to load recent searches.');
    }
  }

  Future<void> saveRecentSearches(String query) async {
    try {
      final box = Hive.box<String>(boxName);
      final searches = await getRecentSearches();
      final normalizedQuery = query.trim();

      if (normalizedQuery.isEmpty) {
        return;
      }
      searches.remove(normalizedQuery);
      searches.insert(0, normalizedQuery);
      if (searches.length > 6) {
        searches.removeLast();
      }
      await box.put(recentSearchesKey, jsonEncode(searches));
    } catch (e) {
      if (e is CacheException) {
        rethrow;
      }
      print('SaveRecentSearches error: $e');
      throw const CacheException('Failed to save recent searches.');
    }
  }

  Future<void> removeSearch(String query) async {
    try {
      final box = Hive.box<String>(boxName);

      final searches = await getRecentSearches();
      final normalizedQuery = query.trim();
      searches.remove(normalizedQuery);

      await box.put(recentSearchesKey, jsonEncode(searches));
    } catch (e) {
      if (e is CacheException) {
        rethrow;
      }
      throw const CacheException('Failed to remove search.');
    }
  }

  Future<void> clearSearches() async {
    try {
      final box = Hive.box<String>(boxName);

      await box.delete(recentSearchesKey);
    } catch (e) {
      if (e is CacheException) {
        rethrow;
      }
      throw const CacheException('Failed to clear searches.');
    }
  }
}

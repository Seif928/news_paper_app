import 'package:hive_flutter/hive_flutter.dart';
import 'package:news_paper_app/core/errors/exceptions.dart';

class ThemeModeLocalDataSource {
  static const String _boxName = 'settings_cache';
  static const String _themeKey = 'theme';

  Future<void> init() async {
    await Hive.openBox<bool>(_boxName);
  }

  Future<bool> getIsDarkMode() async {
    try {
      final box = Hive.box<bool>(_boxName);
      return box.get(_themeKey, defaultValue: false) ?? false;
    } catch (e) {
      if (e is CacheException) rethrow;
      throw const CacheException('Failed to load theme preference.');
    }
  }

  Future<void> saveIsDarkMode(bool isDarkMode) async {
    try {
      final box = Hive.box<bool>(_boxName);
      await box.put(_themeKey, isDarkMode);
    } catch (e) {
      if (e is CacheException) rethrow;
      throw const CacheException('Failed to save theme preference.');
    }
  }
}

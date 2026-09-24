import 'package:news_paper_app/data/datasource/local_data/theme_mode_local_data_source.dart';
import 'package:news_paper_app/domain/repositories/base_theme_mode_repository.dart';

class ThemeModeRepositoryImpl implements BaseThemeModeRepository {
  final ThemeModeLocalDataSource themeLocalDataSource;
  ThemeModeRepositoryImpl(this.themeLocalDataSource);
  @override
  Future<bool> getIsDarkMode() async =>
      await themeLocalDataSource.getIsDarkMode();

  @override
  Future<void> saveIsDarkMode(bool isDarkMode) async =>
      await themeLocalDataSource.saveIsDarkMode(isDarkMode);
}

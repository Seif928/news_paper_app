abstract class BaseThemeModeRepository {
  Future<bool> getIsDarkMode();
  Future<void> saveIsDarkMode(bool isDarkMode);
}

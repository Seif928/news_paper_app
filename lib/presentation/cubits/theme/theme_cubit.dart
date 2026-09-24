import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:news_paper_app/domain/repositories/base_theme_mode_repository.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit(this._repository) : super(ThemeMode.light) {
    _loadTheme();
  }
  final BaseThemeModeRepository _repository;
  Future<void> _loadTheme() async {
    try {
      final isDark = await _repository.getIsDarkMode();
      emit(isDark ? ThemeMode.dark : ThemeMode.light);
    } catch (e) {
      emit(ThemeMode.light);
    }
  }

  Future<void> toggleTheme(bool isDark) async {
    try {
      emit(isDark ? ThemeMode.dark : ThemeMode.light);
      await _repository.saveIsDarkMode(isDark);
    } catch (e) {
      emit(state);
    }
  }
}

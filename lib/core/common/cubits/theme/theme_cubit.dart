import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:minimal_notes_app/core/theme/theme.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeInitial()) {
    _loadTheme();
  }

  void toggleTheme() {
    if (state is ThemeLoaded) {
      final currentState = state as ThemeLoaded;
      final isDark = currentState.themeData.brightness == Brightness.dark;
      final newTheme = isDark ? AppTheme.lightThemeMode : AppTheme.darkThemeMode;
      emit(ThemeLoaded(themeData: newTheme, isDarkMode: !isDark));
      _saveTheme(!isDark);
    }
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDarkMode') ?? false;
    final themeData = isDark ? AppTheme.darkThemeMode : AppTheme.lightThemeMode;
    emit(ThemeLoaded(themeData: themeData, isDarkMode: isDark));
  }

  Future<void> _saveTheme(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode);
  }
}

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(const SettingsState()) {
    _loadSettings();
  }

  // Keys for SharedPreferences
  static const _keyThemeMode = 'themeMode';
  static const _keyAccentColor = 'accentColor';
  static const _keyFontFamily = 'fontFamily';
  static const _keyFontSizeScale = 'fontSizeScale';
  static const _keySortOrder = 'sortOrder';
  static const _keyNoteLayout = 'noteLayout';
  static const _keyCompactCards = 'compactCards';

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    final themeMode = AppThemeMode.values[
        prefs.getInt(_keyThemeMode) ?? AppThemeMode.dark.index];
    final accentColor = AccentColor.values[
        prefs.getInt(_keyAccentColor) ?? AccentColor.blue.index];
    final fontFamily = AppFontFamily.values[
        prefs.getInt(_keyFontFamily) ?? AppFontFamily.inter.index];
    final fontSizeScale = FontSizeScale.values[
        prefs.getInt(_keyFontSizeScale) ?? FontSizeScale.medium.index];
    final sortOrder = NoteSortOrder.values[
        prefs.getInt(_keySortOrder) ?? NoteSortOrder.newestFirst.index];
    final noteLayout = NoteLayout.values[
        prefs.getInt(_keyNoteLayout) ?? NoteLayout.list.index];
    final compactCards = prefs.getBool(_keyCompactCards) ?? false;

    emit(SettingsState(
      themeMode: themeMode,
      accentColor: accentColor,
      fontFamily: fontFamily,
      fontSizeScale: fontSizeScale,
      sortOrder: sortOrder,
      noteLayout: noteLayout,
      compactCards: compactCards,
      isLoaded: true,
    ));
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyThemeMode, state.themeMode.index);
    await prefs.setInt(_keyAccentColor, state.accentColor.index);
    await prefs.setInt(_keyFontFamily, state.fontFamily.index);
    await prefs.setInt(_keyFontSizeScale, state.fontSizeScale.index);
    await prefs.setInt(_keySortOrder, state.sortOrder.index);
    await prefs.setInt(_keyNoteLayout, state.noteLayout.index);
    await prefs.setBool(_keyCompactCards, state.compactCards);
  }

  void setThemeMode(AppThemeMode mode) {
    emit(state.copyWith(themeMode: mode));
    _save();
  }

  void setAccentColor(AccentColor color) {
    emit(state.copyWith(accentColor: color));
    _save();
  }

  void setFontFamily(AppFontFamily font) {
    emit(state.copyWith(fontFamily: font));
    _save();
  }

  void setFontSizeScale(FontSizeScale scale) {
    emit(state.copyWith(fontSizeScale: scale));
    _save();
  }

  void setSortOrder(NoteSortOrder order) {
    emit(state.copyWith(sortOrder: order));
    _save();
  }

  void toggleLayout() {
    final newLayout = state.noteLayout == NoteLayout.list
        ? NoteLayout.grid
        : NoteLayout.list;
    emit(state.copyWith(noteLayout: newLayout));
    _save();
  }

  void setNoteLayout(NoteLayout layout) {
    emit(state.copyWith(noteLayout: layout));
    _save();
  }

  void toggleCompactCards() {
    emit(state.copyWith(compactCards: !state.compactCards));
    _save();
  }

  void setCompactCards(bool value) {
    emit(state.copyWith(compactCards: value));
    _save();
  }

  void resetToDefaults() {
    emit(const SettingsState(isLoaded: true));
    _save();
  }
}

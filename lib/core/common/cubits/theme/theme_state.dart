part of 'theme_cubit.dart';

@immutable
sealed class ThemeState {}

final class ThemeInitial extends ThemeState {}

final class ThemeLoaded extends ThemeState {
  final ThemeData themeData;
  final bool isDarkMode;

  ThemeLoaded({
    required this.themeData,
    required this.isDarkMode,
  });
}

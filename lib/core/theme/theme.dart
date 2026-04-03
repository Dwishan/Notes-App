import 'package:minimal_notes_app/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static final lightThemeMode = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      surface: AppPallete.lightSurface,
      primary: AppPallete.lightPrimary,
      secondary: AppPallete.lightSecondary,
      inversePrimary: AppPallete.lightInversePrimary,
    ),
  );

  static final darkThemeMode = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      surface: AppPallete.darkSurface,
      primary: AppPallete.darkPrimary,
      secondary: AppPallete.darkSecondary,
      inversePrimary: AppPallete.darkInversePrimary,
    ),
  );
}

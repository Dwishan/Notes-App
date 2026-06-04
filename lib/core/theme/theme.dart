import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minimal_notes_app/core/common/cubits/settings/settings_cubit.dart';
import 'package:minimal_notes_app/core/theme/app_pallete.dart';

class AppTheme {
  /// Returns the Google Fonts text style factory for the given font family.
  static TextStyle Function({
    TextStyle? textStyle,
    Color? color,
    Color? backgroundColor,
    double? fontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    double? letterSpacing,
    double? wordSpacing,
    TextBaseline? textBaseline,
    double? height,
    Locale? locale,
    Paint? foreground,
    Paint? background,
    List<Shadow>? shadows,
    List<FontFeature>? fontFeatures,
    TextDecoration? decoration,
    Color? decorationColor,
    TextDecorationStyle? decorationStyle,
    double? decorationThickness,
  }) fontStyleFor(AppFontFamily family) {
    switch (family) {
      case AppFontFamily.inter:
        return GoogleFonts.inter;
      case AppFontFamily.roboto:
        return GoogleFonts.roboto;
      case AppFontFamily.poppins:
        return GoogleFonts.poppins;
      case AppFontFamily.dmSerifText:
        return GoogleFonts.dmSerifText;
      case AppFontFamily.lora:
        return GoogleFonts.lora;
      case AppFontFamily.spaceGrotesk:
        return GoogleFonts.spaceGrotesk;
    }
  }

  /// Display name for a given font family.
  static String fontDisplayName(AppFontFamily family) {
    switch (family) {
      case AppFontFamily.inter:
        return 'Inter';
      case AppFontFamily.roboto:
        return 'Roboto';
      case AppFontFamily.poppins:
        return 'Poppins';
      case AppFontFamily.dmSerifText:
        return 'DM Serif Text';
      case AppFontFamily.lora:
        return 'Lora';
      case AppFontFamily.spaceGrotesk:
        return 'Space Grotesk';
    }
  }

  /// Build FThemeData from the settings state.
  static FThemeData buildTheme(SettingsState settings) {
    final isDark = settings.isDarkMode;
    final accentColor = AppPallete.accentToColor(settings.accentColor);

    final baseTheme = isDark ? FThemes.zinc.dark.touch : FThemes.zinc.light.touch;
    
    final accentColorBrightness = ThemeData.estimateBrightnessForColor(accentColor);
    final primaryForeground = accentColorBrightness == Brightness.dark
        ? const Color(0xFFFAFAFA)
        : const Color(0xFF18181B);

    final customColors = baseTheme.colors.copyWith(
      primary: accentColor,
      primaryForeground: primaryForeground,
      background: isDark ? const Color(0xFF09090B) : const Color(0xFFF5F5F7),
    );

    final fontGetter = fontStyleFor(settings.fontFamily);
    final String fontFamilyName = fontGetter().fontFamily ?? FTypography.defaultFontFamily;

    final customTypography = FTypography.inherit(
      colors: customColors,
      touch: true,
      fontFamily: fontFamilyName,
    ).scale(sizeScalar: settings.fontSizeMultiplier);

    return FThemeData(
      colors: customColors,
      typography: customTypography,
      touch: true,
    );
  }

  /// Build a Material ThemeData that works alongside forui, with accent colors applied.
  static ThemeData buildMaterialTheme(SettingsState settings) {
    final isDark = settings.isDarkMode;
    final accentColor = AppPallete.accentToColor(settings.accentColor);
    final fontGetter = fontStyleFor(settings.fontFamily);
    final multiplier = settings.fontSizeMultiplier;

    final accentColorBrightness = ThemeData.estimateBrightnessForColor(accentColor);
    final primaryForeground = accentColorBrightness == Brightness.dark
        ? const Color(0xFFFAFAFA)
        : const Color(0xFF18181B);

    final colorScheme = ColorScheme.fromSeed(
      seedColor: accentColor,
      brightness: isDark ? Brightness.dark : Brightness.light,
    ).copyWith(
      primary: accentColor,
      onPrimary: primaryForeground,
    );

    final textTheme = TextTheme(
      displayLarge: fontGetter(fontSize: 57 * multiplier),
      displayMedium: fontGetter(fontSize: 45 * multiplier),
      displaySmall: fontGetter(fontSize: 36 * multiplier),
      headlineLarge: fontGetter(fontSize: 32 * multiplier),
      headlineMedium: fontGetter(fontSize: 28 * multiplier),
      headlineSmall: fontGetter(fontSize: 24 * multiplier),
      titleLarge: fontGetter(fontSize: 22 * multiplier),
      titleMedium: fontGetter(fontSize: 16 * multiplier),
      titleSmall: fontGetter(fontSize: 14 * multiplier),
      bodyLarge: fontGetter(fontSize: 16 * multiplier),
      bodyMedium: fontGetter(fontSize: 14 * multiplier),
      bodySmall: fontGetter(fontSize: 12 * multiplier),
      labelLarge: fontGetter(fontSize: 14 * multiplier),
      labelMedium: fontGetter(fontSize: 12 * multiplier),
      labelSmall: fontGetter(fontSize: 11 * multiplier),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: isDark ? Brightness.dark : Brightness.light,
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: isDark
          ? const Color(0xFF09090B)
          : const Color(0xFFF5F5F7),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),
    );
  }
}

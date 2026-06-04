part of 'settings_cubit.dart';

enum AppThemeMode { light, dark, system }

enum AccentColor {
  blue,
  purple,
  teal,
  rose,
  amber,
  green,
  indigo,
  orange,
  red,
  cyan,
}

enum AppFontFamily {
  inter,
  roboto,
  poppins,
  dmSerifText,
  lora,
  spaceGrotesk,
}

enum FontSizeScale {
  small,
  medium,
  large,
  extraLarge,
}

enum NoteSortOrder {
  newestFirst,
  oldestFirst,
  alphabetical,
}

enum NoteLayout { list, grid }

@immutable
class SettingsState extends Equatable {
  final AppThemeMode themeMode;
  final AccentColor accentColor;
  final AppFontFamily fontFamily;
  final FontSizeScale fontSizeScale;
  final NoteSortOrder sortOrder;
  final NoteLayout noteLayout;
  final bool compactCards;
  final bool isLoaded;

  const SettingsState({
    this.themeMode = AppThemeMode.dark,
    this.accentColor = AccentColor.blue,
    this.fontFamily = AppFontFamily.inter,
    this.fontSizeScale = FontSizeScale.medium,
    this.sortOrder = NoteSortOrder.newestFirst,
    this.noteLayout = NoteLayout.list,
    this.compactCards = false,
    this.isLoaded = false,
  });

  bool get isDarkMode {
    if (themeMode == AppThemeMode.system) {
      return WidgetsBinding.instance.platformDispatcher.platformBrightness ==
          Brightness.dark;
    }
    return themeMode == AppThemeMode.dark;
  }

  double get fontSizeMultiplier {
    switch (fontSizeScale) {
      case FontSizeScale.small:
        return 0.85;
      case FontSizeScale.medium:
        return 1.0;
      case FontSizeScale.large:
        return 1.15;
      case FontSizeScale.extraLarge:
        return 1.3;
    }
  }

  SettingsState copyWith({
    AppThemeMode? themeMode,
    AccentColor? accentColor,
    AppFontFamily? fontFamily,
    FontSizeScale? fontSizeScale,
    NoteSortOrder? sortOrder,
    NoteLayout? noteLayout,
    bool? compactCards,
    bool? isLoaded,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      accentColor: accentColor ?? this.accentColor,
      fontFamily: fontFamily ?? this.fontFamily,
      fontSizeScale: fontSizeScale ?? this.fontSizeScale,
      sortOrder: sortOrder ?? this.sortOrder,
      noteLayout: noteLayout ?? this.noteLayout,
      compactCards: compactCards ?? this.compactCards,
      isLoaded: isLoaded ?? this.isLoaded,
    );
  }

  @override
  List<Object?> get props => [
        themeMode,
        accentColor,
        fontFamily,
        fontSizeScale,
        sortOrder,
        noteLayout,
        compactCards,
        isLoaded,
      ];
}

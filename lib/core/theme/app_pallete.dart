import 'package:flutter/material.dart';
import 'package:minimal_notes_app/core/common/cubits/settings/settings_cubit.dart';

class AppPallete {
  // Common Colors
  static const Color whiteColor = Colors.white;
  static const Color greyColor = Colors.grey;
  static const Color errorColor = Colors.redAccent;
  static const Color transparentColor = Colors.transparent;

  /// Returns the primary color swatch for a given accent.
  static Color accentToColor(AccentColor accent) {
    switch (accent) {
      case AccentColor.blue:
        return const Color(0xFF3B82F6);
      case AccentColor.purple:
        return const Color(0xFF8B5CF6);
      case AccentColor.teal:
        return const Color(0xFF14B8A6);
      case AccentColor.rose:
        return const Color(0xFFF43F5E);
      case AccentColor.amber:
        return const Color(0xFFF59E0B);
      case AccentColor.green:
        return const Color(0xFF22C55E);
      case AccentColor.indigo:
        return const Color(0xFF6366F1);
      case AccentColor.orange:
        return const Color(0xFFF97316);
      case AccentColor.red:
        return const Color(0xFFEF4444);
      case AccentColor.cyan:
        return const Color(0xFF06B6D4);
    }
  }

  /// Display name for a given accent color.
  static String accentDisplayName(AccentColor accent) {
    switch (accent) {
      case AccentColor.blue:
        return 'Blue';
      case AccentColor.purple:
        return 'Purple';
      case AccentColor.teal:
        return 'Teal';
      case AccentColor.rose:
        return 'Rose';
      case AccentColor.amber:
        return 'Amber';
      case AccentColor.green:
        return 'Green';
      case AccentColor.indigo:
        return 'Indigo';
      case AccentColor.orange:
        return 'Orange';
      case AccentColor.red:
        return 'Red';
      case AccentColor.cyan:
        return 'Cyan';
    }
  }
}

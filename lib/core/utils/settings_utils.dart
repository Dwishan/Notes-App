import 'package:minimal_notes_app/core/common/cubits/settings/settings_cubit.dart';
import 'package:minimal_notes_app/core/constants/app_strings.dart';

String getFontSizeLabel(FontSizeScale scale) {
  switch (scale) {
    case FontSizeScale.small:
      return AppStrings.fontSizeSmall;
    case FontSizeScale.medium:
      return AppStrings.fontSizeMedium;
    case FontSizeScale.large:
      return AppStrings.fontSizeLarge;
    case FontSizeScale.extraLarge:
      return AppStrings.fontSizeExtraLarge;
  }
}

String getSortOrderLabel(NoteSortOrder order) {
  switch (order) {
    case NoteSortOrder.newestFirst:
      return AppStrings.sortNewest;
    case NoteSortOrder.oldestFirst:
      return AppStrings.sortOldest;
    case NoteSortOrder.alphabetical:
      return AppStrings.sortAlphabetical;
  }
}

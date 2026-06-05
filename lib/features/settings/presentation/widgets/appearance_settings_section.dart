import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:minimal_notes_app/core/common/cubits/settings/settings_cubit.dart';
import 'package:minimal_notes_app/core/theme/app_pallete.dart';
import 'package:minimal_notes_app/core/theme/theme.dart';
import 'package:minimal_notes_app/core/constants/app_strings.dart';
import 'package:minimal_notes_app/core/utils/settings_utils.dart';

class AppearanceSettingsSection extends StatelessWidget {
  final SettingsState settings;

  const AppearanceSettingsSection({
    super.key,
    required this.settings,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FTileGroup(
      physics: const NeverScrollableScrollPhysics(),
      label: const Text(AppStrings.appearance),
      children: [
        // Theme Mode
        FTile.raw(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.theme,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                AppStrings.chooseAppearance,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 16),
              FTabs(
                style: FTabsStyleDelta.delta(
                  spacing: 0,
                  indicatorDecoration: DecorationDelta.shapeDelta(
                    color: theme.colorScheme.primary,
                  ),
                  labelTextStyle: FVariantsDelta.delta([
                    FVariantOperation.exact(
                      {FTabVariant.selected},
                      TextStyleDelta.delta(
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                  ]),
                ),
                control: FTabControl.lifted(
                  index: settings.themeMode.index,
                  onChange: (index) {
                    context.read<SettingsCubit>().setThemeMode(AppThemeMode.values[index]);
                  },
                ),
                children: const [
                  FTabEntry(
                    label: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(LucideIcons.sun, size: 16),
                        SizedBox(width: 6),
                        Text(AppStrings.light),
                      ],
                    ),
                    child: SizedBox.shrink(),
                  ),
                  FTabEntry(
                    label: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(LucideIcons.moon, size: 16),
                        SizedBox(width: 6),
                        Text(AppStrings.dark),
                      ],
                    ),
                    child: SizedBox.shrink(),
                  ),
                  FTabEntry(
                    label: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(LucideIcons.monitor, size: 16),
                        SizedBox(width: 6),
                        Text(AppStrings.system),
                      ],
                    ),
                    child: SizedBox.shrink(),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Accent Color
        FTile.raw(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.accentColor,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                AppStrings.personalizeAccent,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: AccentColor.values.map((accent) {
                  final color = AppPallete.accentToColor(accent);
                  final isSelected = settings.accentColor == accent;
                  return GestureDetector(
                    onTap: () => context.read<SettingsCubit>().setAccentColor(accent),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(
                                color: theme.colorScheme.onSurface,
                                width: 2.5,
                              )
                            : Border.all(
                                color: theme.colorScheme.outline.withValues(alpha: 0.25),
                                width: 1.5,
                              ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: color.withValues(alpha: 0.4),
                                  blurRadius: 12,
                                  spreadRadius: 1,
                                )
                              ]
                            : null,
                      ),
                      child: isSelected ? const Icon(LucideIcons.check, color: Colors.white, size: 20) : null,
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),

        // Font Family
        FTile.raw(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.fontFamily,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                AppStrings.selectFontFamily,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: AppFontFamily.values.map((font) {
                  final isSelected = settings.fontFamily == font;
                  final fontStyle = AppTheme.fontStyleFor(font);
                  return GestureDetector(
                    onTap: () => context.read<SettingsCubit>().setFontFamily(font),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? theme.colorScheme.primary.withValues(alpha: 0.15)
                            : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? theme.colorScheme.primary : theme.colorScheme.outline.withValues(alpha: 0.2),
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      child: Text(
                        AppTheme.fontDisplayName(font),
                        style: fontStyle(
                          fontSize: 13,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                          color: isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurface.withValues(alpha: 0.8),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),

        // Font Size
        FTile.raw(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.fontSize,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                AppStrings.adjustFontSize,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: FontSizeScale.values.map((scale) {
                  final isSelected = settings.fontSizeScale == scale;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => context.read<SettingsCubit>().setFontSizeScale(scale),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? theme.colorScheme.primary.withValues(alpha: 0.15)
                              : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? theme.colorScheme.primary : theme.colorScheme.outline.withValues(alpha: 0.2),
                            width: isSelected ? 1.5 : 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Aa',
                              style: TextStyle(
                                fontSize: 14 * scale.index * 0.15 + 14,
                                fontWeight: FontWeight.w600,
                                color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface.withValues(alpha: 0.7),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              getFontSizeLabel(scale),
                              style: TextStyle(
                                fontSize: 10,
                                color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface.withValues(alpha: 0.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

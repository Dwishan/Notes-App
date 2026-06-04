import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';
import 'package:minimal_notes_app/core/common/cubits/settings/settings_cubit.dart';
import 'package:minimal_notes_app/core/theme/app_pallete.dart';
import 'package:minimal_notes_app/core/theme/theme.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: theme.colorScheme.onSurface,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Settings',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, settings) {
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            children: [
              // ── Appearance Section ──
              FTileGroup(
                physics: const NeverScrollableScrollPhysics(),
                label: const Text('Appearance'),
                children: [
                  // Theme Mode
                  FTile.raw(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Theme',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Choose your preferred appearance',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
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
                              context
                                  .read<SettingsCubit>()
                                  .setThemeMode(AppThemeMode.values[index]);
                            },
                          ),
                          children: const [
                            FTabEntry(
                              label: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.light_mode_rounded, size: 16),
                                  SizedBox(width: 6),
                                  Text('Light'),
                                ],
                              ),
                              child: SizedBox.shrink(),
                            ),
                            FTabEntry(
                              label: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.dark_mode_rounded, size: 16),
                                  SizedBox(width: 6),
                                  Text('Dark'),
                                ],
                              ),
                              child: SizedBox.shrink(),
                            ),
                            FTabEntry(
                              label: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.settings_brightness_rounded,
                                      size: 16),
                                  SizedBox(width: 6),
                                  Text('System'),
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
                          'Accent Color',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Personalize the app with your favorite color',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
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
                              onTap: () => context
                                  .read<SettingsCubit>()
                                  .setAccentColor(accent),
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
                                          color: theme.colorScheme.outline
                                              .withValues(alpha: 0.25),
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
                                child: isSelected
                                    ? const Icon(Icons.check_rounded,
                                        color: Colors.white, size: 20)
                                    : null,
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
                          'Font Family',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Select the typeface used throughout the app',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
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
                              onTap: () => context
                                  .read<SettingsCubit>()
                                  .setFontFamily(font),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 10),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? theme.colorScheme.primary
                                          .withValues(alpha: 0.15)
                                      : theme
                                          .colorScheme.surfaceContainerHighest
                                          .withValues(alpha: 0.4),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected
                                        ? theme.colorScheme.primary
                                        : theme.colorScheme.outline
                                            .withValues(alpha: 0.2),
                                    width: isSelected ? 1.5 : 1,
                                  ),
                                ),
                                child: Text(
                                  AppTheme.fontDisplayName(font),
                                  style: fontStyle(
                                    fontSize: 13,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                    color: isSelected
                                        ? theme.colorScheme.primary
                                        : theme.colorScheme.onSurface
                                            .withValues(alpha: 0.8),
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
                          'Font Size',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Adjust the text size across the entire app',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: FontSizeScale.values.map((scale) {
                            final isSelected = settings.fontSizeScale == scale;
                            return Expanded(
                              child: GestureDetector(
                                onTap: () => context
                                    .read<SettingsCubit>()
                                    .setFontSizeScale(scale),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 3),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? theme.colorScheme.primary
                                            .withValues(alpha: 0.15)
                                        : theme
                                            .colorScheme.surfaceContainerHighest
                                            .withValues(alpha: 0.4),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isSelected
                                          ? theme.colorScheme.primary
                                          : theme.colorScheme.outline
                                              .withValues(alpha: 0.2),
                                      width: isSelected ? 1.5 : 1,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Aa',
                                        style: TextStyle(
                                          fontSize:
                                              14 * scale.index * 0.15 + 14,
                                          fontWeight: FontWeight.w600,
                                          color: isSelected
                                              ? theme.colorScheme.primary
                                              : theme.colorScheme.onSurface
                                                  .withValues(alpha: 0.7),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        _fontSizeLabel(scale),
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: isSelected
                                              ? theme.colorScheme.primary
                                              : theme.colorScheme.onSurface
                                                  .withValues(alpha: 0.5),
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
              ),
              const SizedBox(height: 20),

              // ── Notes Section ──
              FTileGroup(
                physics: const NeverScrollableScrollPhysics(),
                label: const Text('Notes'),
                children: [
                  // Default Layout
                  FTile(
                    title: const Text('Default Layout'),
                    subtitle: Text(settings.noteLayout == NoteLayout.list
                        ? 'List view'
                        : 'Grid view'),
                    details: _LayoutToggle(
                      isGrid: settings.noteLayout == NoteLayout.grid,
                      onChanged: (isGrid) {
                        context.read<SettingsCubit>().setNoteLayout(
                              isGrid ? NoteLayout.grid : NoteLayout.list,
                            );
                      },
                    ),
                  ),

                  // Compact Cards
                  FTile(
                    title: const Text('Compact Cards'),
                    subtitle: const Text('Show notes with less spacing'),
                    details: FSwitch(
                      value: settings.compactCards,
                      onChange: (value) {
                        context.read<SettingsCubit>().setCompactCards(value);
                      },
                    ),
                  ),

                  // Sort Order
                  FTile.raw(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Default Sort Order',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'How notes are ordered in the list',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: NoteSortOrder.values.map((order) {
                            final isSelected = settings.sortOrder == order;
                            return Expanded(
                              child: GestureDetector(
                                onTap: () => context
                                    .read<SettingsCubit>()
                                    .setSortOrder(order),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 3),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? theme.colorScheme.primary
                                            .withValues(alpha: 0.15)
                                        : theme
                                            .colorScheme.surfaceContainerHighest
                                            .withValues(alpha: 0.4),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isSelected
                                          ? theme.colorScheme.primary
                                          : theme.colorScheme.outline
                                              .withValues(alpha: 0.2),
                                      width: isSelected ? 1.5 : 1,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      _sortOrderLabel(order),
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: isSelected
                                            ? FontWeight.w600
                                            : FontWeight.w400,
                                        color: isSelected
                                            ? theme.colorScheme.primary
                                            : theme.colorScheme.onSurface
                                                .withValues(alpha: 0.7),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
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
              ),
              const SizedBox(height: 20),

              // ── About Section ──
              FTileGroup(
                physics: const NeverScrollableScrollPhysics(),
                label: const Text('About'),
                children: [
                  // App Version Info
                  FTile(
                    prefix: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color:
                            theme.colorScheme.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.sticky_note_2_rounded,
                        color: theme.colorScheme.primary,
                        size: 24,
                      ),
                    ),
                    title: const Text('Notes'),
                    subtitle: const Text('Version 1.0.0'),
                  ),

                  // Reset Defaults Button
                  FTile.raw(
                    child: SizedBox(
                      width: double.infinity,
                      child: FButton(
                        variant: FButtonVariant.outline,
                        onPress: () {
                          context.read<SettingsCubit>().resetToDefaults();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Settings reset to defaults'),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              margin: const EdgeInsets.all(16),
                            ),
                          );
                        },
                        child: const Text('Reset to Defaults'),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          );
        },
      ),
    );
  }

  static String _fontSizeLabel(FontSizeScale scale) {
    switch (scale) {
      case FontSizeScale.small:
        return 'Small';
      case FontSizeScale.medium:
        return 'Medium';
      case FontSizeScale.large:
        return 'Large';
      case FontSizeScale.extraLarge:
        return 'XL';
    }
  }

  static String _sortOrderLabel(NoteSortOrder order) {
    switch (order) {
      case NoteSortOrder.newestFirst:
        return 'Newest';
      case NoteSortOrder.oldestFirst:
        return 'Oldest';
      case NoteSortOrder.alphabetical:
        return 'A → Z';
    }
  }
}

// ── Helper Widgets ──

class _LayoutToggle extends StatelessWidget {
  final bool isGrid;
  final ValueChanged<bool> onChanged;

  const _LayoutToggle({required this.isGrid, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _LayoutToggleButton(
            icon: Icons.view_list_rounded,
            isSelected: !isGrid,
            onTap: () => onChanged(false),
            isLeft: true,
          ),
          _LayoutToggleButton(
            icon: Icons.grid_view_rounded,
            isSelected: isGrid,
            onTap: () => onChanged(true),
            isLeft: false,
          ),
        ],
      ),
    );
  }
}

class _LayoutToggleButton extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isLeft;

  const _LayoutToggleButton({
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.isLeft,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.horizontal(
            left: isLeft ? const Radius.circular(11) : Radius.zero,
            right: isLeft ? Radius.zero : const Radius.circular(11),
          ),
        ),
        child: Icon(
          icon,
          size: 20,
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurface.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}

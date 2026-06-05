import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';
import 'package:minimal_notes_app/core/common/cubits/settings/settings_cubit.dart';
import 'package:minimal_notes_app/core/constants/app_strings.dart';
import 'package:minimal_notes_app/core/common/widgets/layout_toggle.dart';
import 'package:minimal_notes_app/core/utils/settings_utils.dart';

class NotesSettingsSection extends StatelessWidget {
  final SettingsState settings;

  const NotesSettingsSection({
    super.key,
    required this.settings,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FTileGroup(
      physics: const NeverScrollableScrollPhysics(),
      label: const Text(AppStrings.notesSection),
      children: [
        // Default Layout
        FTile(
          title: const Text(AppStrings.defaultLayout),
          subtitle: Text(settings.noteLayout == NoteLayout.list ? AppStrings.listView : AppStrings.gridView),
          details: LayoutToggle(
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
          title: const Text(AppStrings.compactCards),
          subtitle: const Text(AppStrings.compactCardsSubtitle),
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
                AppStrings.defaultSortOrder,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                AppStrings.sortOrderSubtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: NoteSortOrder.values.map((order) {
                  final isSelected = settings.sortOrder == order;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => context.read<SettingsCubit>().setSortOrder(order),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        padding: const EdgeInsets.symmetric(vertical: 10),
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
                        child: Center(
                          child: Text(
                            getSortOrderLabel(order),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                              color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface.withValues(alpha: 0.7),
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
    );
  }
}

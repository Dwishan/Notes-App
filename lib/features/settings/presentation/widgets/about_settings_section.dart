import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:minimal_notes_app/core/common/cubits/settings/settings_cubit.dart';
import 'package:minimal_notes_app/core/constants/app_strings.dart';

class AboutSettingsSection extends StatelessWidget {
  const AboutSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FTileGroup(
      physics: const NeverScrollableScrollPhysics(),
      label: const Text(AppStrings.about),
      children: [
        // App Version Info
        FTile(
          prefix: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              LucideIcons.sticky_note,
              color: theme.colorScheme.primary,
              size: 24,
            ),
          ),
          title: const Text(AppStrings.notesSection),
          subtitle: const Text(AppStrings.appVersion),
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
                    content: const Text(AppStrings.settingsResetSuccess),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.all(16),
                  ),
                );
              },
              child: const Text(AppStrings.resetToDefaults),
            ),
          ),
        ),
      ],
    );
  }
}

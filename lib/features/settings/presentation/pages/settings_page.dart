import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:minimal_notes_app/core/common/cubits/settings/settings_cubit.dart';
import 'package:minimal_notes_app/core/constants/app_strings.dart';
import 'package:minimal_notes_app/features/settings/presentation/widgets/appearance_settings_section.dart';
import 'package:minimal_notes_app/features/settings/presentation/widgets/notes_settings_section.dart';
import 'package:minimal_notes_app/features/settings/presentation/widgets/about_settings_section.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: theme.scaffoldBackgroundColor,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        extendBodyBehindAppBar: false,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: FHeader.nested(
                  title: const Text(AppStrings.settings),
                  prefixes: [
                    FHeaderAction(
                      icon: Icon(
                        LucideIcons.chevron_left,
                        color: theme.colorScheme.onSurface,
                        size: theme.textTheme.titleLarge?.fontSize ?? 22,
                      ),
                      onPress: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: BlocBuilder<SettingsCubit, SettingsState>(
                  builder: (context, settings) {
                    return ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      children: [
                        AppearanceSettingsSection(settings: settings),
                        const SizedBox(height: 20),
                        NotesSettingsSection(settings: settings),
                        const SizedBox(height: 20),
                        const AboutSettingsSection(),
                        const SizedBox(height: 40),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

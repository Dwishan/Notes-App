import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';
import 'package:minimal_notes_app/core/common/cubits/settings/settings_cubit.dart';
import 'package:minimal_notes_app/core/theme/theme.dart';
import 'package:minimal_notes_app/features/note/presentation/pages/notes_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, settings) {
        final fTheme = AppTheme.buildTheme(settings);
        final materialTheme = AppTheme.buildMaterialTheme(settings);
        final isDark = settings.isDarkMode;

        return FTheme(
          data: fTheme,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Notes',
            theme: materialTheme,
            home: AnnotatedRegion<SystemUiOverlayStyle>(
              value: isDark
                  ? SystemUiOverlayStyle.light.copyWith(
                      statusBarColor: Colors.transparent,
                      systemNavigationBarColor: const Color(0xFF09090B),
                    )
                  : SystemUiOverlayStyle.dark.copyWith(
                      statusBarColor: Colors.transparent,
                      systemNavigationBarColor: Colors.white,
                    ),
              child: const NotesPage(),
            ),
          ),
        );
      },
    );
  }
}

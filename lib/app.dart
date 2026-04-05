import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minimal_notes_app/core/common/cubits/theme/theme_cubit.dart';
import 'package:minimal_notes_app/features/note/presentation/pages/notes_page.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final isDarkMode = state is ThemeLoaded && state.isDarkMode;

        return ShadApp(
          debugShowCheckedModeBanner: false,
          title: 'Minimal Notes',
          themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: const NotesPage(),
          theme: ShadThemeData(
            brightness: Brightness.light,
            colorScheme: ShadColorScheme.fromName('zinc'),
          ),
          darkTheme: ShadThemeData(
            brightness: Brightness.dark,
            colorScheme:
                ShadColorScheme.fromName('zinc', brightness: Brightness.dark),
          ),
        );
      },
    );
  }
}

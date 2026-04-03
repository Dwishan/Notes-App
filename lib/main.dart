import 'package:minimal_notes_app/core/common/cubits/theme/theme_cubit.dart';
import 'package:minimal_notes_app/core/theme/theme.dart';
import 'package:minimal_notes_app/features/note/presentation/bloc/note_bloc.dart';
import 'package:minimal_notes_app/features/note/presentation/pages/notes_page.dart';
import 'package:minimal_notes_app/init_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (_) => serviceLocator<ThemeCubit>(),
      ),
      BlocProvider(
        create: (_) => serviceLocator<NoteBloc>(),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final themeData = state is ThemeLoaded
            ? state.themeData
            : AppTheme.lightThemeMode;
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Minimal Notes',
          theme: themeData,
          home: const NotesPage(),
        );
      },
    );
  }
}

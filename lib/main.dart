import 'package:minimal_notes_app/app.dart';
import 'package:minimal_notes_app/core/common/cubits/theme/theme_cubit.dart';
import 'package:minimal_notes_app/features/note/presentation/bloc/note_bloc.dart';
import 'package:minimal_notes_app/features/note/presentation/cubit/note_layout_cubit.dart';
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
      BlocProvider(
        create: (_) => serviceLocator<NoteLayoutCubit>(),
      ),
    ],
    child: const MyApp(),
  ));
}

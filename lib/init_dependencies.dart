import 'package:minimal_notes_app/core/common/cubits/theme/theme_cubit.dart';
import 'package:minimal_notes_app/features/note/data/datasources/note_local_data_source.dart';
import 'package:minimal_notes_app/features/note/data/repositories/note_repository_impl.dart';
import 'package:minimal_notes_app/features/note/domain/repositories/note_repository.dart';
import 'package:minimal_notes_app/features/note/domain/usecases/add_note.dart';
import 'package:minimal_notes_app/features/note/domain/usecases/delete_note.dart';
import 'package:minimal_notes_app/features/note/domain/usecases/get_all_notes.dart';
import 'package:minimal_notes_app/features/note/domain/usecases/update_note.dart';
import 'package:minimal_notes_app/features/note/presentation/bloc/note_bloc.dart';
import 'package:minimal_notes_app/features/note/data/models/isar_note.dart';
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

part 'init_dependencies.main.dart';

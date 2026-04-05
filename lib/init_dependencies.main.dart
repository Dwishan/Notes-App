part of 'init_dependencies.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initNote();

  // Initialize Isar database
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open([IsarNoteSchema], directory: dir.path);

  serviceLocator.registerLazySingleton(() => isar);

  // Core
  serviceLocator.registerLazySingleton(
    () => ThemeCubit(),
  );
}

void _initNote() {
  // Datasource
  serviceLocator
    ..registerFactory<NoteLocalDataSource>(
      () => NoteLocalDataSourceImpl(
        serviceLocator(),
      ),
    )
    // Repository
    ..registerFactory<NoteRepository>(
      () => NoteRepositoryImpl(
        serviceLocator(),
      ),
    )
    // Usecases
    ..registerFactory(
      () => AddNote(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => GetAllNotes(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UpdateNote(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => DeleteNote(
        serviceLocator(),
      ),
    )
    // Cubit
    ..registerLazySingleton(
      () => NoteLayoutCubit(),
    )
    // Bloc
    ..registerLazySingleton(
      () => NoteBloc(
        addNote: serviceLocator(),
        getAllNotes: serviceLocator(),
        updateNote: serviceLocator(),
        deleteNote: serviceLocator(),
      ),
    );
}

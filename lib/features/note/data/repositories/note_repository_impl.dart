import 'package:minimal_notes_app/core/error/exceptions.dart';
import 'package:minimal_notes_app/core/error/failures.dart';
import 'package:minimal_notes_app/features/note/data/datasources/note_local_data_source.dart';
import 'package:minimal_notes_app/features/note/domain/entities/note.dart';
import 'package:minimal_notes_app/features/note/domain/repositories/note_repository.dart';
import 'package:fpdart/fpdart.dart';

class NoteRepositoryImpl implements NoteRepository {
  final NoteLocalDataSource noteLocalDataSource;
  NoteRepositoryImpl(this.noteLocalDataSource);

  @override
  Future<Either<Failure, Note>> addNote({required String text}) async {
    try {
      final note = await noteLocalDataSource.addNote(text: text);
      return right(note);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Note>>> getAllNotes() async {
    try {
      final notes = await noteLocalDataSource.getAllNotes();
      return right(notes);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, Note>> updateNote({
    required int id,
    required String newText,
  }) async {
    try {
      final note = await noteLocalDataSource.updateNote(
        id: id,
        newText: newText,
      );
      return right(note);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, Note>> deleteNote({required int id}) async {
    try {
      final note = await noteLocalDataSource.deleteNote(id: id);
      return right(note);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}

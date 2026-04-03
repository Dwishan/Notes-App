import 'package:minimal_notes_app/core/error/failures.dart';
import 'package:minimal_notes_app/features/note/domain/entities/note.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class NoteRepository {
  Future<Either<Failure, Note>> addNote({
    required String text,
  });

  Future<Either<Failure, List<Note>>> getAllNotes();

  Future<Either<Failure, Note>> updateNote({
    required int id,
    required String newText,
  });

  Future<Either<Failure, Note>> deleteNote({
    required int id,
  });
}

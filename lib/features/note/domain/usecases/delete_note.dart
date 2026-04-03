import 'package:minimal_notes_app/core/error/failures.dart';
import 'package:minimal_notes_app/core/usecase/usecase.dart';
import 'package:minimal_notes_app/features/note/domain/repositories/note_repository.dart';
import 'package:minimal_notes_app/features/note/domain/entities/note.dart';
import 'package:fpdart/fpdart.dart';

class DeleteNote implements UseCase<Note, DeleteNoteParams> {
  final NoteRepository noteRepository;
  DeleteNote(this.noteRepository);

  @override
  Future<Either<Failure, Note>> call(DeleteNoteParams params) async {
    return await noteRepository.deleteNote(
      id: params.id,
    );
  }
}

class DeleteNoteParams {
  final int id;

  DeleteNoteParams({
    required this.id,
  });
}

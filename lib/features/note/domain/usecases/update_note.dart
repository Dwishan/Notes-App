import 'package:minimal_notes_app/core/error/failures.dart';
import 'package:minimal_notes_app/core/usecase/usecase.dart';
import 'package:minimal_notes_app/features/note/domain/entities/note.dart';
import 'package:minimal_notes_app/features/note/domain/repositories/note_repository.dart';
import 'package:fpdart/fpdart.dart';

class UpdateNote implements UseCase<Note, UpdateNoteParams> {
  final NoteRepository noteRepository;
  UpdateNote(this.noteRepository);

  @override
  Future<Either<Failure, Note>> call(UpdateNoteParams params) async {
    return await noteRepository.updateNote(
      id: params.id,
      newTitle: params.newTitle,
      newDescription: params.newDescription,
    );
  }
}

class UpdateNoteParams {
  final int id;
  final String newTitle;
  final String? newDescription;

  UpdateNoteParams({
    required this.id,
    required this.newTitle,
    this.newDescription,
  });
}


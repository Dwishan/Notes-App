import 'package:minimal_notes_app/core/error/failures.dart';
import 'package:minimal_notes_app/core/usecase/usecase.dart';
import 'package:minimal_notes_app/features/note/domain/entities/note.dart';
import 'package:minimal_notes_app/features/note/domain/repositories/note_repository.dart';
import 'package:fpdart/fpdart.dart';

class AddNote implements UseCase<Note, AddNoteParams> {
  final NoteRepository noteRepository;
  AddNote(this.noteRepository);

  @override
  Future<Either<Failure, Note>> call(AddNoteParams params) async {
    return await noteRepository.addNote(
      title: params.title,
      description: params.description,
    );
  }
}

class AddNoteParams {
  final String title;
  final String? description;

  AddNoteParams({
    required this.title,
    this.description,
  });
}


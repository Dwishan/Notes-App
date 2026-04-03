import 'package:minimal_notes_app/core/error/failures.dart';
import 'package:minimal_notes_app/core/usecase/usecase.dart';
import 'package:minimal_notes_app/features/note/domain/entities/note.dart';
import 'package:minimal_notes_app/features/note/domain/repositories/note_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetAllNotes implements UseCase<List<Note>, NoParams> {
  final NoteRepository noteRepository;
  GetAllNotes(this.noteRepository);

  @override
  Future<Either<Failure, List<Note>>> call(NoParams params) async {
    return await noteRepository.getAllNotes();
  }
}

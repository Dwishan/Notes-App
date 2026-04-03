import 'package:isar/isar.dart';
import 'package:minimal_notes_app/core/error/exceptions.dart';
import 'package:minimal_notes_app/features/note/data/models/note_model.dart';
import 'package:minimal_notes_app/features/note/data/models/isar_note.dart';

abstract interface class NoteLocalDataSource {
  Future<NoteModel> addNote({required String text});
  Future<List<NoteModel>> getAllNotes();
  Future<NoteModel> updateNote({required int id, required String newText});
  Future<NoteModel> deleteNote({required int id});
}

class NoteLocalDataSourceImpl implements NoteLocalDataSource {
  final Isar isar;
  NoteLocalDataSourceImpl(this.isar);

  @override
  Future<NoteModel> addNote({required String text}) async {
    try {
      final newNote = IsarNote()..text = text;
      await isar.writeTxn(() => isar.isarNotes.put(newNote));
      return NoteModel(
        id: newNote.id,
        text: newNote.text,
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<NoteModel>> getAllNotes() async {
    try {
      final notes = await isar.isarNotes.where().findAll();
      return notes
          .map(
            (note) => NoteModel(
              id: note.id,
              text: note.text,
            ),
          )
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<NoteModel> updateNote({
    required int id,
    required String newText,
  }) async {
    try {
      final existingNote = await isar.isarNotes.get(id);
      if (existingNote == null) {
        throw ServerException('Note not found');
      }
      existingNote.text = newText;
      await isar.writeTxn(() => isar.isarNotes.put(existingNote));
      return NoteModel(
        id: existingNote.id,
        text: existingNote.text,
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<NoteModel> deleteNote({required int id}) async {
    try {
      final existingNote = await isar.isarNotes.get(id);
      if (existingNote == null) {
        throw ServerException('Note not found');
      }
      await isar.writeTxn(() => isar.isarNotes.delete(id));
      return NoteModel(
        id: existingNote.id,
        text: existingNote.text,
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}

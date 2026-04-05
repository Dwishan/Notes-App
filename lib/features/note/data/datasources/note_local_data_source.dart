import 'package:isar/isar.dart';
import 'package:minimal_notes_app/core/error/exceptions.dart';
import 'package:minimal_notes_app/features/note/data/models/note_model.dart';
import 'package:minimal_notes_app/features/note/data/models/isar_note.dart';

abstract interface class NoteLocalDataSource {
  Future<NoteModel> addNote({required String title, String? description});
  Future<List<NoteModel>> getAllNotes();
  Future<NoteModel> updateNote({
    required int id,
    required String newTitle,
    String? newDescription,
  });
  Future<NoteModel> deleteNote({required int id});
}

class NoteLocalDataSourceImpl implements NoteLocalDataSource {
  final Isar isar;
  NoteLocalDataSourceImpl(this.isar);

  @override
  Future<NoteModel> addNote({required String title, String? description}) async {
    try {
      final newNote = IsarNote()
        ..title = title
        ..description = description;
      await isar.writeTxn(() => isar.isarNotes.put(newNote));
      return NoteModel(
        id: newNote.id,
        title: newNote.title,
        description: newNote.description,
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
              title: note.title,
              description: note.description,
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
    required String newTitle,
    String? newDescription,
  }) async {
    try {
      final existingNote = await isar.isarNotes.get(id);
      if (existingNote == null) {
        throw ServerException('Note not found');
      }
      existingNote.title = newTitle;
      existingNote.description = newDescription;
      await isar.writeTxn(() => isar.isarNotes.put(existingNote));
      return NoteModel(
        id: existingNote.id,
        title: existingNote.title,
        description: existingNote.description,
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
        title: existingNote.title,
        description: existingNote.description,
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}


import 'package:minimal_notes_app/core/usecase/usecase.dart';
import 'package:minimal_notes_app/features/note/domain/entities/note.dart';
import 'package:minimal_notes_app/features/note/domain/usecases/add_note.dart';
import 'package:minimal_notes_app/features/note/domain/usecases/delete_note.dart';
import 'package:minimal_notes_app/features/note/domain/usecases/get_all_notes.dart';
import 'package:minimal_notes_app/features/note/domain/usecases/update_note.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'note_event.dart';
part 'note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final AddNote _addNote;
  final GetAllNotes _getAllNotes;
  final UpdateNote _updateNote;
  final DeleteNote _deleteNote;

  NoteBloc({
    required AddNote addNote,
    required GetAllNotes getAllNotes,
    required UpdateNote updateNote,
    required DeleteNote deleteNote,
  })  : _addNote = addNote,
        _getAllNotes = getAllNotes,
        _updateNote = updateNote,
        _deleteNote = deleteNote,
        super(NoteInitial()) {
    on<NoteEvent>((event, emit) => emit(NoteLoading()));
    on<NoteFetchAll>(_onFetchAllNotes);
    on<NoteAdd>(_onAddNote);
    on<NoteUpdate>(_onUpdateNote);
    on<NoteDelete>(_onDeleteNote);
  }

  void _onFetchAllNotes(
    NoteFetchAll event,
    Emitter<NoteState> emit,
  ) async {
    final res = await _getAllNotes(NoParams());

    res.fold(
      (l) => emit(NoteFailure(l.message)),
      (r) => emit(NotesDisplaySuccess(r)),
    );
  }

  void _onAddNote(
    NoteAdd event,
    Emitter<NoteState> emit,
  ) async {
    final res = await _addNote(
      AddNoteParams(
        title: event.title,
        description: event.description,
      ),
    );

    res.fold(
      (l) => emit(NoteFailure(l.message)),
      (r) => emit(NoteActionSuccess()),
    );
  }

  void _onUpdateNote(
    NoteUpdate event,
    Emitter<NoteState> emit,
  ) async {
    final res = await _updateNote(
      UpdateNoteParams(
        id: event.id,
        newTitle: event.newTitle,
        newDescription: event.newDescription,
      ),
    );

    res.fold(
      (l) => emit(NoteFailure(l.message)),
      (r) => emit(NoteActionSuccess()),
    );
  }

  void _onDeleteNote(
    NoteDelete event,
    Emitter<NoteState> emit,
  ) async {
    final res = await _deleteNote(
      DeleteNoteParams(id: event.id),
    );

    res.fold(
      (l) => emit(NoteFailure(l.message)),
      (r) => emit(NoteActionSuccess()),
    );
  }
}

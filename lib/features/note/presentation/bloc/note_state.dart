part of 'note_bloc.dart';

@immutable
sealed class NoteState {}

final class NoteInitial extends NoteState {}

final class NoteLoading extends NoteState {}

final class NoteFailure extends NoteState {
  final String error;
  NoteFailure(this.error);
}

final class NoteActionSuccess extends NoteState {}

final class NotesDisplaySuccess extends NoteState {
  final List<Note> notes;
  NotesDisplaySuccess(this.notes);
}

part of 'note_bloc.dart';

@immutable
sealed class NoteEvent {}

final class NoteFetchAll extends NoteEvent {}

final class NoteAdd extends NoteEvent {
  final String text;

  NoteAdd({
    required this.text,
  });
}

final class NoteUpdate extends NoteEvent {
  final int id;
  final String newText;

  NoteUpdate({
    required this.id,
    required this.newText,
  });
}

final class NoteDelete extends NoteEvent {
  final int id;

  NoteDelete({
    required this.id,
  });
}

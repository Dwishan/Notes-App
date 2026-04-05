part of 'note_bloc.dart';

@immutable
sealed class NoteEvent {}

final class NoteFetchAll extends NoteEvent {}

final class NoteAdd extends NoteEvent {
  final String title;
  final String? description;

  NoteAdd({
    required this.title,
    this.description,
  });
}

final class NoteUpdate extends NoteEvent {
  final int id;
  final String newTitle;
  final String? newDescription;

  NoteUpdate({
    required this.id,
    required this.newTitle,
    this.newDescription,
  });
}


final class NoteDelete extends NoteEvent {
  final int id;

  NoteDelete({
    required this.id,
  });
}

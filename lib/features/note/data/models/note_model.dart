import 'package:minimal_notes_app/features/note/domain/entities/note.dart';

class NoteModel extends Note {
  NoteModel({
    required super.id,
    required super.title,
    super.description,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
    };
  }

  factory NoteModel.fromJson(Map<String, dynamic> map) {
    return NoteModel(
      id: map['id'] as int,
      title: map['title'] as String,
      description: map['description'] as String?,
    );
  }

  NoteModel copyWith({
    int? id,
    String? title,
    String? description,
  }) {
    return NoteModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }
}


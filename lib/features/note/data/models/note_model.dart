import 'package:minimal_notes_app/features/note/domain/entities/note.dart';

class NoteModel extends Note {
  NoteModel({
    required super.id,
    required super.text,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'text': text,
    };
  }

  factory NoteModel.fromJson(Map<String, dynamic> map) {
    return NoteModel(
      id: map['id'] as int,
      text: map['text'] as String,
    );
  }

  NoteModel copyWith({
    int? id,
    String? text,
  }) {
    return NoteModel(
      id: id ?? this.id,
      text: text ?? this.text,
    );
  }
}

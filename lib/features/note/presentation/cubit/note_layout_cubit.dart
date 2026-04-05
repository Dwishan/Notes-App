import 'package:flutter_bloc/flutter_bloc.dart';

enum NoteLayout { list, grid }

class NoteLayoutCubit extends Cubit<NoteLayout> {
  NoteLayoutCubit() : super(NoteLayout.list);

  void toggleLayout() {
    if (state == NoteLayout.list) {
      emit(NoteLayout.grid);
    } else {
      emit(NoteLayout.list);
    }
  }
}

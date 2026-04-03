import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minimal_notes_app/core/common/widgets/loader.dart';
import 'package:minimal_notes_app/core/utils/show_snackbar.dart';
import 'package:minimal_notes_app/features/note/domain/entities/note.dart';
import 'package:minimal_notes_app/features/note/presentation/bloc/note_bloc.dart';
import 'package:minimal_notes_app/features/note/presentation/widgets/my_drawer.dart';
import 'package:minimal_notes_app/features/note/presentation/widgets/note_tile.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<NoteBloc>().add(NoteFetchAll());
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  void createNote() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        content: TextField(
          controller: textController,
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              context.read<NoteBloc>().add(
                    NoteAdd(text: textController.text),
                  );
              textController.clear();
              Navigator.pop(context);
            },
            child: const Text('Create'),
          )
        ],
      ),
    );
  }

  void updateNote(Note note) {
    textController.text = note.text;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text('Update Note'),
        content: TextField(controller: textController),
        actions: [
          MaterialButton(
            onPressed: () {
              context.read<NoteBloc>().add(
                    NoteUpdate(id: note.id, newText: textController.text),
                  );
              textController.clear();
              Navigator.pop(context);
            },
            child: const Text('Update'),
          )
        ],
      ),
    );
  }

  void deleteNote(int id) {
    context.read<NoteBloc>().add(NoteDelete(id: id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      floatingActionButton: FloatingActionButton(
        onPressed: createNote,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
      drawer: const MyDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: Text(
              'Notes',
              style: GoogleFonts.dmSerifText(
                  fontSize: 48,
                  color: Theme.of(context).colorScheme.inversePrimary),
            ),
          ),
          Expanded(
            child: BlocConsumer<NoteBloc, NoteState>(
              listener: (context, state) {
                if (state is NoteFailure) {
                  showSnackBar(context, state.error);
                }
                if (state is NoteActionSuccess) {
                  // Re-fetch notes after any action (add/update/delete)
                  context.read<NoteBloc>().add(NoteFetchAll());
                }
              },
              builder: (context, state) {
                if (state is NoteLoading) {
                  return const Loader();
                }
                if (state is NotesDisplaySuccess) {
                  final currentNotes = state.notes;
                  if (currentNotes.isEmpty) {
                    return Center(
                      child: Text(
                        'No notes yet...',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: currentNotes.length,
                    itemBuilder: (context, index) {
                      final note = currentNotes[index];
                      return NoteTile(
                        text: note.text,
                        onEditPressed: () => updateNote(note),
                        onDeletePressed: () => deleteNote(note.id),
                      );
                    },
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}

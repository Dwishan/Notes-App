import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:minimal_notes_app/features/note/domain/entities/note.dart';
import 'package:minimal_notes_app/features/note/presentation/bloc/note_bloc.dart';
import 'package:minimal_notes_app/features/note/presentation/pages/note_edit_page.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:minimal_notes_app/features/note/presentation/widgets/delete_confirmation_dialog.dart';

class NoteTile extends StatelessWidget {
  final Note note;
  final bool isGrid;
  const NoteTile({
    super.key,
    required this.note,
    this.isGrid = false,
  });

  void _onDelete(BuildContext context) {
    showShadDialog(
      context: context,
      builder: (context) => DeleteConfirmationDialog(
        title: const Text('Delete Note'),
        description: const Text('Are you sure you want to delete this note?'),
        onConfirm: () {
          context.read<NoteBloc>().add(NoteDelete(id: note.id));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    Widget cardChild = GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NoteEditPage(note: note),
          ),
        );
      },
      onLongPress: isGrid ? () => _onDelete(context) : null,
      child: ShadCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        backgroundColor: theme.colorScheme.secondary,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              note.title,
              style: TextStyle(
                color: theme.colorScheme.foreground,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              maxLines: isGrid ? 2 : 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (note.description != null && note.description!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Expanded(
                flex: isGrid ? 1 : 0,
                child: Text(
                  note.description!,
                  style: TextStyle(
                    color: theme.colorScheme.foreground.withValues(alpha: 0.7),
                    fontSize: 14,
                  ),
                  maxLines: isGrid ? 4 : 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ],
        ),
      ),
    );

    if (isGrid) {
      return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: cardChild,
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 25, right: 25),
      child: Slidable(
        key: ValueKey(note.id),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: _onDelete,
              backgroundColor: theme.colorScheme.destructive,
              foregroundColor: theme.colorScheme.destructiveForeground,
              icon: Icons.delete_outline_rounded,
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
          ],
        ),
        child: cardChild,
      ),
    );
  }
}

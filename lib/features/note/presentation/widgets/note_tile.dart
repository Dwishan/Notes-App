import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:minimal_notes_app/core/utils/note_utils.dart';
import 'package:minimal_notes_app/features/note/domain/entities/note.dart';
import 'package:minimal_notes_app/features/note/presentation/bloc/note_bloc.dart';
import 'package:minimal_notes_app/features/note/presentation/pages/note_edit_page.dart';
import 'package:minimal_notes_app/core/common/widgets/delete_confirmation_dialog.dart';
import 'package:minimal_notes_app/core/constants/app_strings.dart';

class NoteTile extends StatelessWidget {
  final Note note;
  final bool isGrid;
  final bool isCompact;

  const NoteTile({
    super.key,
    required this.note,
    this.isGrid = false,
    this.isCompact = false,
  });

  void _onDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => DeleteConfirmationDialog(
        title: AppStrings.deleteNoteTitle,
        description: AppStrings.deleteNoteDescription,
        onConfirm: () {
          context.read<NoteBloc>().add(NoteDelete(id: note.id));
        },
      ),
    );
  }

  String _formattedDescription(String desc) {
    final plainText = getPlainTextFromDelta(desc);
    if (plainText.contains('- [ ]') || plainText.contains('- [x]') || plainText.contains('[ ]') || plainText.contains('[x]')) {
      return plainText
          .replaceAll('- [ ]', '☐')
          .replaceAll('- [x]', '☑')
          .replaceAll('[ ]', '☐')
          .replaceAll('[x]', '☑');
    }
    return plainText;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(isCompact ? 12 : 16),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.black.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.black.withValues(alpha: 0.06),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              note.title,
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
              maxLines: isGrid ? 2 : 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (note.description != null && note.description!.isNotEmpty) ...[
              SizedBox(height: isCompact ? 4 : 8),
              Expanded(
                flex: isGrid ? 1 : 0,
                child: Text(
                  _formattedDescription(note.description!),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
                    height: 1.4,
                  ),
                  maxLines: isGrid
                      ? (isCompact ? 2 : 4)
                      : (isCompact ? 1 : 2),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ],
        ),
      ),
    );

    if (isGrid) {
      return cardChild;
    }

    return Padding(
      padding: EdgeInsets.only(bottom: isCompact ? 8 : 12),
      child: Slidable(
        key: ValueKey(note.id),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: _onDelete,
              backgroundColor: theme.colorScheme.error,
              foregroundColor: theme.colorScheme.onError,
              icon: LucideIcons.trash_2,
              borderRadius: const BorderRadius.all(Radius.circular(16)),
            ),
          ],
        ),
        child: cardChild,
      ),
    );
  }
}

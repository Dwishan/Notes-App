import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:minimal_notes_app/core/constants/app_strings.dart';

class NoteCharacterCount extends StatelessWidget {
  final quill.QuillController controller;

  const NoteCharacterCount({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final count = controller.document.toPlainText().trim().length;
        return Text(
          '$count ${AppStrings.characters}',
          textAlign: TextAlign.end,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.35),
          ),
        );
      },
    );
  }
}

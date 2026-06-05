import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:minimal_notes_app/core/constants/app_strings.dart';

class NoteHeaderDropdown extends StatelessWidget {
  final quill.QuillController controller;

  const NoteHeaderDropdown({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PopupMenuButton<String>(
      tooltip: AppStrings.formattingStyles,
      onSelected: (style) {
        if (style == 'h1') {
          controller.formatSelection(quill.Attribute.h1);
        } else if (style == 'h2') {
          controller.formatSelection(quill.Attribute.h2);
        } else if (style == 'body') {
          controller.formatSelection(quill.Attribute.clone(quill.Attribute.header, null));
        }
      },
      offset: const Offset(0, -140),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: theme.colorScheme.outline.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      color: theme.colorScheme.surface,
      elevation: 3,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.15),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppStrings.style,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              LucideIcons.chevron_down,
              size: 14,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ],
        ),
      ),
      itemBuilder: (context) => [
        PopupMenuItem<String>(
          value: 'h1',
          child: Text(
            AppStrings.header1,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
        PopupMenuItem<String>(
          value: 'h2',
          child: Text(
            AppStrings.header2,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
        PopupMenuItem<String>(
          value: 'body',
          child: Text(
            AppStrings.bodyRegular,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}

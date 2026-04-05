import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final Widget title;
  final Widget description;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final String actionLabel;

  const DeleteConfirmationDialog({
    super.key,
    required this.title,
    required this.description,
    required this.onConfirm,
    this.onCancel,
    this.actionLabel = 'Delete',
  });

  @override
  Widget build(BuildContext context) {
    return ShadDialog.alert(
      radius: const BorderRadius.all(Radius.circular(50)),
      constraints: const BoxConstraints(maxWidth: 370),
      // Slight top padding to avoid content cutting into the large radius
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      title: title,
      description: description,
      actions: [
        Row(
          spacing: 12,
          children: [
            Expanded(
              child: ShadButton.outline(
                child: const Text('Cancel'),
                onPressed: () {
                  if (onCancel != null) onCancel!();
                  Navigator.of(context).pop(false);
                },
              ),
            ),
            Expanded(
              child: ShadButton.destructive(
                child: Text(actionLabel),
                onPressed: () {
                  onConfirm();
                  Navigator.of(context).pop(true);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

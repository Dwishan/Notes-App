import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

class AddNoteFAB extends StatelessWidget {
  final VoidCallback onPressed;

  const AddNoteFAB({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FloatingActionButton(
      backgroundColor: theme.colorScheme.primary,
      foregroundColor: theme.colorScheme.onPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      onPressed: onPressed,
      child: const Icon(LucideIcons.plus),
    );
  }
}

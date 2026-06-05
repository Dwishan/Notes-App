import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:minimal_notes_app/core/common/widgets/layout_toggle_button.dart';

class LayoutToggle extends StatelessWidget {
  final bool isGrid;
  final ValueChanged<bool> onChanged;

  const LayoutToggle({
    super.key,
    required this.isGrid,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          LayoutToggleButton(
            icon: LucideIcons.list,
            isSelected: !isGrid,
            onTap: () => onChanged(false),
            isLeft: true,
          ),
          LayoutToggleButton(
            icon: LucideIcons.layout_grid,
            isSelected: isGrid,
            onTap: () => onChanged(true),
            isLeft: false,
          ),
        ],
      ),
    );
  }
}

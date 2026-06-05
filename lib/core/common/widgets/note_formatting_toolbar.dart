import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:minimal_notes_app/core/common/widgets/note_header_dropdown.dart';
import 'package:minimal_notes_app/core/common/widgets/note_toolbar_button.dart';
import 'package:minimal_notes_app/core/constants/app_strings.dart';

class NoteFormattingToolbar extends StatefulWidget {
  final quill.QuillController controller;

  const NoteFormattingToolbar({
    super.key,
    required this.controller,
  });

  @override
  State<NoteFormattingToolbar> createState() => _NoteFormattingToolbarState();
}

class _NoteFormattingToolbarState extends State<NoteFormattingToolbar> {
  bool _isToolbarExpanded = false;

  bool get _isBoldActive => widget.controller.getSelectionStyle().attributes.containsKey(quill.Attribute.bold.key);
  bool get _isItalicActive => widget.controller.getSelectionStyle().attributes.containsKey(quill.Attribute.italic.key);
  bool get _isUnderlineActive => widget.controller.getSelectionStyle().attributes.containsKey(quill.Attribute.underline.key);

  bool get _isChecklistActive {
    final attrs = widget.controller.getSelectionStyle().attributes;
    if (attrs.containsKey(quill.Attribute.list.key)) {
      final val = attrs[quill.Attribute.list.key]?.value;
      return val == 'checked' || val == 'unchecked';
    }
    return false;
  }

  bool get _isOrderedListActive {
    final attrs = widget.controller.getSelectionStyle().attributes;
    if (attrs.containsKey(quill.Attribute.list.key)) {
      final val = attrs[quill.Attribute.list.key]?.value;
      return val == 'ordered';
    }
    return false;
  }

  bool get _isBulletListActive {
    final attrs = widget.controller.getSelectionStyle().attributes;
    if (attrs.containsKey(quill.Attribute.list.key)) {
      final val = attrs[quill.Attribute.list.key]?.value;
      return val == 'bullet';
    }
    return false;
  }

  bool _isAlignmentActive(quill.Attribute alignment) {
    final attrs = widget.controller.getSelectionStyle().attributes;
    if (attrs.containsKey(quill.Attribute.align.key)) {
      return attrs[quill.Attribute.align.key] == alignment;
    }
    return alignment == quill.Attribute.leftAlignment;
  }

  void _toggleChecklist() {
    final attrs = widget.controller.getSelectionStyle().attributes;
    final hasList = attrs.containsKey(quill.Attribute.list.key);
    final listVal = attrs[quill.Attribute.list.key]?.value;
    final isChecklist = hasList && (listVal == 'checked' || listVal == 'unchecked');
    widget.controller.formatSelection(isChecklist ? quill.Attribute.clone(quill.Attribute.list, null) : quill.Attribute.unchecked);
  }

  void _toggleBold() {
    final attrs = widget.controller.getSelectionStyle().attributes;
    final isBold = attrs.containsKey(quill.Attribute.bold.key);
    widget.controller.formatSelection(isBold ? quill.Attribute.clone(quill.Attribute.bold, null) : quill.Attribute.bold);
  }

  void _toggleItalic() {
    final attrs = widget.controller.getSelectionStyle().attributes;
    final isItalic = attrs.containsKey(quill.Attribute.italic.key);
    widget.controller.formatSelection(isItalic ? quill.Attribute.clone(quill.Attribute.italic, null) : quill.Attribute.italic);
  }

  void _toggleUnderline() {
    final attrs = widget.controller.getSelectionStyle().attributes;
    final isUnderline = attrs.containsKey(quill.Attribute.underline.key);
    widget.controller.formatSelection(isUnderline ? quill.Attribute.clone(quill.Attribute.underline, null) : quill.Attribute.underline);
  }

  void _toggleOrderedList() {
    final attrs = widget.controller.getSelectionStyle().attributes;
    final hasList = attrs.containsKey(quill.Attribute.list.key);
    final listVal = attrs[quill.Attribute.list.key]?.value;
    final isOrdered = hasList && listVal == 'ordered';
    widget.controller.formatSelection(isOrdered ? quill.Attribute.clone(quill.Attribute.list, null) : quill.Attribute.ol);
  }

  void _toggleBulletList() {
    final attrs = widget.controller.getSelectionStyle().attributes;
    final hasList = attrs.containsKey(quill.Attribute.list.key);
    final listVal = attrs[quill.Attribute.list.key]?.value;
    final isBullet = hasList && listVal == 'bullet';
    widget.controller.formatSelection(isBullet ? quill.Attribute.clone(quill.Attribute.list, null) : quill.Attribute.ul);
  }

  void _alignText(quill.Attribute? alignAttribute) {
    if (alignAttribute == null) {
      widget.controller.formatSelection(quill.Attribute.clone(quill.Attribute.align, null));
    } else {
      widget.controller.formatSelection(alignAttribute);
    }
  }

  void _changeIndent(bool increase) {
    final indentAttr = widget.controller.getSelectionStyle().attributes[quill.Attribute.indent.key];
    int currentVal = 0;
    if (indentAttr != null && indentAttr.value is int) {
      currentVal = indentAttr.value as int;
    }
    final newVal = increase ? currentVal + 1 : currentVal - 1;
    if (newVal <= 0) {
      widget.controller.formatSelection(quill.Attribute.clone(quill.Attribute.indent, null));
    } else {
      widget.controller.formatSelection(quill.Attribute.getIndentLevel(newVal));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        return Card(
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: theme.colorScheme.outline.withValues(alpha: 0.15),
              width: 1,
            ),
          ),
          color: theme.colorScheme.surfaceContainerLow,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_isToolbarExpanded) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    alignment: WrapAlignment.spaceEvenly,
                    children: [
                      NoteToolbarButton(
                        icon: LucideIcons.list_ordered,
                        isActive: _isOrderedListActive,
                        onPressed: _toggleOrderedList,
                        tooltip: AppStrings.numbering,
                      ),
                      NoteToolbarButton(
                        icon: LucideIcons.list,
                        isActive: _isBulletListActive,
                        onPressed: _toggleBulletList,
                        tooltip: AppStrings.bulleting,
                      ),
                      NoteToolbarButton(
                        icon: LucideIcons.text_align_start,
                        isActive: _isAlignmentActive(quill.Attribute.leftAlignment),
                        onPressed: () => _alignText(quill.Attribute.leftAlignment),
                        tooltip: AppStrings.alignLeft,
                      ),
                      NoteToolbarButton(
                        icon: LucideIcons.text_align_center,
                        isActive: _isAlignmentActive(quill.Attribute.centerAlignment),
                        onPressed: () => _alignText(quill.Attribute.centerAlignment),
                        tooltip: AppStrings.alignCenter,
                      ),
                      NoteToolbarButton(
                        icon: LucideIcons.text_align_end,
                        isActive: _isAlignmentActive(quill.Attribute.rightAlignment),
                        onPressed: () => _alignText(quill.Attribute.rightAlignment),
                        tooltip: AppStrings.alignRight,
                      ),
                      NoteToolbarButton(
                        icon: LucideIcons.list_indent_increase,
                        onPressed: () => _changeIndent(true),
                        tooltip: AppStrings.increaseIndent,
                      ),
                      NoteToolbarButton(
                        icon: LucideIcons.list_indent_decrease,
                        onPressed: () => _changeIndent(false),
                        tooltip: AppStrings.decreaseIndent,
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: theme.colorScheme.outline.withValues(alpha: 0.1),
                  height: 1,
                ),
              ],
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      NoteToolbarButton(
                        icon: _isChecklistActive ? LucideIcons.square_check : LucideIcons.square,
                        isActive: _isChecklistActive,
                        onPressed: _toggleChecklist,
                        tooltip: AppStrings.checklistMode,
                      ),
                      const SizedBox(width: 8),
                      NoteHeaderDropdown(controller: widget.controller),
                      const SizedBox(width: 8),
                      NoteToolbarButton(
                        icon: LucideIcons.undo_2,
                        onPressed: widget.controller.hasUndo ? () => widget.controller.undo() : null,
                        tooltip: AppStrings.undo,
                      ),
                      const SizedBox(width: 4),
                      NoteToolbarButton(
                        icon: LucideIcons.redo_2,
                        onPressed: widget.controller.hasRedo ? () => widget.controller.redo() : null,
                        tooltip: AppStrings.redo,
                      ),
                      const SizedBox(width: 16),
                      NoteToolbarButton(
                        icon: LucideIcons.bold,
                        isActive: _isBoldActive,
                        onPressed: _toggleBold,
                        tooltip: AppStrings.bold,
                      ),
                      const SizedBox(width: 4),
                      NoteToolbarButton(
                        icon: LucideIcons.italic,
                        isActive: _isItalicActive,
                        onPressed: _toggleItalic,
                        tooltip: AppStrings.italic,
                      ),
                      const SizedBox(width: 4),
                      NoteToolbarButton(
                        icon: LucideIcons.underline,
                        isActive: _isUnderlineActive,
                        onPressed: _toggleUnderline,
                        tooltip: AppStrings.underline,
                      ),
                      const SizedBox(width: 8),
                      NoteToolbarButton(
                        icon: LucideIcons.ellipsis,
                        isActive: _isToolbarExpanded,
                        onPressed: () {
                          setState(() {
                            _isToolbarExpanded = !_isToolbarExpanded;
                          });
                        },
                        tooltip: AppStrings.moreOptions,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

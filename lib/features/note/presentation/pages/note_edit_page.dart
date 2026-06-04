import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:forui/forui.dart';
import 'package:minimal_notes_app/features/note/domain/entities/note.dart';
import 'package:minimal_notes_app/features/note/presentation/bloc/note_bloc.dart';

class NoteEditPage extends StatefulWidget {
  final Note note;
  const NoteEditPage({super.key, required this.note});

  @override
  State<NoteEditPage> createState() => _NoteEditPageState();
}

class _NoteEditPageState extends State<NoteEditPage> {
  late final TextEditingController _titleController;
  late final TextEditingController _descController;

  bool _isChecklist = false;
  final List<TextEditingController> _controllers = [];
  final List<bool> _checkboxStates = [];
  final List<FocusNode> _focusNodes = [];
  late final FocusNode _titleFocus;
  late final FocusNode _descFocus;
  TextEditingController? _activeController;

  bool _isToolbarExpanded = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note.title);
    _descController = TextEditingController(text: widget.note.description ?? '');
    _titleFocus = FocusNode();
    _descFocus = FocusNode();

    _titleFocus.addListener(() {
      if (_titleFocus.hasFocus) {
        _activeController = _titleController;
      }
    });

    _descFocus.addListener(() {
      if (_descFocus.hasFocus) {
        _activeController = _descController;
      }
    });

    // Parse description to see if it is a checklist
    final desc = widget.note.description ?? '';
    if (desc.contains('- [ ]') || desc.contains('- [x]') || desc.startsWith('[ ]') || desc.startsWith('[x]')) {
      _isChecklist = true;
      final lines = desc.split('\n');
      for (final line in lines) {
        if (line.trim().isEmpty) continue;
        bool isDone = false;
        String text = line;
        if (line.startsWith('- [x]')) {
          isDone = true;
          text = line.substring(5).trim();
        } else if (line.startsWith('- [ ]')) {
          isDone = false;
          text = line.substring(5).trim();
        } else if (line.startsWith('[x]')) {
          isDone = true;
          text = line.substring(3).trim();
        } else if (line.startsWith('[ ]')) {
          isDone = false;
          text = line.substring(3).trim();
        } else {
          isDone = false;
          text = line.trim();
        }
        final controller = TextEditingController(text: text);
        controller.addListener(_onChecklistControllerChanged);
        _controllers.add(controller);
        _checkboxStates.add(isDone);

        final focusNode = FocusNode();
        focusNode.addListener(() {
          if (focusNode.hasFocus) {
            _activeController = controller;
          }
        });
        _focusNodes.add(focusNode);
      }
    }
  }

  void _onChecklistControllerChanged() {
    setState(() {});
  }

  void _initializeChecklistFromText() {
    for (final controller in _controllers) {
      controller.removeListener(_onChecklistControllerChanged);
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    _controllers.clear();
    _checkboxStates.clear();
    _focusNodes.clear();

    final text = _descController.text;
    if (text.trim().isEmpty) {
      _addTask();
    } else {
      final lines = text.split('\n');
      for (final line in lines) {
        if (line.trim().isEmpty) continue;
        bool isDone = false;
        String content = line;

        if (line.startsWith('- [x]')) {
          isDone = true;
          content = line.substring(5).trim();
        } else if (line.startsWith('- [ ]')) {
          isDone = false;
          content = line.substring(5).trim();
        } else if (line.startsWith('[x]')) {
          isDone = true;
          content = line.substring(3).trim();
        } else if (line.startsWith('[ ]')) {
          isDone = false;
          content = line.substring(3).trim();
        } else {
          isDone = false;
          content = line.trim();
        }

        final controller = TextEditingController(text: content);
        controller.addListener(_onChecklistControllerChanged);
        _controllers.add(controller);
        _checkboxStates.add(isDone);

        final focusNode = FocusNode();
        focusNode.addListener(() {
          if (focusNode.hasFocus) {
            _activeController = controller;
          }
        });
        _focusNodes.add(focusNode);
      }
    }
  }

  void _convertChecklistToText() {
    final lines = <String>[];
    for (int i = 0; i < _controllers.length; i++) {
      final t = _controllers[i].text.trim();
      if (t.isNotEmpty) {
        lines.add('- [${_checkboxStates[i] ? 'x' : ' '}] $t');
      }
    }
    _descController.text = lines.join('\n');
  }

  void _addTask() {
    setState(() {
      final controller = TextEditingController();
      controller.addListener(_onChecklistControllerChanged);
      _controllers.add(controller);
      _checkboxStates.add(false);

      final focusNode = FocusNode();
      focusNode.addListener(() {
        if (focusNode.hasFocus) {
          _activeController = controller;
        }
      });
      _focusNodes.add(focusNode);
    });
  }

  void _removeTask(int index) {
    setState(() {
      _controllers[index].removeListener(_onChecklistControllerChanged);
      _controllers[index].dispose();
      _controllers.removeAt(index);
      _checkboxStates.removeAt(index);

      _focusNodes[index].dispose();
      _focusNodes.removeAt(index);
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _titleFocus.dispose();
    _descFocus.dispose();
    for (final controller in _controllers) {
      controller.removeListener(_onChecklistControllerChanged);
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  String _buildDescription() {
    if (_isChecklist) {
      final lines = <String>[];
      for (int i = 0; i < _controllers.length; i++) {
        final text = _controllers[i].text.trim();
        if (text.isNotEmpty) {
          lines.add('- [${_checkboxStates[i] ? 'x' : ' '}] $text');
        }
      }
      return lines.join('\n');
    } else {
      return _descController.text;
    }
  }

  void _onSave() async {
    if (_titleController.text.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    final description = _buildDescription();
    context.read<NoteBloc>().add(
          NoteUpdate(
            id: widget.note.id,
            newTitle: _titleController.text,
            newDescription: description,
          ),
        );
    Navigator.pop(context);
  }

  int _getCharacterCount() {
    if (_isChecklist) {
      return _controllers.fold(0, (sum, controller) => sum + controller.text.length);
    } else {
      return _descController.text.length;
    }
  }

  void _applyFormatting(String prefix, [String suffix = '']) {
    final controller = _activeController ?? _descController;
    final text = controller.text;
    final selection = controller.selection;

    if (!selection.isValid) {
      final newText = text + prefix + suffix;
      controller.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length - suffix.length),
      );
      return;
    }

    final start = selection.start;
    final end = selection.end;
    final selectedText = text.substring(start, end);
    final newText = text.replaceRange(start, end, '$prefix$selectedText$suffix');

    controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection(
        baseOffset: start + prefix.length,
        extentOffset: start + prefix.length + selectedText.length,
      ),
    );
  }

  void _applyLinePrefix(String prefix) {
    final controller = _activeController ?? _descController;
    final text = controller.text;
    final selection = controller.selection;

    if (!selection.isValid) {
      controller.text = prefix + text;
      return;
    }

    final start = selection.start;
    int lineStart = start;
    while (lineStart > 0 && text[lineStart - 1] != '\n') {
      lineStart--;
    }

    final newText = text.replaceRange(lineStart, lineStart, prefix);
    controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: selection.start + prefix.length),
    );
  }

  void _removeHeaderPrefix() {
    final controller = _activeController ?? _descController;
    final text = controller.text;
    final selection = controller.selection;

    if (!selection.isValid) return;

    final start = selection.start;
    int lineStart = start;
    while (lineStart > 0 && text[lineStart - 1] != '\n') {
      lineStart--;
    }

    String line = text.substring(lineStart);
    int lineEnd = line.indexOf('\n');
    if (lineEnd != -1) {
      line = line.substring(0, lineEnd);
    }

    String newLine = line;
    if (line.startsWith('# ')) {
      newLine = line.substring(2);
    } else if (line.startsWith('## ')) {
      newLine = line.substring(3);
    }

    final newText = text.replaceRange(lineStart, lineStart + line.length, newLine);
    controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: lineStart + newLine.length),
    );
  }

  void _decreaseIndent() {
    final controller = _activeController ?? _descController;
    final text = controller.text;
    final selection = controller.selection;

    if (!selection.isValid) return;

    final start = selection.start;
    int lineStart = start;
    while (lineStart > 0 && text[lineStart - 1] != '\n') {
      lineStart--;
    }

    String line = text.substring(lineStart);
    int lineEnd = line.indexOf('\n');
    if (lineEnd != -1) {
      line = line.substring(0, lineEnd);
    }

    String newLine = line;
    if (line.startsWith('  ')) {
      newLine = line.substring(2);
    } else if (line.startsWith('\t')) {
      newLine = line.substring(1);
    }

    final newText = text.replaceRange(lineStart, lineStart + line.length, newLine);
    controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: lineStart + newLine.length),
    );
  }

  Widget _buildToolbarButton({
    required IconData icon,
    required VoidCallback? onPressed,
    Color? iconColor,
    String? tooltip,
  }) {
    final theme = Theme.of(context);
    return Tooltip(
      message: tooltip ?? '',
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 20,
            color: iconColor ?? theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderDropdown(BuildContext context) {
    final theme = Theme.of(context);
    return PopupMenuButton<String>(
      tooltip: 'Formatting Styles',
      onSelected: (style) {
        if (style == 'h1') {
          _applyLinePrefix('# ');
        } else if (style == 'h2') {
          _applyLinePrefix('## ');
        } else if (style == 'body1') {
          _removeHeaderPrefix();
        } else if (style == 'body2') {
          _applyFormatting('<small>', '</small>');
        }
      },
      offset: const Offset(0, -185),
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
              'Style',
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
            'Header 1',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
        PopupMenuItem<String>(
          value: 'h2',
          child: Text(
            'Header 2',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
        PopupMenuItem<String>(
          value: 'body1',
          child: Text(
            'Body 1 (Regular)',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
        PopupMenuItem<String>(
          value: 'body2',
          child: Text(
            'Body 2 (Small)',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: theme.scaffoldBackgroundColor,
      child: FScaffold(
        childPad: false,
        header: FHeader.nested(
          title: const Text('Edit Note'),
          prefixes: [
            FHeaderAction(
              icon: Icon(
                LucideIcons.chevron_left,
                color: theme.colorScheme.onSurface,
                size: 22,
              ),
              onPress: _isLoading ? null : () => Navigator.pop(context),
            ),
          ],
          suffixes: [
            FButton(
              onPress: _isLoading || _titleController.text.trim().isEmpty ? null : _onSave,
              variant: FButtonVariant.primary,
              size: FButtonSizeVariant.sm,
              child: _isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Save'),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Title Field
                TextField(
                  controller: _titleController,
                  focusNode: _titleFocus,
                  enabled: !_isLoading,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Title',
                    hintStyle: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.25),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                  ),
                  textCapitalization: TextCapitalization.sentences,
                  onChanged: (_) {
                    setState(() {}); // To enable/disable save button based on title
                  },
                ),
                const SizedBox(height: 12),

                // Content Area
                Expanded(
                  child: _isChecklist
                      ? ListView.builder(
                          itemCount: _controllers.length + 1,
                          itemBuilder: (context, index) {
                            if (index == _controllers.length) {
                              return GestureDetector(
                                onTap: _isLoading ? null : _addTask,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 4.0),
                                  child: Row(
                                    children: [
                                      Icon(
                                        LucideIcons.plus,
                                        color: theme.colorScheme.primary.withValues(alpha: _isLoading ? 0.5 : 1.0),
                                        size: 20,
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        'Add item',
                                        style: theme.textTheme.bodyLarge?.copyWith(
                                          color: theme.colorScheme.primary.withValues(alpha: _isLoading ? 0.5 : 1.0),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }

                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                children: [
                                  FCheckbox(
                                    value: _checkboxStates[index],
                                    enabled: !_isLoading,
                                    onChange: (val) {
                                      setState(() {
                                        _checkboxStates[index] = val;
                                      });
                                    },
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: TextField(
                                      controller: _controllers[index],
                                      focusNode: _focusNodes[index],
                                      enabled: !_isLoading,
                                      style: theme.textTheme.bodyLarge?.copyWith(
                                        color: theme.colorScheme.onSurface,
                                        decoration: _checkboxStates[index]
                                            ? TextDecoration.lineThrough
                                            : null,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: 'Task ${index + 1}',
                                        hintStyle: theme.textTheme.bodyLarge?.copyWith(
                                          color: theme.colorScheme.onSurface.withValues(alpha: 0.25),
                                        ),
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.zero,
                                      ),
                                      textCapitalization: TextCapitalization.sentences,
                                    ),
                                  ),
                                  if (!_isLoading)
                                    IconButton(
                                      icon: Icon(
                                        LucideIcons.x,
                                        color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                                        size: 20,
                                      ),
                                      onPressed: () => _removeTask(index),
                                    ),
                                ],
                              ),
                            );
                          },
                        )
                      : TextField(
                          controller: _descController,
                          focusNode: _descFocus,
                          enabled: !_isLoading,
                          maxLines: null,
                          minLines: null,
                          expands: true,
                          textAlignVertical: TextAlignVertical.top,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurface,
                            height: 1.6,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Start writing...',
                            hintStyle: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.25),
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                          ),
                          textCapitalization: TextCapitalization.sentences,
                          onChanged: (_) {
                            setState(() {}); // To update character count
                          },
                        ),
                ),
                const SizedBox(height: 8),

                // Formatting Toolbar Card
                Card(
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
                              _buildToolbarButton(
                                icon: LucideIcons.list_ordered,
                                onPressed: () => _applyLinePrefix('1. '),
                                tooltip: 'Numbering',
                              ),
                              _buildToolbarButton(
                                icon: LucideIcons.list,
                                onPressed: () => _applyLinePrefix('- '),
                                tooltip: 'Bulleting',
                              ),
                              _buildToolbarButton(
                                icon: LucideIcons.text_align_start,
                                onPressed: () => _applyFormatting('<p align="left">', '</p>'),
                                tooltip: 'Align Left',
                              ),
                              _buildToolbarButton(
                                icon: LucideIcons.text_align_center,
                                onPressed: () => _applyFormatting('<p align="center">', '</p>'),
                                tooltip: 'Align Center',
                              ),
                              _buildToolbarButton(
                                icon: LucideIcons.text_align_end,
                                onPressed: () => _applyFormatting('<p align="right">', '</p>'),
                                tooltip: 'Align Right',
                              ),
                              _buildToolbarButton(
                                icon: LucideIcons.list_indent_increase,
                                onPressed: () => _applyLinePrefix('  '),
                                tooltip: 'Increase Indent',
                              ),
                              _buildToolbarButton(
                                icon: LucideIcons.list_indent_decrease,
                                onPressed: () => _decreaseIndent(),
                                tooltip: 'Decrease Indent',
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          color: theme.colorScheme.outline.withValues(alpha: 0.1),
                          height: 1,
                        ),
                      ],
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: Row(
                          children: [
                            _buildToolbarButton(
                              icon: _isChecklist ? LucideIcons.square_check : LucideIcons.square,
                              iconColor: _isChecklist ? theme.colorScheme.primary : null,
                              onPressed: () {
                                setState(() {
                                  final val = !_isChecklist;
                                  if (val) {
                                    _initializeChecklistFromText();
                                  } else {
                                    _convertChecklistToText();
                                  }
                                  _isChecklist = val;
                                });
                              },
                              tooltip: 'Checklist Mode',
                            ),
                            const SizedBox(width: 8),
                            _buildHeaderDropdown(context),
                            const Spacer(),
                            _buildToolbarButton(
                              icon: LucideIcons.bold,
                              onPressed: () => _applyFormatting('**', '**'),
                              tooltip: 'Bold',
                            ),
                            const SizedBox(width: 4),
                            _buildToolbarButton(
                              icon: LucideIcons.italic,
                              onPressed: () => _applyFormatting('*', '*'),
                              tooltip: 'Italic',
                            ),
                            const SizedBox(width: 4),
                            _buildToolbarButton(
                              icon: LucideIcons.underline,
                              onPressed: () => _applyFormatting('<u>', '</u>'),
                              tooltip: 'Underline',
                            ),
                            const SizedBox(width: 8),
                            _buildToolbarButton(
                              icon: LucideIcons.ellipsis,
                              iconColor: _isToolbarExpanded ? theme.colorScheme.primary : null,
                              onPressed: () {
                                setState(() {
                                  _isToolbarExpanded = !_isToolbarExpanded;
                                });
                              },
                              tooltip: 'More options',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // Character count
                Text(
                  '${_getCharacterCount()} characters',
                  textAlign: TextAlign.end,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.35),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:forui/forui.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:minimal_notes_app/features/note/presentation/bloc/note_bloc.dart';
import 'package:minimal_notes_app/core/constants/app_strings.dart';
import 'package:minimal_notes_app/core/common/widgets/note_formatting_toolbar.dart';
import 'package:minimal_notes_app/core/common/widgets/note_character_count.dart';

class NoteAddPage extends StatefulWidget {
  const NoteAddPage({super.key});

  @override
  State<NoteAddPage> createState() => _NoteAddPageState();
}

class _NoteAddPageState extends State<NoteAddPage> {
  late final TextEditingController _titleController;
  late final quill.QuillController _quillController;
  late final FocusNode _titleFocus;
  late final FocusNode _quillFocusNode;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _quillController = quill.QuillController.basic();
    _titleFocus = FocusNode();
    _quillFocusNode = FocusNode();

    _titleController.addListener(_onTitleChanged);
  }

  void _onTitleChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _titleController.removeListener(_onTitleChanged);
    _titleController.dispose();
    _quillController.dispose();
    _titleFocus.dispose();
    _quillFocusNode.dispose();
    super.dispose();
  }

  void _onSave() async {
    if (_titleController.text.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    final description = jsonEncode(_quillController.document.toDelta().toJson());
    context.read<NoteBloc>().add(
          NoteAdd(
            title: _titleController.text,
            description: description,
          ),
        );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final bodyStyle = theme.textTheme.bodyLarge;
    final primaryColor = theme.colorScheme.onSurface;

    final defaultStyles = quill.DefaultStyles(
      paragraph: quill.DefaultTextBlockStyle(
        bodyStyle!.copyWith(
          color: primaryColor,
          height: 1.6,
        ),
        const quill.HorizontalSpacing(0, 0),
        const quill.VerticalSpacing(4, 4),
        const quill.VerticalSpacing(0, 0),
        null,
      ),
      h1: quill.DefaultTextBlockStyle(
        theme.textTheme.headlineLarge!.copyWith(
          color: primaryColor,
          fontWeight: FontWeight.bold,
        ),
        const quill.HorizontalSpacing(0, 0),
        const quill.VerticalSpacing(12, 6),
        const quill.VerticalSpacing(0, 0),
        null,
      ),
      h2: quill.DefaultTextBlockStyle(
        theme.textTheme.headlineMedium!.copyWith(
          color: primaryColor,
          fontWeight: FontWeight.bold,
        ),
        const quill.HorizontalSpacing(0, 0),
        const quill.VerticalSpacing(10, 4),
        const quill.VerticalSpacing(0, 0),
        null,
      ),
      h3: quill.DefaultTextBlockStyle(
        theme.textTheme.headlineSmall!.copyWith(
          color: primaryColor,
          fontWeight: FontWeight.bold,
        ),
        const quill.HorizontalSpacing(0, 0),
        const quill.VerticalSpacing(8, 4),
        const quill.VerticalSpacing(0, 0),
        null,
      ),
    );

    return Material(
      color: theme.scaffoldBackgroundColor,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        extendBodyBehindAppBar: false,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: FHeader.nested(
                  title: const Text(AppStrings.newNote),
                  prefixes: [
                    FHeaderAction(
                      icon: Icon(
                        LucideIcons.chevron_left,
                        color: theme.colorScheme.onSurface,
                        size: theme.textTheme.titleLarge?.fontSize ?? 22,
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
                          : const Text(AppStrings.save),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        controller: _titleController,
                        focusNode: _titleFocus,
                        autofocus: true,
                        enabled: !_isLoading,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                        decoration: InputDecoration(
                          hintText: AppStrings.titlePlaceholder,
                          hintStyle: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.25),
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                        ),
                        textCapitalization: TextCapitalization.sentences,
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: quill.QuillEditor.basic(
                          controller: _quillController,
                          focusNode: _quillFocusNode,
                          config: quill.QuillEditorConfig(
                            placeholder: AppStrings.startWriting,
                            autoFocus: false,
                            scrollable: true,
                            expands: true,
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                            customStyles: defaultStyles,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      NoteFormattingToolbar(controller: _quillController),
                      const SizedBox(height: 8),
                      NoteCharacterCount(controller: _quillController),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

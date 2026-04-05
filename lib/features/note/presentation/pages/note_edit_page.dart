import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minimal_notes_app/core/common/cubits/theme/theme_cubit.dart';
import 'package:minimal_notes_app/features/note/domain/entities/note.dart';
import 'package:minimal_notes_app/features/note/presentation/bloc/note_bloc.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class NoteEditPage extends StatefulWidget {
  final Note note;
  const NoteEditPage({super.key, required this.note});

  @override
  State<NoteEditPage> createState() => _NoteEditPageState();
}

class _NoteEditPageState extends State<NoteEditPage> {
  late final TextEditingController _titleController;
  late final TextEditingController _descController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note.title);
    _descController = TextEditingController(text: widget.note.description ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _onSave() {
    context.read<NoteBloc>().add(
          NoteUpdate(
            id: widget.note.id,
            newTitle: _titleController.text,
            newDescription: _descController.text,
          ),
        );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final isDark = state is ThemeLoaded ? state.isDarkMode : false;

        return Scaffold(
          backgroundColor: theme.colorScheme.background,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            systemOverlayStyle:
                isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
            leadingWidth: 64,
            leading: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: ShadButton.ghost(
                width: 40,
                height: 40,
                padding: EdgeInsets.zero,
                onPressed: () => Navigator.pop(context),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: theme.colorScheme.foreground,
                  size: 20,
                ),
              ),
            ),
            actions: [
              ShadButton.ghost(
                width: 40,
                height: 40,
                padding: EdgeInsets.zero,
                onPressed: _onSave,
                child: Icon(
                  Icons.check_rounded,
                  color: theme.colorScheme.foreground,
                  size: 24,
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(25, 0, 25, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Title Field
                  ShadInput(
                    controller: _titleController,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    style: GoogleFonts.dmSerifText(
                      fontSize: 32,
                      color: theme.colorScheme.foreground,
                    ),
                    decoration: const ShadDecoration(
                      border: ShadBorder.none,
                    ),
                    placeholder: Text(
                      'Title',
                      style: GoogleFonts.dmSerifText(
                        fontSize: 32,
                        color: theme.colorScheme.foreground.withValues(alpha: 0.3),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Description Field
                  Expanded(
                    child: ShadInput(
                      controller: _descController,
                      maxLines: null,
                      minLines: null,
                      expands: true,
                      padding: const EdgeInsets.all(12),
                      style: GoogleFonts.dmSerifText(
                        fontSize: 20,
                        color: theme.colorScheme.foreground,
                        height: 1.5,
                      ),
                      decoration: const ShadDecoration(
                        border: ShadBorder.none,
                      ),
                      placeholder: Text(
                        'Note description...',
                        style: GoogleFonts.dmSerifText(
                          fontSize: 20,
                          color: theme.colorScheme.foreground.withValues(alpha: 0.3),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Metadata footer
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ValueListenableBuilder(
                        valueListenable: _descController,
                        builder: (context, value, child) {
                          return Text(
                            '${_descController.text.length} characters',
                            style: TextStyle(
                              color: theme.colorScheme.foreground
                                  .withValues(alpha: 0.5),
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}


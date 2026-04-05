import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minimal_notes_app/core/common/widgets/loader.dart';
import 'package:minimal_notes_app/core/utils/show_snackbar.dart';
import 'package:minimal_notes_app/core/common/cubits/theme/theme_cubit.dart';
import 'package:minimal_notes_app/features/note/presentation/bloc/note_bloc.dart';
import 'package:minimal_notes_app/features/note/presentation/cubit/note_layout_cubit.dart';
import 'package:minimal_notes_app/features/note/presentation/pages/note_add_page.dart';
import 'package:minimal_notes_app/features/note/presentation/widgets/note_tile.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  @override
  void initState() {
    super.initState();
    context.read<NoteBloc>().add(NoteFetchAll());
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        final isDark = themeState is ThemeLoaded ? themeState.isDarkMode : false;

        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            scrolledUnderElevation: 0,
            shadowColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            foregroundColor: theme.colorScheme.foreground,
            systemOverlayStyle:
                isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
            title: Text(
              'Notes',
              style: GoogleFonts.dmSerifText(
                fontSize: 32,
                color: theme.colorScheme.foreground,
              ),
            ),
            actions: [
              // Layout Toggle
              BlocBuilder<NoteLayoutCubit, NoteLayout>(
                builder: (context, layout) {
                  return ShadButton.ghost(
                    width: 40,
                    height: 40,
                    padding: EdgeInsets.zero,
                    onPressed: () =>
                        context.read<NoteLayoutCubit>().toggleLayout(),
                    child: Icon(
                      layout == NoteLayout.list
                          ? LucideIcons.layoutGrid
                          : LucideIcons.list,
                      size: 20,
                      color: theme.colorScheme.foreground,
                    ),
                  );
                },
              ),
              const SizedBox(width: 8),
              // Theme Toggle Icons/Switch
              Row(
                children: [
                  Icon(
                    isDark ? LucideIcons.moon : LucideIcons.sun,
                    size: 20,
                    color: theme.colorScheme.foreground.withValues(alpha: 0.7),
                  ),
                  const SizedBox(width: 8),
                  ShadSwitch(
                    value: isDark,
                    onChanged: (value) {
                      context.read<ThemeCubit>().toggleTheme();
                    },
                  ),
                ],
              ),
              const SizedBox(width: 16),
            ],
          ),
          backgroundColor: theme.colorScheme.background,
          floatingActionButton: ShadButton.ghost(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NoteAddPage(),
                ),
              );
            },
            decoration: ShadDecoration(
              border: ShadBorder.all(
                color: theme.colorScheme.border,
                width: 1,
              ),
              color: theme.colorScheme.secondary,
              shape: BoxShape.circle,
            ),
            height: 56,
            width: 56,
            child: Icon(
              Icons.add,
              color: theme.colorScheme.foreground,
            ),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Expanded(
                child: BlocConsumer<NoteBloc, NoteState>(
                  listener: (context, state) {
                    if (state is NoteFailure) {
                      showSnackBar(context, state.error);
                    }
                    if (state is NoteActionSuccess) {
                      context.read<NoteBloc>().add(NoteFetchAll());
                    }
                  },
                  builder: (context, state) {
                    if (state is NoteLoading) {
                      return const Loader();
                    }
                    if (state is NotesDisplaySuccess) {
                      final currentNotes = state.notes;
                      if (currentNotes.isEmpty) {
                        return Center(
                          child: Text(
                            'No notes yet...',
                            style: TextStyle(
                              color: theme.colorScheme.foreground,
                            ),
                          ),
                        );
                      }
                      return BlocBuilder<NoteLayoutCubit, NoteLayout>(
                        builder: (context, layout) {
                          if (layout == NoteLayout.grid) {
                            return GridView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 0,
                                childAspectRatio: 1.0,
                              ),
                              itemCount: currentNotes.length,
                              itemBuilder: (context, index) {
                                final note = currentNotes[index];
                                return NoteTile(
                                  note: note,
                                  isGrid: true,
                                );
                              },
                            );
                          }
                          return ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 0),
                            itemCount: currentNotes.length,
                            itemBuilder: (context, index) {
                              final note = currentNotes[index];
                              return NoteTile(
                                note: note,
                                isGrid: false,
                              );
                            },
                          );
                        },
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

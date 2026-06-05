import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:minimal_notes_app/core/common/cubits/settings/settings_cubit.dart';
import 'package:minimal_notes_app/core/common/widgets/loader.dart';
import 'package:minimal_notes_app/core/utils/show_snackbar.dart';
import 'package:minimal_notes_app/features/note/presentation/bloc/note_bloc.dart';
import 'package:minimal_notes_app/features/note/presentation/pages/note_add_page.dart';
import 'package:minimal_notes_app/features/note/presentation/widgets/note_tile.dart';
import 'package:minimal_notes_app/features/note/presentation/widgets/add_note_fab.dart';
import 'package:minimal_notes_app/features/settings/presentation/pages/settings_page.dart';
import 'package:minimal_notes_app/core/constants/app_strings.dart';

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
    final theme = Theme.of(context);

    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, settings) {
        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          extendBodyBehindAppBar: false,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FHeader(
                  title: Text(
                    AppStrings.appName,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  suffixes: [
                    FHeaderAction(
                      icon: const Icon(LucideIcons.settings, size: 20),
                      onPress: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SettingsPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 4),
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                               Icon(
                                LucideIcons.file_plus,
                                size: 64,
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.15),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                AppStrings.noNotesYet,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                AppStrings.createFirstNoteHint,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      // Sort notes
                      final sortedNotes = List.of(currentNotes);
                      switch (settings.sortOrder) {
                        case NoteSortOrder.newestFirst:
                          sortedNotes.sort((a, b) => b.id.compareTo(a.id));
                          break;
                        case NoteSortOrder.oldestFirst:
                          sortedNotes.sort((a, b) => a.id.compareTo(b.id));
                          break;
                        case NoteSortOrder.alphabetical:
                          sortedNotes.sort((a, b) =>
                              a.title.toLowerCase().compareTo(b.title.toLowerCase()));
                          break;
                      }

                      if (settings.noteLayout == NoteLayout.grid) {
                        return GridView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: settings.compactCards ? 1.3 : 1.0,
                          ),
                          itemCount: sortedNotes.length,
                          itemBuilder: (context, index) {
                            return NoteTile(
                              note: sortedNotes[index],
                              isGrid: true,
                              isCompact: settings.compactCards,
                            );
                          },
                        );
                      }
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        itemCount: sortedNotes.length,
                        itemBuilder: (context, index) {
                          return NoteTile(
                            note: sortedNotes[index],
                            isGrid: false,
                            isCompact: settings.compactCards,
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
          ),
          floatingActionButton: AddNoteFAB(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NoteAddPage(),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

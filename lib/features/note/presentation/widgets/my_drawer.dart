import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minimal_notes_app/core/common/cubits/theme/theme_cubit.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    
    return Drawer(
      backgroundColor: theme.colorScheme.background,
      child: Column(
        children: [
          DrawerHeader(
            child: Icon(
              Icons.note_rounded,
              size: 55,
              color: theme.colorScheme.foreground,
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: ShadCard(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              backgroundColor: theme.colorScheme.secondary,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Theme",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.foreground,
                    ),
                  ),
                  BlocBuilder<ThemeCubit, ThemeState>(
                    builder: (context, state) {
                      final isDark =
                          state is ThemeLoaded ? state.isDarkMode : false;
                      return ShadSwitch(
                        value: isDark,
                        onChanged: (value) {
                          context.read<ThemeCubit>().toggleTheme();
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


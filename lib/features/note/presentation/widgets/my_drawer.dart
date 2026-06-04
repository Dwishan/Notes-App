import 'package:flutter/material.dart';
import 'package:minimal_notes_app/features/settings/presentation/pages/settings_page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Drawer(
      backgroundColor: theme.scaffoldBackgroundColor,
      child: Column(
        children: [
          DrawerHeader(
            child: Icon(
              Icons.sticky_note_2_rounded,
              size: 55,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 10),
          ListTile(
            leading: Icon(
              Icons.settings_outlined,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            title: Text(
              'Settings',
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
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
    );
  }
}

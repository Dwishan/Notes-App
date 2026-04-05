import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: ShadTheme.of(context).colorScheme.foreground,
        strokeWidth: 2,
      ),
    );
  }
}



import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

void showSnackBar(BuildContext context, String content) {
  ShadToaster.of(context).show(
    ShadToast(
      description: Text(content),
    ),
  );
}


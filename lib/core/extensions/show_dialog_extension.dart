import 'package:asset_tracker/core/constants/strings/locale/tr_strings.dart';
import 'package:asset_tracker/core/extensions/build_context_extension.dart';
import 'package:flutter/material.dart';

extension ShowDialogExtension on BuildContext {
  void showDialogFonk(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(TrStrings.showDialogTitleText),
          content: Text(message),
          backgroundColor: context.colorScheme.secondary,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(TrStrings.showDialogButtonText),
            ),
          ],
        );
      },
    );
  }
}

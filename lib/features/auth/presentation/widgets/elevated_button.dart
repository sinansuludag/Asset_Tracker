import 'package:asset_tracker/core/constants/media_query_sizes/media_query_size.dart';
import 'package:asset_tracker/core/extensions/build_context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

ElevatedButton customElevatedButton(
    {required BuildContext context,
    required WidgetRef ref,
    required String butonText,
    required VoidCallback onPressed}) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      elevation: 5,
      backgroundColor: context.colorScheme.primary,
      foregroundColor: context.colorScheme.onPrimary,
      minimumSize:
          Size(double.infinity, MediaQuerySize(context).percent6Height),
      shape: const StadiumBorder(),
    ),
    child: Text(butonText),
  );
}

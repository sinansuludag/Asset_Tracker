import 'package:asset_tracker/core/extensions/build_context_extension.dart';
import 'package:flutter/material.dart';

Widget signInAndUpRow(
    BuildContext context, String text, String name, String route) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        text,
        style: context.textTheme.bodyMedium
            ?.copyWith(color: context.colorScheme.onSurface),
      ),
      InkWell(
        onTap: () {
          Navigator.pushNamed(context, route);
        },
        child: Text(
          name,
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colorScheme.error,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ],
  );
}

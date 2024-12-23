import 'package:asset_tracker/core/extensions/build_context_extension.dart';
import 'package:flutter/material.dart';

Text textTitle(BuildContext context, {required String title}) {
  return Text(
    title,
    style: context.textTheme.headlineLarge?.copyWith(
      color: context.colorScheme.primary,
    ),
  );
}

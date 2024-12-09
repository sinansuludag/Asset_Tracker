import 'package:flutter/material.dart';

class AppStyles {
  static const EdgeInsets defaultPadding = EdgeInsets.all(16.0);
  static const EdgeInsets lowPadding = EdgeInsets.all(8.0);
  static const EdgeInsets normalPadding = EdgeInsets.all(24.0);
  static const EdgeInsets highPadding = EdgeInsets.all(48.0);
  static const BorderRadius defaultBorderRadius =
      BorderRadius.all(Radius.circular(16.0));
  static const BorderRadius lowBorderRadius =
      BorderRadius.all(Radius.circular(8.0));
  static const BorderRadius normalBorderRadius =
      BorderRadius.all(Radius.circular(24.0));
  static const BorderRadius highBorderRadius =
      BorderRadius.all(Radius.circular(48.0));
  static const BoxShadow defaultShadow = BoxShadow(
    color: Colors.black26,
    offset: Offset(0, 4),
    blurRadius: 8,
  );
}

import 'package:flutter/material.dart';

class AppBorderRadius {
  AppBorderRadius._();

  ///Size->16
  static const BorderRadius defaultBorderRadius =
      BorderRadius.all(Radius.circular(16.0));

  ///Size->8
  static const BorderRadius lowBorderRadius =
      BorderRadius.all(Radius.circular(8.0));

  ///Size->24
  static const BorderRadius normalBorderRadius =
      BorderRadius.all(Radius.circular(24.0));

  ///Size->24
  static const BorderRadius onlyTopNormalBorderRadius = BorderRadius.vertical(
    top: Radius.circular(24.0),
  );

  ///Size->48
  static const BorderRadius highBorderRadius =
      BorderRadius.all(Radius.circular(48.0));
}

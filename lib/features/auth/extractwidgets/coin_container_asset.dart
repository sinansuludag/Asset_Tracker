import 'package:asset_tracker/core/constants/border_radius/border_radius.dart';
import 'package:flutter/material.dart';

Widget coinContainerAsset(ColorScheme colorScheme, double height) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: AppBorderRadius.highBorderRadius,
      color: colorScheme.onSurface,
    ),
    height: height * 0.18,
    child: Image.asset(
      'assets/png/coin.png',
    ),
  );
}

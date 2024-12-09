import 'package:asset_tracker/core/theme/app_styles.dart';
import 'package:flutter/material.dart';

Widget coinContainerAsset(ColorScheme colorScheme, double height) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: AppStyles.highBorderRadius,
      color: colorScheme.onSurface,
    ),
    height: height * 0.18,
    child: Image.asset(
      'assets/png/coin.png',
    ),
  );
}

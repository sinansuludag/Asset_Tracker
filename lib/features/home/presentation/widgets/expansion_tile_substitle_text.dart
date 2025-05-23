import 'package:asset_tracker/core/constants/sizes/font_sizes.dart';
import 'package:asset_tracker/core/extensions/build_context_extension.dart';
import 'package:asset_tracker/features/home/data/models/currency_data_model.dart';
import 'package:flutter/material.dart';

Widget expansionTileSubtitleText(
    CurrencyData currencyData,
    double currencyPrice,
    IconData icon,
    Color color,
    String text,
    BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        text,
        style: context.textTheme.bodyLarge?.copyWith(
          color: context.colorScheme.primary,
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(currencyPrice.toStringAsFixed(2)),
          Icon(Icons.currency_lira,
              color: context.colorScheme.onSecondary,
              size: FontSizes.bodyLargeFontSize),
          Icon(icon, color: color, size: FontSizes.bodyLargeFontSize),
        ],
      ),
    ],
  );
}

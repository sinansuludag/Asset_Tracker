import 'package:asset_tracker/core/constants/paddings/paddings.dart';
import 'package:asset_tracker/core/extensions/build_context_extension.dart';
import 'package:asset_tracker/features/home/data/models/currency_data_model.dart';
import 'package:flutter/material.dart';

Padding expansionTileChildrenItems(CurrencyData currencyData, String text,
    double currencyPrice, BuildContext context) {
  return Padding(
    padding: AppPaddings.verticalAndHorizontal_8_16,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          '$text:',
          style: context.textTheme.bodyMedium,
        ),
        Row(
          children: [
            Text(
              currencyPrice.toStringAsFixed(2),
              style: context.textTheme.bodyMedium,
            ),
            Icon(
              Icons.currency_lira,
              color: context.colorScheme.onSecondary,
              size: 16,
            ),
          ],
        ),
      ],
    ),
  );
}

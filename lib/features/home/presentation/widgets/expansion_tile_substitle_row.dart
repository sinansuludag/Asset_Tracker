import 'package:asset_tracker/core/constants/strings/locale/tr_strings.dart';
import 'package:asset_tracker/features/home/data/models/currency_data_model.dart';
import 'package:asset_tracker/features/home/presentation/widgets/expansion_tile_substitle_text.dart';
import 'package:flutter/material.dart';

Row expansionTileSubtitleRow(
    CurrencyData currencyData,
    IconData alisIcon,
    Color alisColor,
    IconData satisIcon,
    Color satisColor,
    BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      expansionTileSubtitleText(currencyData, currencyData.buying ?? 0,
          alisIcon, alisColor, TrStrings.buying, context),
      expansionTileSubtitleText(currencyData, currencyData.selling ?? 0,
          satisIcon, satisColor, TrStrings.selling, context),
    ],
  );
}

import 'package:asset_tracker/core/constants/border_radius/border_radius.dart';
import 'package:asset_tracker/core/constants/paddings/paddings.dart';
import 'package:asset_tracker/core/extensions/build_context_extension.dart';
import 'package:asset_tracker/features/home/data/models/currency_data_model.dart';
import 'package:asset_tracker/features/home/presentation/widgets/expansion_tile_widget.dart';
import 'package:flutter/material.dart';

Card currencyCardWidget(
    BuildContext context,
    CurrencyData currencyData,
    String currencyName,
    String? currencyCode,
    IconData alisIcon,
    Color alisColor,
    IconData satisIcon,
    Color satisColor) {
  return Card(
    shadowColor: context.colorScheme.onSurface.withAlpha(10),
    color: context.colorScheme.onSurface.withAlpha(30),
    margin: AppPaddings.verticalAndHorizontal_4_8,
    child: ClipRRect(
      borderRadius: AppBorderRadius.lowBorderRadius,
      child: expansionTileWidget(context, currencyData, currencyName,
          currencyCode, alisIcon, alisColor, satisIcon, satisColor),
    ),
  );
}

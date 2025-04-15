import 'package:asset_tracker/core/constants/paddings/paddings.dart';
import 'package:asset_tracker/core/constants/strings/locale/tr_strings.dart';
import 'package:asset_tracker/core/extensions/build_context_extension.dart';
import 'package:asset_tracker/features/home/data/models/currency_data_model.dart';
import 'package:asset_tracker/features/home/presentation/widgets/expansion_tile_children_items.dart';
import 'package:asset_tracker/features/home/presentation/widgets/expansion_tile_leading_circle_avatar.dart';
import 'package:asset_tracker/features/home/presentation/widgets/expansion_tile_substitle_row.dart';
import 'package:asset_tracker/features/home/presentation/widgets/expansion_tile_title_text.dart';
import 'package:flutter/material.dart';

ExpansionTile expansionTileWidget(
    BuildContext context,
    CurrencyData currencyData,
    String currencyName,
    String? currencyCode,
    IconData alisIcon,
    Color alisColor,
    IconData satisIcon,
    Color satisColor) {
  return ExpansionTile(
    shape: Border.all(
      color: context.colorScheme.primary,
      width: 0,
    ),
    leading: expansionTileLeadingCircleAvatar(currencyName),
    title: expansionTileTitleText(currencyCode, context),
    subtitle: expansionTileSubtitleRow(
        currencyData, alisIcon, alisColor, satisIcon, satisColor, context),
    children: [
      Column(
        children: [
          expansionTileChildrenItems(
              currencyData, TrStrings.lowest, currencyData.low ?? 0, context),
          expansionTileChildrenItems(
              currencyData, TrStrings.highest, currencyData.high ?? 0, context),
          expansionTileChildrenItems(
              currencyData, TrStrings.close, currencyData.close ?? 0, context),
          lastUpdateTimeRowWidget(context, currencyData),
        ],
      )
    ],
  );
}

Padding lastUpdateTimeRowWidget(
    BuildContext context, CurrencyData currencyData) {
  final date = currencyData.date;
  final dateTimeParts = date?.split(' ');

  final formattedDateTime = (dateTimeParts != null && dateTimeParts.length >= 2)
      ? '${dateTimeParts[0]} ${dateTimeParts[1]}'
      : '---';

  return Padding(
    padding: AppPaddings.verticalAndHorizontal_8_16,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Son güncellenme zamanı:',
          style: context.textTheme.bodyMedium,
        ),
        Text(
          formattedDateTime,
          style: context.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: context.colorScheme.primary,
          ),
        ),
      ],
    ),
  );
}

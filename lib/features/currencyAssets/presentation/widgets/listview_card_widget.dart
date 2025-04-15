import 'package:asset_tracker/core/constants/border_radius/border_radius.dart';
import 'package:asset_tracker/core/constants/media_query_sizes/media_query_size.dart';
import 'package:asset_tracker/core/constants/paddings/paddings.dart';
import 'package:asset_tracker/core/extensions/build_context_extension.dart';
import 'package:asset_tracker/features/currencyAssets/domain/entities/currency_asset_entity.dart';
import 'package:asset_tracker/features/currencyAssets/presentation/widgets/delete_icon_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Padding listviewCardWidget(BuildContext context, CurrencyAssetEntity asset,
    double currentValue, double diff, double diffRate, WidgetRef ref) {
  return Padding(
    padding: AppPaddings.verticalAndHorizontal_8_16,
    child: Card(
      shape: const RoundedRectangleBorder(
        borderRadius: AppBorderRadius.defaultBorderRadius,
      ),
      shadowColor: context.colorScheme.onSurface.withAlpha(10),
      color: context.colorScheme.onSurface.withAlpha(30),
      child: Padding(
        padding: AppPaddings.allDefaultPadding,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(asset.assetType,
                      style: context.textTheme.bodyLarge
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  SizedBox(height: MediaQuerySize(context).percent1Height),
                  Text(
                    "Alış: ₺${asset.buyingPrice.toStringAsFixed(2)}  -  Miktar: ${asset.quantity}",
                    style: context.textTheme.bodyMedium,
                  ),
                  Text(
                    "Anlık Değer: ₺${(currentValue / asset.quantity).toStringAsFixed(2)}",
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: diff >= 0 ? Colors.green : Colors.red,
                    ),
                  ),
                  Text(
                    "Kar/Zarar: ₺${diff.toStringAsFixed(2)} (%${diffRate.toStringAsFixed(2)})",
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: diff >= 0 ? Colors.green : Colors.red,
                    ),
                  )
                ],
              ),
            ),
            deleteIconButonWidget(context, asset, ref),
          ],
        ),
      ),
    ),
  );
}

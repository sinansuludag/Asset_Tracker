import 'package:asset_tracker/core/constants/colors/app_colors.dart';
import 'package:asset_tracker/core/extensions/build_context_extension.dart';
import 'package:asset_tracker/features/home/data/models/curreny_response_model.dart';
import 'package:asset_tracker/features/home/presentation/widgets/currency_card_widget.dart';
import 'package:flutter/material.dart';

ListView currencyListviewBuilderWidget(
    List<CurrencyResponse> currencies, BuildContext context) {
  return ListView.builder(
    itemCount: currencies.first.currencies.length,
    itemBuilder: (context, index) {
      final currencyEntry = currencies.first.currencies.entries.toList()[index];
      final currencyName = currencyEntry.key;
      final currencyData = currencyEntry.value;

      // Determine colors and icons for price direction
      final alisColor = currencyData.buyingDir == 'up'
          ? AppColors.success
          : (currencyData.buyingDir == 'down'
              ? context.colorScheme.error
              : AppColors.black);
      final satisColor = currencyData.sellingDir == 'up'
          ? AppColors.success
          : (currencyData.sellingDir == 'down'
              ? context.colorScheme.error
              : AppColors.black);

      final alisIcon = currencyData.buyingDir == 'up'
          ? Icons.arrow_upward
          : (currencyData.buyingDir == 'down'
              ? Icons.arrow_downward
              : Icons.remove);
      final satisIcon = currencyData.sellingDir == 'up'
          ? Icons.arrow_upward
          : (currencyData.buyingDir == 'down'
              ? Icons.arrow_downward
              : Icons.remove);

      final currencyCode = currencyData.code?.trim();
      if (currencyCode == null || currencyCode.isEmpty) {
        debugPrint("Bilinmeyen Kod: ${currencyData.code}");
      }

      return currencyCardWidget(context, currencyData, currencyName,
          currencyCode, alisIcon, alisColor, satisIcon, satisColor);
    },
  );
}

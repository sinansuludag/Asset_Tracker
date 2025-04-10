import 'package:asset_tracker/core/extensions/reverse_to_currency_code_extension.dart';
import 'package:asset_tracker/features/currencyAssets/presentation/state_management/riverpod/currency_asset_notifier.dart';
import 'package:asset_tracker/features/currencyAssets/presentation/widgets/build_portfolio_card.dart';
import 'package:asset_tracker/features/currencyAssets/presentation/widgets/listview_card_widget.dart';
import 'package:asset_tracker/features/home/data/models/currency_data_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

ListView listviewBuilderWidget(
    CurrencyAssetState state,
    Map<String, CurrencyData> currencyMap,
    ScrollController scrollController,
    String? selectedAssetType,
    Map<String, double> lastKnownPrices,
    void Function(Map<String, CurrencyData>) updateLastKnownPrices,
    WidgetRef ref,
    void Function(String) onAssetSelected) {
  return ListView.builder(
    controller: scrollController,
    itemCount: state.assets.length + 1,
    itemBuilder: (context, index) {
      if (index == 0) {
        return buildPortfolioCard(
            context,
            ref,
            updateLastKnownPrices,
            lastKnownPrices,
            selectedAssetType,
            scrollController,
            onAssetSelected);
      }

      final asset = state.assets[index - 1];
      if (asset == null) return const SizedBox();

      final code = asset.assetType.getCurrencyCode();
      final currentPrice = (code != null
              ? currencyMap[code]?.buying ?? lastKnownPrices[code]
              : null) ??
          0.0;

      final totalValue = asset.buyingPrice * asset.quantity;
      final currentValue = currentPrice * asset.quantity;
      final diff = currentValue - totalValue;
      final diffRate = totalValue > 0 ? (diff / totalValue) * 100 : 0.0;

      return listviewCardWidget(
          context, asset, currentValue, diff, diffRate, ref);
    },
  );
}

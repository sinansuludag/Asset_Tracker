import 'package:asset_tracker/core/constants/paddings/paddings.dart';
import 'package:asset_tracker/core/extensions/build_context_extension.dart';
import 'package:asset_tracker/core/extensions/reverse_to_currency_code_extension.dart';
import 'package:asset_tracker/features/currencyAssets/presentation/state_management/riverpod/all_provider.dart';
import 'package:asset_tracker/features/currencyAssets/presentation/widgets/card_portfolio_info_widget.dart';
import 'package:asset_tracker/features/home/data/models/currency_data_model.dart';
import 'package:asset_tracker/features/home/presentation/state_management/provider/all_providers.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Widget buildPortfolioCard(
  BuildContext context,
  WidgetRef ref,
  void Function(Map<String, CurrencyData>) updateLastKnownPrices,
  Map<String, double> lastKnownPrices,
  String? selectedAssetType,
  ScrollController controller,
  void Function(String) onAssetSelected,
) {
  final state = ref.watch(currencyAssetProvider);
  final currencyResponses = ref.watch(currencyNotifierProvider);
  final assetColors = <String, Color>{};

  if (currencyResponses.isEmpty || state.assets.isEmpty) {
    return const SizedBox();
  }

  if (currencyResponses.isNotEmpty) {
    updateLastKnownPrices(currencyResponses.last.currencies);
  }

  final currentMap = <String, double>{};
  double totalBuy = 0.0;
  double totalCurrent = 0.0;

  for (var asset in state.assets) {
    if (asset == null) continue;

    totalBuy += asset.buyingPrice * asset.quantity;
    final code = asset.assetType.getCurrencyCode();
    if (code != null) {
      final price = currencyResponses.isNotEmpty
          ? currencyResponses.last.currencies[code]?.buying ??
              lastKnownPrices[code] ??
              0.0
          : lastKnownPrices[code] ?? 0.0;

      final value = price * asset.quantity;
      currentMap[asset.assetType] =
          (currentMap[asset.assetType] ?? 0.0) + value;
      totalCurrent += value;
    }
  }

  final profitRate =
      totalBuy > 0 ? ((totalCurrent - totalBuy) / totalBuy) * 100 : 0.0;
  final profitAmount = totalCurrent - totalBuy;

  final entriesList = currentMap.entries.toList();

  Color getColorFromString(String input) {
    final hash = input.hashCode;
    final r = (hash & 0xFF0000) >> 16;
    final g = (hash & 0x00FF00) >> 8;
    final b = (hash & 0x0000FF);
    return Color.fromARGB(255, r, g, b);
  }

  double totalPercent = 0.0;
  List<PieChartSectionData> sections = [];

  for (int i = 0; i < entriesList.length; i++) {
    final entry = entriesList[i];
    final value = entry.value;
    final assetType = entry.key;
    final color = getColorFromString(assetType);
    assetColors[assetType] = color;

    double percent;
    if (i == entriesList.length - 1) {
      percent = 100.0 - totalPercent;
    } else {
      percent = totalCurrent > 0 ? (value / totalCurrent * 100) : 0.0;
      totalPercent += percent;
    }

    sections.add(
      PieChartSectionData(
        value: value,
        title: "%${percent.toStringAsFixed(1)}",
        color: color,
        radius: selectedAssetType == assetType ? 70 : 55,
        titleStyle: context.textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: context.colorScheme.onPrimary,
        ),
      ),
    );
  }

  return Padding(
    padding: AppPaddings.allDefaultPadding,
    child: cardPortfolioInfoWidget(
      context,
      totalCurrent,
      totalBuy,
      profitAmount,
      profitRate,
      sections,
      entriesList,
      state,
      assetColors,
      onAssetSelected,
      controller,
      selectedAssetType,
    ),
  );
}

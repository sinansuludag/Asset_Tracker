import 'package:asset_tracker/core/constants/border_radius/border_radius.dart';
import 'package:asset_tracker/core/constants/media_query_sizes/media_query_size.dart';
import 'package:asset_tracker/core/constants/paddings/paddings.dart';
import 'package:asset_tracker/core/extensions/build_context_extension.dart';
import 'package:asset_tracker/features/currencyAssets/presentation/state_management/riverpod/currency_asset_notifier.dart';
import 'package:asset_tracker/features/currencyAssets/presentation/widgets/pie_chart_widget.dart';
import 'package:asset_tracker/features/currencyAssets/presentation/widgets/pie_chart_wrap_widget.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

Card cardPortfolioInfoWidget(
    BuildContext context,
    double totalCurrent,
    double totalBuy,
    double profitAmount,
    double profitRate,
    List<PieChartSectionData> sections,
    List<MapEntry<String, double>> entriesList,
    CurrencyAssetState state,
    Map<String, Color> assetColors,
    void Function(String) onAssetSelected,
    ScrollController controller,
    String? selectedAssetType) {
  return Card(
    shape: const RoundedRectangleBorder(
      borderRadius: AppBorderRadius.defaultBorderRadius,
    ),
    elevation: 6,
    color: context.colorScheme.surface,
    child: Padding(
      padding: AppPaddings.allDefaultPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Toplam Değer", style: context.textTheme.bodyMedium),
          Text("₺${totalCurrent.toStringAsFixed(2)}",
              style: context.textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold)),
          SizedBox(height: MediaQuerySize(context).percent1Height),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Alış", style: context.textTheme.bodyMedium),
                  Text("₺${totalBuy.toStringAsFixed(2)}",
                      style: context.textTheme.bodyMedium),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Kar/Zarar", style: context.textTheme.bodyMedium),
                  Text("₺${profitAmount.toStringAsFixed(2)}",
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: profitAmount >= 0 ? Colors.green : Colors.red,
                      )),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Oran", style: context.textTheme.bodyMedium),
                  Text("%${profitRate.toStringAsFixed(2)}",
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: profitRate >= 0 ? Colors.green : Colors.red,
                      )),
                ],
              ),
            ],
          ),
          SizedBox(height: MediaQuerySize(context).percent1Height),
          AspectRatio(
            aspectRatio: 1.4,
            child: pieChartWidget(sections, entriesList, state, controller,
                onAssetSelected, selectedAssetType),
          ),
          SizedBox(height: MediaQuerySize(context).percent1Height),
          pieChartWrapWidget(
              context, entriesList, assetColors, onAssetSelected),
        ],
      ),
    ),
  );
}

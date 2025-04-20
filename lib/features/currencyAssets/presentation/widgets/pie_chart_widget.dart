import 'package:asset_tracker/features/currencyAssets/presentation/state_management/riverpod/currency_asset_notifier.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

PieChart pieChartWidget(
    List<PieChartSectionData> sections,
    List<MapEntry<String, double>> entriesList,
    CurrencyAssetState state,
    ScrollController scrollController,
    void Function(String) onAssetSelected,
    String? selectedAssetType) {
  return PieChart(
    PieChartData(
      sections: sections,
      centerSpaceRadius: 40,
      sectionsSpace: 0,
      pieTouchData: PieTouchData(
        touchCallback: (event, response) {
          final touchedIndex = response?.touchedSection?.touchedSectionIndex;
          if (touchedIndex != null &&
              touchedIndex >= 0 &&
              touchedIndex < entriesList.length) {
            onAssetSelected(entriesList[touchedIndex].key);
            final targetIndex = state.assets
                .indexWhere((a) => a?.assetType == selectedAssetType);
            if (targetIndex != -1) {
              scrollController.animateTo(
                (targetIndex + 1) * 180.0,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            }
          }
        },
      ),
    ),
  );
}

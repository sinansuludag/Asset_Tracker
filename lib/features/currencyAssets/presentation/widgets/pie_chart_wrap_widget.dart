import 'package:asset_tracker/core/constants/media_query_sizes/media_query_size.dart';
import 'package:asset_tracker/core/extensions/build_context_extension.dart';
import 'package:flutter/material.dart';

Wrap pieChartWrapWidget(
    BuildContext context,
    List<MapEntry<String, double>> entriesList,
    Map<String, Color> assetColors,
    void Function(String) onAssetSelected) {
  return Wrap(
    spacing: MediaQuerySize(context).percent4Width,
    runSpacing: MediaQuerySize(context).percent1Height,
    children: entriesList.asMap().entries.map((entry) {
      final assetName = entry.value.key;
      return InkWell(
        onTap: () => onAssetSelected(assetName),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10,
              height: 10,
              margin: const EdgeInsets.only(right: 6),
              decoration: BoxDecoration(
                color: assetColors[assetName] ?? Colors.grey,
                shape: BoxShape.circle,
              ),
            ),
            Text(assetName, style: context.textTheme.bodyMedium),
          ],
        ),
      );
    }).toList(),
  );
}

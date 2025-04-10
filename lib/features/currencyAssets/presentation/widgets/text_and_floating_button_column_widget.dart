import 'package:asset_tracker/core/constants/media_query_sizes/media_query_size.dart';
import 'package:asset_tracker/features/home/presentation/widgets/show_buying_assets.dart';
import 'package:flutter/material.dart';

Center textAndFloatingButtonColumnWidget(BuildContext context) {
  return Center(
      child: Column(
    spacing: MediaQuerySize(context).percent1Height,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text("Henüz varlık eklemediniz."),
      FloatingActionButton(
        onPressed: () {
          showBuyingAssets(context);
        },
        child: const Icon(Icons.add),
      ),
    ],
  ));
}

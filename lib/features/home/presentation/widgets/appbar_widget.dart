import 'package:asset_tracker/core/constants/paddings/paddings.dart';
import 'package:asset_tracker/core/constants/strings/locale/tr_strings.dart';
import 'package:asset_tracker/core/routing/route_names.dart';
import 'package:flutter/material.dart';

AppBar appBarWidget(BuildContext context) {
  return AppBar(
    title: const Text(TrStrings.homeScreenTitle),
    scrolledUnderElevation: 0,
    centerTitle: true,
    actions: [
      Padding(
        padding: AppPaddings.horizontalSimetricLowPadding,
        child: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, RouteNames.buyingAssets);
            },
            icon: const Icon(Icons.add)),
      ),
    ],
  );
}

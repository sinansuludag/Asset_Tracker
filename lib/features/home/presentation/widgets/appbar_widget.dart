import 'package:asset_tracker/core/constants/strings/locale/tr_strings.dart';
import 'package:flutter/material.dart';

AppBar appBarWidget(String dateTime) {
  return AppBar(
    title: const Text(TrStrings.homeScreenTitle),
    scrolledUnderElevation: 0,
    centerTitle: false,
    actions: [
      Text(dateTime),
    ],
  );
}

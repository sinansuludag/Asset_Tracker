import 'package:asset_tracker/core/constants/strings/locale/tr_strings.dart';
import 'package:flutter/material.dart';

AppBar appBarWidget() {
  return AppBar(
    title: const Text(TrStrings.homeScreenTitle),
    scrolledUnderElevation: 0,
    centerTitle: true,
  );
}

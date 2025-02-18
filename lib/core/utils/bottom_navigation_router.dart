import 'package:asset_tracker/features/currencyAssets/presentation/pages/currency_asset_screen.dart';
import 'package:asset_tracker/features/home/presentation/pages/home_screen.dart';
import 'package:asset_tracker/features/profile/presentation/pages/profile_screen.dart';
import 'package:flutter/material.dart';

Widget bottomNavigationBarRouter(int currentIndex) {
  switch (currentIndex) {
    case 1:
      return CurrencyAssetScreen();
    case 2:
      return ProfileScreen();
    default:
      return HomeScreen();
  }
}

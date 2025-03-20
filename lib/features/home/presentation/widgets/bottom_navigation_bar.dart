import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:asset_tracker/core/constants/strings/locale/tr_strings.dart';
import 'package:asset_tracker/core/extensions/build_context_extension.dart';
import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabTapped;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTabTapped,
  });

  @override
  Widget build(BuildContext context) {
    return ConvexAppBar(
      backgroundColor: context.colorScheme.surface,
      color: context.colorScheme.onSurface,
      activeColor: context.colorScheme.primary,
      style: TabStyle.react,
      items: const [
        TabItem(icon: Icons.home, title: TrStrings.bottomNavigationHome),
        TabItem(
            icon: Icons.currency_exchange,
            title: TrStrings.bottomNavigationCurrency),
        TabItem(icon: Icons.search, title: TrStrings.bottomNavigationProfile),
      ],
      initialActiveIndex: currentIndex,
      onTap: onTabTapped,
    );
  }
}

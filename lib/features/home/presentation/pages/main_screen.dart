import 'package:asset_tracker/features/currencyAssets/presentation/pages/currency_asset_screen.dart';
import 'package:asset_tracker/features/home/presentation/pages/modern_home_screen.dart';
import 'package:asset_tracker/features/home/presentation/widgets/modern/modern_bottom_navigation.dart';
import 'package:asset_tracker/features/profile/presentation/pages/profile_screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const ModernHomeScreen(),
    const Placeholder(), // Markets page - implement later
    const CurrencyAssetScreen(),
    const ProfileScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: ModernBottomNavigation(
        currentIndex: _currentIndex,
        onTabTapped: _onTabTapped,
      ),
    );
  }
}

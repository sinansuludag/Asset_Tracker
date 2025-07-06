import 'package:asset_tracker/features/currencyAssets/presentation/pages/modern_portfolio_screen.dart';
import 'package:asset_tracker/features/home/presentation/pages/modern_home_screen.dart';
import 'package:asset_tracker/features/home/presentation/widgets/modern/modern_bottom_navigation.dart';
import 'package:asset_tracker/features/profile/presentation/pages/modern/modern_profile_screen.dart';
import 'package:asset_tracker/features/markets/presentation/pages/markets_screen.dart';
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
    const MarketsScreen(),
    const ModernPortfolioScreen(),
    const ModernProfileScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      // Aktif sekme indeksini güncelle
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Ana içerik alanı
      body: IndexedStack(
        // Şu anda aktif olan sekmenin indeksi
        index: _currentIndex,
        // Tüm sayfalar (gizli olanlar da hafızada kalır)
        children: _pages,
        // IndexedStack sayesinde sekme değiştirirken sayfa durumu korunur
      ),

      bottomNavigationBar: ModernBottomNavigation(
        currentIndex: _currentIndex,
        onTabTapped: _onTabTapped,
      ),
    );
  }
}

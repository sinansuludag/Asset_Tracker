import 'package:asset_tracker/core/services/current_index_provider.dart';
import 'package:asset_tracker/features/currencyAssets/presentation/pages/modern_portfolio_screen.dart';
import 'package:asset_tracker/features/home/presentation/pages/modern_home_screen.dart';
import 'package:asset_tracker/features/home/presentation/widgets/modern/modern_bottom_navigation.dart';
import 'package:asset_tracker/features/profile/presentation/pages/modern/modern_profile_screen.dart';
import 'package:asset_tracker/features/markets/presentation/pages/markets_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Provider'dan index'i oku
    final currentIndex = ref.watch(currentIndexProvider);

    // Sayfa listesi
    final List<Widget> pages = [
      const ModernHomeScreen(),
      const MarketsScreen(),
      const ModernPortfolioScreen(),
      const ModernProfileScreen(),
    ];

    // ✅ DÜZELTME 3: onTabTapped fonksiyonu - Provider kullan
    void onTabTapped(int index) {
      ref.read(currentIndexProvider.notifier).state = index;
    }

    return Scaffold(
      // Ana içerik alanı
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
      bottomNavigationBar: ModernBottomNavigation(
        currentIndex: currentIndex,
        onTabTapped: onTabTapped,
      ),
    );
  }
}

import 'package:asset_tracker/features/home/presentation/state_management/provider/all_providers.dart';
import 'package:asset_tracker/features/home/presentation/widgets/modern/header_section_widget.dart';
import 'package:asset_tracker/features/home/presentation/widgets/modern/market_overview_widget.dart';
import 'package:asset_tracker/features/home/presentation/widgets/modern/quick_actions_widget.dart';
import 'package:asset_tracker/features/home/presentation/widgets/modern/quantum_fab_widget.dart';
import 'package:asset_tracker/features/home/presentation/widgets/modern/user_assets_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Modern home screen - issue gereksinimlerini karşılayan ana sayfa
/// Sadece izinli varlıkları gösterir, real-time WebSocket verileri ile çalışır
class ModernHomeScreen extends ConsumerStatefulWidget {
  const ModernHomeScreen({super.key});

  @override
  ConsumerState<ModernHomeScreen> createState() => _ModernHomeScreenState();
}

class _ModernHomeScreenState extends ConsumerState<ModernHomeScreen> {
  @override
  Widget build(BuildContext context) {
    // WebSocket'den gelen currency verileri
    final currencies = ref.watch(currencyNotifierProvider);
    // Kullanıcının portföy verileri
    final userAssets = ref.watch(enhancedPortfolioProvider);
    // Mevcut kullanıcı
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FFFE),
      body: Stack(
        children: [
          // Ana içerik alanı
          RefreshIndicator(
            // Çekerek yenileme özelliği
            onRefresh: () async {
              // Currency verilerini manuel yenile
              ref.read(currencyNotifierProvider.notifier).manualRefresh();
              // Portföyü yenile
              await ref.read(userPortfolioProvider.notifier).refreshPortfolio();
            },
            child: CustomScrollView(
              // Gelişmiş scroll widget'ı
              slivers: [
                // 1. Header (Portföy özeti)
                SliverToBoxAdapter(
                  child: HeaderSectionWidget(
                    totalPortfolioValue: userAssets.totalValue,
                    totalChange: userAssets.totalChange,
                    changePercentage: userAssets.changePercentage,
                    userName: currentUser?.displayName ?? "Kullanıcı",
                  ),
                ),

                // 2. Hızlı İşlemler (Glassmorphism card)
                const SliverToBoxAdapter(
                  child: QuickActionsWidget(),
                ),

                // 3. Piyasa Durumu (Issue: Sadece izinli varlıklar)
                SliverToBoxAdapter(
                  child: MarketOverviewWidget(
                    currencies: currencies.isNotEmpty ? currencies.first : null,
                    isLoading: currencies.isEmpty,
                  ),
                ),

                // 4. Kullanıcı Varlıkları
                SliverToBoxAdapter(
                  child: UserAssetsWidget(
                    userAssets: userAssets.assets,
                    isLoading: userAssets.isLoading,
                  ),
                ),

                // Alt boşluk (navigation ve FAB için)
                const SliverToBoxAdapter(
                  child: SizedBox(height: 120),
                ),
              ],
            ),
          ),

          // Yüzen aksiyon butonu (FAB)
          const QuantumFabWidget(),
        ],
      ),
    );
  }
}

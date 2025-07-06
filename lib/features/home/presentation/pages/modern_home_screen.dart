import 'package:asset_tracker/features/home/presentation/state_management/provider/all_providers.dart';
import 'package:asset_tracker/features/home/presentation/widgets/modern/header_section_widget.dart';
import 'package:asset_tracker/features/home/presentation/widgets/modern/market_overview_widget.dart';
import 'package:asset_tracker/features/home/presentation/widgets/modern/quick_actions_widget.dart';
import 'package:asset_tracker/features/home/presentation/widgets/modern/quantum_fab_widget.dart';
import 'package:asset_tracker/features/home/presentation/widgets/modern/user_assets_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ModernHomeScreen extends ConsumerStatefulWidget {
  const ModernHomeScreen({super.key});

  @override
  ConsumerState<ModernHomeScreen> createState() => _ModernHomeScreenState();
}

class _ModernHomeScreenState extends ConsumerState<ModernHomeScreen> {
  @override
  Widget build(BuildContext context) {
    final currencies = ref.watch(currencyNotifierProvider);
    final userAssets = ref.watch(userPortfolioProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FFFE),
      body: Stack(
        children: [
          // Ana içerik alanı
          RefreshIndicator(
            // Çekerek yenileme özelliği
            onRefresh: () async {
              ref.read(currencyNotifierProvider.notifier).manualRefresh();
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
                    userName: "Zehra",
                  ),
                ),

                // Hızlı İşlemler
                const SliverToBoxAdapter(
                  child: QuickActionsWidget(),
                ),

                // Piyasa Durumu
                SliverToBoxAdapter(
                  child: MarketOverviewWidget(
                    currencies: currencies.isNotEmpty ? currencies.first : null,
                    isLoading: currencies.isEmpty,
                  ),
                ),

                // Kullanıcı Varlıkları
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

          // Yüzen aksiyon butonu
          const QuantumFabWidget(),
        ],
      ),
    );
  }
}

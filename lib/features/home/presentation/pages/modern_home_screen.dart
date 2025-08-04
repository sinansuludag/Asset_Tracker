import 'package:asset_tracker/core/services/user_service/state_management/riverpod/all_providers.dart';
import 'package:asset_tracker/features/home/presentation/state_management/provider/all_providers.dart';
import 'package:asset_tracker/features/home/presentation/widgets/modern/header_section_widget.dart';
import 'package:asset_tracker/features/home/presentation/widgets/modern/market_overview_widget.dart';
import 'package:asset_tracker/features/home/presentation/widgets/modern/quick_actions_widget.dart';
import 'package:asset_tracker/features/home/presentation/widgets/modern/user_assets_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Modern home screen
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
    final currentUser = ref.watch(commonUserProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FFFE),
      body: RefreshIndicator(
        onRefresh: () async {
          // Currency verilerini manuel yenile
          ref.read(currencyNotifierProvider.notifier).manualRefresh();
          // Portföyü yenile
          await ref.read(enhancedPortfolioProvider.notifier).refreshPortfolio();
        },
        child: CustomScrollView(
          physics:
              const AlwaysScrollableScrollPhysics(), // Her zaman scroll edilebilir
          slivers: [
            // 1. Header (Portföy özeti)
            SliverToBoxAdapter(
              child: HeaderSectionWidget(
                totalPortfolioValue: userAssets.totalValue,
                totalChange: userAssets.totalChange,
                changePercentage: userAssets.changePercentage,
                userName: currentUser.user.username ?? "Kullanıcı",
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
            SliverToBoxAdapter(
              child: SizedBox(height: 75.h),
            ),
          ],
        ),
      ),
    );
  }
}

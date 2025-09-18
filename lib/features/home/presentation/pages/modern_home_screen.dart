import 'package:asset_tracker/core/services/user_service/state_management/riverpod/all_providers.dart';
import 'package:asset_tracker/features/home/presentation/state_management/provider/all_providers.dart';
import 'package:asset_tracker/features/home/data/models/buying_asset_model.dart';
import 'package:asset_tracker/features/home/data/models/user_asset_model.dart';
import 'package:asset_tracker/features/home/presentation/widgets/modern/header_section_widget.dart';
import 'package:asset_tracker/features/home/presentation/widgets/modern/market_overview_widget.dart';
import 'package:asset_tracker/features/home/presentation/widgets/modern/quick_actions_widget.dart';
import 'package:asset_tracker/features/home/presentation/widgets/modern/user_assets_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ModernHomeScreen extends ConsumerWidget {
  const ModernHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currencies = ref.watch(currencyNotifierProvider);
    final currentUser = ref.watch(commonUserProvider);
    final assetsAsync = ref.watch(userAssetsStreamProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FFFE),
      body: assetsAsync.when(
        data: (rawAssets) {
          // Currency varsa UserAsset hesapla
          List<UserAssetModel> userAssets = [];
          if (currencies.isNotEmpty) {
            final currencyData = currencies.first;
            userAssets = rawAssets
                .whereType<BuyingAssetModel>()
                .map((b) {
                  final cur = currencyData.currencies[b.assetType];
                  if (cur == null) return null;
                  return UserAssetModel.fromBuyingAsset(b, cur);
                })
                .whereType<UserAssetModel>()
                .toList();
          }
          final totalInvested =
              userAssets.fold(0.0, (sum, u) => sum + u.totalInvestment);
          final totalValue =
              userAssets.fold(0.0, (sum, u) => sum + u.currentValue);
          final totalChange = userAssets.fold(0.0, (sum, u) => sum + u.change);
          final changePercentage =
              totalInvested <= 0 ? 0 : (totalChange / totalInvested) * 100;

          return RefreshIndicator(
            onRefresh: () async {
              ref.read(currencyNotifierProvider.notifier).manualRefresh();
              ref.read(assetNotifierProvider.notifier).refreshAssets();
            },
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: HeaderSectionWidget(
                    totalPortfolioValue: totalValue,
                    totalChange: totalChange,
                    changePercentage: changePercentage.toDouble(),
                    userName: currentUser.user.username ?? "Kullanıcı",
                  ),
                ),
                const SliverToBoxAdapter(child: QuickActionsWidget()),
                SliverToBoxAdapter(
                  child: MarketOverviewWidget(
                    currencies: currencies.isNotEmpty ? currencies.first : null,
                    isLoading: currencies.isEmpty,
                  ),
                ),
                SliverToBoxAdapter(
                  child: UserAssetsWidget(
                    userAssets: userAssets,
                    isLoading: userAssets.isEmpty,
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: 75.h)),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Hata: $e')),
      ),
    );
  }
}

import 'package:asset_tracker/core/constants/colors/app_colors.dart';
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
          RefreshIndicator(
            onRefresh: () async {
              ref.read(currencyNotifierProvider.notifier).manualRefresh();
              await ref.read(userPortfolioProvider.notifier).refreshPortfolio();
            },
            child: CustomScrollView(
              slivers: [
                // Header with Portfolio Summary
                SliverToBoxAdapter(
                  child: HeaderSectionWidget(
                    totalPortfolioValue: userAssets.totalValue,
                    totalChange: userAssets.totalChange,
                    changePercentage: userAssets.changePercentage,
                    userName: "Zehra",
                  ),
                ),

                // Quick Actions
                const SliverToBoxAdapter(
                  child: QuickActionsWidget(),
                ),

                // Market Overview
                SliverToBoxAdapter(
                  child: MarketOverviewWidget(
                    currencies: currencies.isNotEmpty ? currencies.first : null,
                    isLoading: currencies.isEmpty,
                  ),
                ),

                // User Assets
                SliverToBoxAdapter(
                  child: UserAssetsWidget(
                    userAssets: userAssets.assets,
                    isLoading: userAssets.isLoading,
                  ),
                ),

                // Bottom padding for navigation and FAB
                const SliverToBoxAdapter(
                  child: SizedBox(height: 120),
                ),
              ],
            ),
          ),

          // Quantum FAB
          const QuantumFabWidget(),
        ],
      ),
    );
  }
}

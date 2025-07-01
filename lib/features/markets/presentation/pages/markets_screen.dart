import 'package:asset_tracker/core/constants/colors/app_colors.dart';
import 'package:asset_tracker/features/markets/presentation/state_management/providers/markets_providers.dart';
import 'package:asset_tracker/features/markets/presentation/widgets/market_filter_tabs_widget.dart';
import 'package:asset_tracker/features/markets/presentation/widgets/market_header_widget.dart';
import 'package:asset_tracker/features/markets/presentation/widgets/market_item_widget.dart';
import 'package:asset_tracker/features/markets/presentation/widgets/market_search_widget.dart';
import 'package:asset_tracker/features/markets/presentation/widgets/trending_markets_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MarketsScreen extends ConsumerWidget {
  const MarketsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final marketsState = ref.watch(marketsProvider);
    final filteredMarkets = ref.watch(filteredMarketsProvider);
    final watchlist = ref.watch(watchlistProvider);
    final marketSummary = ref.watch(marketSummaryProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FFFE),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.read(marketsProvider.notifier).refreshMarkets();
        },
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: MarketHeaderWidget(
                marketSummary: marketSummary,
              ),
            ),

            // Filter Tabs
            const SliverToBoxAdapter(
              child: MarketFilterTabsWidget(),
            ),

            // Search
            const SliverToBoxAdapter(
              child: MarketSearchWidget(),
            ),

            // Trending Markets Section
            if (marketsState.trendingMarkets.isNotEmpty)
              SliverToBoxAdapter(
                child: TrendingMarketsWidget(
                  trendingMarkets: marketsState.trendingMarkets,
                ),
              ),

            // Markets List Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Tüm Piyasalar",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                    ),
                    IconButton(
                      onPressed: () => _showSortOptions(context, ref),
                      icon: const Icon(Icons.sort),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Loading State
            if (marketsState.isLoading)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(50),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),

            // Error State
            if (marketsState.hasError)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 48,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Hata Oluştu",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            marketsState.errorMessage,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              ref
                                  .read(marketsProvider.notifier)
                                  .refreshMarkets();
                            },
                            child: const Text("Tekrar Dene"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

            // Markets List
            if (!marketsState.isLoading && !marketsState.hasError)
              filteredMarkets.isEmpty
                  ? const SliverToBoxAdapter(
                      child: _EmptyMarketsWidget(),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final market = filteredMarkets[index];
                          final isInWatchlist = watchlist.any(
                            (item) => item.marketCode == market.code,
                          );

                          return MarketItemWidget(
                            market: market,
                            isInWatchlist: isInWatchlist,
                            onTap: () =>
                                _navigateToMarketDetail(context, market),
                            onWatchlistToggle: () => _toggleWatchlist(
                                ref, market.code, isInWatchlist),
                          );
                        },
                        childCount: filteredMarkets.length,
                      ),
                    ),

            // Bottom Padding
            const SliverToBoxAdapter(
              child: SizedBox(height: 100),
            ),
          ],
        ),
      ),
    );
  }

  void _showSortOptions(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _SortOptionsBottomSheet(ref: ref),
    );
  }

  void _navigateToMarketDetail(BuildContext context, dynamic market) {
    // TODO: Navigate to market detail page
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${market.name} detay sayfası yakında..."),
        backgroundColor: AppColors.primaryGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _toggleWatchlist(WidgetRef ref, String marketCode, bool isInWatchlist) {
    if (isInWatchlist) {
      // Remove from watchlist
      final watchlistItem = ref
          .read(watchlistProvider)
          .firstWhere((item) => item.marketCode == marketCode);
      ref
          .read(watchlistProvider.notifier)
          .removeFromWatchlist(watchlistItem.id);
    } else {
      // Add to watchlist with default alert
      ref.read(watchlistProvider.notifier).addToWatchlist(
            marketCode,
            0.0, // Default alert price
            'above',
          );
    }
  }
}

// Empty state widget
class _EmptyMarketsWidget extends StatelessWidget {
  const _EmptyMarketsWidget();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey.withOpacity(0.5),
          ),
          const SizedBox(height: 20),
          Text(
            "Sonuç Bulunamadı",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            "Arama kriterlerinizi değiştirerek tekrar deneyin",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// Sort options bottom sheet
class _SortOptionsBottomSheet extends StatelessWidget {
  final WidgetRef ref;

  const _SortOptionsBottomSheet({required this.ref});

  @override
  Widget build(BuildContext context) {
    final currentSortBy = ref.watch(sortByProvider);
    final currentAscending = ref.watch(sortAscendingProvider);

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Sıralama Seçenekleri",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildSortOption(
            context,
            'name',
            'Ada Göre',
            Icons.sort_by_alpha,
            currentSortBy == 'name',
          ),
          _buildSortOption(
            context,
            'price',
            'Fiyata Göre',
            Icons.attach_money,
            currentSortBy == 'price',
          ),
          _buildSortOption(
            context,
            'change',
            'Değişime Göre',
            Icons.trending_up,
            currentSortBy == 'change',
          ),
          _buildSortOption(
            context,
            'volume',
            'Hacme Göre',
            Icons.bar_chart,
            currentSortBy == 'volume',
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    ref.read(sortAscendingProvider.notifier).state = true;
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_upward),
                  label: const Text("Artan"),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: currentAscending
                        ? AppColors.primaryGreen.withOpacity(0.1)
                        : null,
                    foregroundColor:
                        currentAscending ? AppColors.primaryGreen : null,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    ref.read(sortAscendingProvider.notifier).state = false;
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_downward),
                  label: const Text("Azalan"),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: !currentAscending
                        ? AppColors.primaryGreen.withOpacity(0.1)
                        : null,
                    foregroundColor:
                        !currentAscending ? AppColors.primaryGreen : null,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSortOption(
    BuildContext context,
    String sortBy,
    String label,
    IconData icon,
    bool isSelected,
  ) {
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? AppColors.primaryGreen : AppColors.textSecondary,
      ),
      title: Text(
        label,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? AppColors.primaryGreen : AppColors.textPrimary,
        ),
      ),
      trailing: isSelected
          ? const Icon(
              Icons.check,
              color: AppColors.primaryGreen,
            )
          : null,
      onTap: () {
        ref.read(sortByProvider.notifier).state = sortBy;
        Navigator.pop(context);
      },
    );
  }
}

import 'package:asset_tracker/core/routing/route_names.dart';
import 'package:asset_tracker/core/constants/colors/app_colors.dart';
import 'package:asset_tracker/features/home/data/models/curreny_response_model.dart';
import 'package:asset_tracker/features/home/presentation/state_management/provider/allowed_assets_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Piyasa durumu widget'ı - Sadece izinli varlıkları gösterir
/// Issue gereksinimi: Öncelikli varlıklar (ALTIN, EURTRY, GBPTRY, PLATIN)
class MarketOverviewWidget extends ConsumerWidget {
  final CurrencyResponse? currencies;
  final bool isLoading;

  const MarketOverviewWidget({
    super.key,
    required this.currencies,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final priorityAssets = ref.watch(priorityAssetsProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // Başlık satırı
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Piyasa Durumu",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      fontSize: 20,
                    ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, RouteNames.markets);
                },
                child: Text(
                  "Tümünü Gör",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.primaryGreen,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          // Piyasa kartları
          SizedBox(
            height: 140,
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: priorityAssets.length,
                    itemBuilder: (context, index) {
                      final asset = priorityAssets[index];
                      final currencyData = currencies?.currencies[asset.id];

                      if (currencyData == null) return const SizedBox.shrink();

                      return _buildMarketCard(context, asset, currencyData);
                    },
                  ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  /// Tekil piyasa kartı
  Widget _buildMarketCard(BuildContext context, asset, currencyData) {
    final isPositive = (currencyData.buyingDir == 'up');
    final price = currencyData.buying ?? 0.0;

    // Mock değişim verileri - gerçek uygulamada önceki günden hesaplanmalı
    final change = 21.36;
    final changePercent = 0.50;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          RouteNames.marketDetail,
          arguments: {'marketCode': asset.id},
        );
      },
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border(
            left: BorderSide(color: AppColors.primaryGreen, width: 4),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              offset: const Offset(0, 4),
              blurRadius: 12,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Varlık ikonu (issue'deki symbol kullanımı)
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Center(
                      child: Text(
                        asset.symbol,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
                  // Trend ikonu
                  Icon(
                    isPositive ? Icons.trending_up : Icons.trending_down,
                    color: isPositive ? Colors.green : Colors.red,
                    size: 16,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Varlık adı (issue'deki displayName)
              Flexible(
                child: Text(
                  asset.displayName,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 4),
              // Fiyat
              Text(
                "₺${price.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              // Değişim
              Text(
                "${isPositive ? '+' : '-'}₺$change (+$changePercent%)",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isPositive ? Colors.green : Colors.red,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

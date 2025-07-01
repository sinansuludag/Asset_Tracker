import 'package:asset_tracker/core/constants/colors/app_colors.dart';
import 'package:asset_tracker/features/markets/data/models/market_model.dart';
import 'package:flutter/material.dart';

class TrendingMarketsWidget extends StatelessWidget {
  final List<MarketModel> trendingMarkets;

  const TrendingMarketsWidget({
    super.key,
    required this.trendingMarkets,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Row(
            children: [
              const Icon(
                Icons.local_fire_department,
                color: Colors.red,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                "Trend Olan Piyasalar",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 130, // INCREASED HEIGHT TO PREVENT OVERFLOW
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: trendingMarkets.length,
            itemBuilder: (context, index) {
              final market = trendingMarkets[index];
              return _buildTrendingCard(context, market);
            },
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildTrendingCard(BuildContext context, MarketModel market) {
    final isPositive = market.change >= 0;

    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryGreen.withOpacity(0.1),
            AppColors.primaryBlue.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primaryGreen.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGreen.withOpacity(0.1),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min, // FIXED: PREVENT OVERFLOW
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Center(
                    child: Text(
                      market.icon,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.local_fire_department,
                    color: Colors.red,
                    size: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            // FIXED: FLEXIBLE TEXT TO PREVENT OVERFLOW
            Flexible(
              child: Text(
                market.name,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "₺${market.currentPrice.toStringAsFixed(1)}",
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Row(
              mainAxisSize: MainAxisSize.min, // PREVENT ROW OVERFLOW
              children: [
                Icon(
                  isPositive ? Icons.trending_up : Icons.trending_down,
                  color: isPositive ? Colors.green : Colors.red,
                  size: 12,
                ),
                const SizedBox(width: 2),
                Flexible(
                  child: Text(
                    "${isPositive ? '+' : ''}${market.changePercentage.toStringAsFixed(1)}%",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: isPositive ? Colors.green : Colors.red,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

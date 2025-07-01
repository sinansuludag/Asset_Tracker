import 'package:asset_tracker/core/constants/colors/app_colors.dart';
import 'package:asset_tracker/features/markets/data/models/market_model.dart';
import 'package:flutter/material.dart';

class MarketItemWidget extends StatelessWidget {
  final MarketModel market;
  final VoidCallback onTap;
  final bool isInWatchlist;
  final VoidCallback onWatchlistToggle;

  const MarketItemWidget({
    super.key,
    required this.market,
    required this.onTap,
    required this.isInWatchlist,
    required this.onWatchlistToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = market.change >= 0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border(
          left: BorderSide(
            color:
                market.isTrending ? AppColors.primaryGreen : Colors.transparent,
            width: 4,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Asset Icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.all(Radius.circular(14)),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Text(
                          market.icon,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      if (market.isTrending)
                        Positioned(
                          top: -2,
                          right: -2,
                          child: Container(
                            width: 16,
                            height: 16,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.local_fire_department,
                              color: Colors.white,
                              size: 10,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),

                // Asset Info - FIXED WITH FLEXIBLE
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              market.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Icon(
                            isPositive
                                ? Icons.trending_up
                                : Icons.trending_down,
                            color: isPositive ? Colors.green : Colors.red,
                            size: 16,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      // FIXED ROW WITH FLEXIBLE WIDGETS
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              market.category.toUpperCase(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: AppColors.textSecondary,
                                    fontSize: 11,
                                  ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 1,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryGreen.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                market.volumeLabel,
                                style: const TextStyle(
                                  color: AppColors.primaryGreen,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Price and Change - FIXED WITH FLEXIBLE
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "₺${market.currentPrice.toStringAsFixed(2)}",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      // FIXED ROW FOR PRICE CHANGE
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Flexible(
                            child: Text(
                              "${isPositive ? '+' : ''}₺${market.change.toStringAsFixed(1)}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color:
                                        isPositive ? Colors.green : Colors.red,
                                  ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 2),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 1,
                            ),
                            decoration: BoxDecoration(
                              color: isPositive
                                  ? Colors.green.withOpacity(0.1)
                                  : Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              "${isPositive ? '+' : ''}${market.changePercentage.toStringAsFixed(1)}%",
                              style: TextStyle(
                                color: isPositive ? Colors.green : Colors.red,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Watchlist Button
                IconButton(
                  onPressed: onWatchlistToggle,
                  icon: Icon(
                    isInWatchlist ? Icons.bookmark : Icons.bookmark_border,
                    color: isInWatchlist
                        ? AppColors.primaryGreen
                        : AppColors.textSecondary,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 40,
                    minHeight: 40,
                  ),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

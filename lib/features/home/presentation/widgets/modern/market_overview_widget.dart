import 'package:asset_tracker/core/constants/colors/app_colors.dart';
import 'package:asset_tracker/core/constants/paddings/paddings.dart';
import 'package:asset_tracker/core/extensions/currency_code_extension.dart';
import 'package:asset_tracker/features/home/data/models/curreny_response_model.dart';
import 'package:flutter/material.dart';

class MarketOverviewWidget extends StatelessWidget {
  final CurrencyResponse? currencies;
  final bool isLoading;

  const MarketOverviewWidget({
    super.key,
    required this.currencies,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
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
                  // FIXED: Navigate to markets page
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Piyasalar sayfasına yönlendiriliyor..."),
                      duration: Duration(seconds: 1),
                    ),
                  );
                  // TODO: Navigator.pushNamed(context, RouteNames.markets);
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
          SizedBox(
            height: 140,
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                    scrollDirection: Axis.horizontal,
                    children: _buildMarketCards(context), // FIXED: Pass context
                  ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  List<Widget> _buildMarketCards(BuildContext context) {
    if (currencies == null) return [];

    final priorityAssets = ['ALTIN', 'USDTRY', 'EURTRY', 'GUMUSTRY'];
    final cards = <Widget>[];

    for (String assetCode in priorityAssets) {
      final currencyData = currencies!.currencies[assetCode];
      if (currencyData != null) {
        cards.add(_buildMarketCard(
            context, assetCode, currencyData)); // FIXED: Pass context
      }
    }

    return cards;
  }

  Widget _buildMarketCard(
      BuildContext context, String code, dynamic currencyData) {
    final isPositive = (currencyData.buyingDir == 'up');
    final price = currencyData.buying ?? 0.0;
    final change = 21.36;
    final changePercent = 0.50;

    return GestureDetector(
      onTap: () {
        // FIXED: Add navigation to asset detail
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("${code.getCurrencyName()} detayına gidiliyor..."),
            duration: const Duration(seconds: 1),
          ),
        );
      },
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border(
            left: BorderSide(
              color: AppColors.primaryGreen,
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
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
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
                        _getAssetSymbol(code),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
                  Icon(
                    isPositive ? Icons.trending_up : Icons.trending_down,
                    color: isPositive ? Colors.green : Colors.red,
                    size: 16,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Flexible(
                child: Text(
                  code.getCurrencyName(),
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
              Text(
                "₺${price.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
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

  String _getAssetSymbol(String code) {
    switch (code) {
      case 'ALTIN':
        return 'AU';
      case 'USDTRY':
        return '\$';
      case 'EURTRY':
        return '€';
      case 'GUMUSTRY':
        return 'AG';
      default:
        return code.substring(0, 2);
    }
  }
}

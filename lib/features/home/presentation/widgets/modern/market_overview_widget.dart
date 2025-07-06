import 'package:asset_tracker/core/routing/route_names.dart';
import 'package:asset_tracker/core/constants/colors/app_colors.dart';
import 'package:asset_tracker/core/constants/paddings/paddings.dart';
import 'package:asset_tracker/core/extensions/currency_code_extension.dart';
import 'package:asset_tracker/features/home/data/models/curreny_response_model.dart';
import 'package:flutter/material.dart';

/// Piyasa durumu widget'ı
class MarketOverviewWidget extends StatelessWidget {
  final CurrencyResponse? currencies; // Döviz verileri
  final bool isLoading; // Yükleniyor durumu

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
              // "Tümünü Gör" butonu
              TextButton(
                onPressed: () {
                  // UPDATED: Navigate to markets screen
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
                : ListView(
                    scrollDirection: Axis.horizontal,
                    children: _buildMarketCards(context),
                  ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // Piyasa kartlarını oluşturma
  List<Widget> _buildMarketCards(BuildContext context) {
    if (currencies == null) return [];

    // Öncelikli varlıklar
    final priorityAssets = ['ALTIN', 'USDTRY', 'EURTRY', 'GUMUSTRY'];
    final cards = <Widget>[];

    // Her öncelikli varlık için kart oluştur
    for (String assetCode in priorityAssets) {
      final currencyData = currencies!.currencies[assetCode];
      if (currencyData != null) {
        cards.add(_buildMarketCard(context, assetCode, currencyData));
      }
    }

    return cards;
  }

  // Tekil piyasa kartı
  Widget _buildMarketCard(
      BuildContext context, String code, dynamic currencyData) {
    final isPositive = (currencyData.buyingDir == 'up'); // Yön kontrolü
    final price = currencyData.buying ?? 0.0; // Fiyat
    final change = 21.36; // Mock veri - gerçekte hesaplanmalı
    final changePercent = 0.50; // Mock veri - gerçekte hesaplanmalı

    return GestureDetector(
      onTap: () {
        // Detay sayfasına git
        Navigator.pushNamed(
          context,
          RouteNames.marketDetail,
          arguments: {'marketCode': code},
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
                // Üst kısım - İkon ve trend
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Varlık ikonu
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
                  // Trend ikonu
                  Icon(
                    isPositive ? Icons.trending_up : Icons.trending_down,
                    color: isPositive ? Colors.green : Colors.red,
                    size: 16,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Varlık adı
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

  // Varlık sembolü belirleme
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

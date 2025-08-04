import 'package:asset_tracker/core/routing/route_names.dart';
import 'package:asset_tracker/core/constants/colors/app_colors.dart';
import 'package:asset_tracker/features/home/data/models/curreny_response_model.dart';
import 'package:asset_tracker/features/home/data/models/asset_definition_model.dart';
import 'package:asset_tracker/features/home/data/models/currency_data_model.dart';
import 'package:asset_tracker/features/home/presentation/state_management/provider/allowed_assets_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math' as math;

/// Piyasa durumu widget'ı - Sadece izinli varlıkları gösterir
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

    // ✅ DEĞİŞİKLİK 1: Akıllı filtreleme - Sadece tam verisi olan asset'ları al
    final availableAssets = priorityAssets.where((asset) {
      final currencyData = currencies?.currencies[asset.id];
      return currencyData != null && currencyData.buying != null;
    }).toList();

    // ✅ DEĞİŞİKLİK 2: Minimum 3 kart garantisi
    final displayCount = math.max(3, isLoading ? 3 : availableAssets.length);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
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
                      fontSize: 20.sp, // ✅ DEĞİŞİKLİK 3: .r → .sp (metin için)
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
                        fontSize:
                            14.sp, // ✅ DEĞİŞİKLİK 4: .r → .sp (metin için)
                      ),
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          // ✅ DEĞİŞİKLİK 5: Yeni ListView mantığı
          SizedBox(
            height: 130.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: displayCount,
              itemBuilder: (context, index) {
                // Loading durumunda skeleton göster
                if (isLoading) {
                  return _buildSkeletonCard();
                }

                // Gerçek veri varsa göster
                if (index < availableAssets.length) {
                  final asset = availableAssets[index];
                  final currencyData = currencies!.currencies[asset.id]!;
                  return _buildMarketCard(context, asset, currencyData);
                }

                // Boş slotları skeleton ile doldur
                return _buildSkeletonCard();
              },
            ),
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }

  /// ✅ DEĞİŞİKLİK 6: YENİ FONKSİYON - Skeleton loading kartı
  Widget _buildSkeletonCard() {
    return Container(
      width: 130.w,
      margin: EdgeInsets.only(right: 14.w),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16.r),
        border: Border(
          left: BorderSide(color: Colors.grey[200]!, width: 4.w),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Skeleton icon
                Container(
                  width: 30.w,
                  height: 30.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                // Skeleton trend icon
                Container(
                  width: 16.r,
                  height: 16.r,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            // Skeleton name
            Container(
              width: 70.w,
              height: 12.h,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(6.r),
              ),
            ),
            SizedBox(height: 4.h),
            // Skeleton price
            Container(
              width: 60.w,
              height: 13.h,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(6.r),
              ),
            ),
            SizedBox(height: 4.h),
            // Skeleton change
            Container(
              width: 80.w,
              height: 11.h,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(6.r),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Tekil piyasa kartı
  Widget _buildMarketCard(BuildContext context, AssetDefinitionModel asset,
      CurrencyData currencyData) {
    // ✅ DEĞİŞİKLİK 7: Gelişmiş hesaplama kullan
    final metrics = _calculateAdvancedPriceMetrics(currencyData);
    final change = metrics['change'] as double;
    final changePercent = metrics['changePercent'] as double;
    final isPositive = metrics['isPositive'] as bool;
    final confidence = metrics['confidence'] as String;

    final price = currencyData.buying ?? 0.0;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          RouteNames.marketDetail,
          arguments: {'marketCode': asset.id},
        );
      },
      child: Container(
        width: 130.w,
        margin: EdgeInsets.only(right: 14.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border(
            left: BorderSide(
                // ✅ DEĞİŞİKLİK 8: Güvenilirlik göstergesi
                color: confidence == 'high'
                    ? AppColors.primaryGreen
                    : confidence == 'medium'
                        ? Colors.orange
                        : Colors.grey,
                width: 4.w),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(20),
              offset: Offset(0, 4.h), // ✅ DEĞİŞİKLİK 9: Offset için .h
              blurRadius: 12.r,
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(12.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Varlık ikonu
                  Container(
                    width: 30.w,
                    height: 30.h,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.all(Radius.circular(10.r)),
                    ),
                    child: Center(
                      child: Text(
                        asset.symbol,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 11.sp,
                        ),
                      ),
                    ),
                  ),
                  // Trend ikonu
                  Icon(
                    isPositive ? Icons.trending_up : Icons.trending_down,
                    color: isPositive ? Colors.green : Colors.red,
                    size: 16.r,
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              // Varlık adı
              Flexible(
                child: Text(
                  asset.displayName,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(height: 4.h),
              // Fiyat
              Text(
                "₺${price.toStringAsFixed(2)}",
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 1.h),
              // Değişim
              Text(
                "${isPositive ? '+' : ''}₺${change.toStringAsFixed(2)} (${changePercent.toStringAsFixed(2)}%)",
                style: TextStyle(
                  fontSize: 11.sp,
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

  /// ✅ DEĞİŞİKLİK 10: YENİ FONKSİYON - Gelişmiş fiyat hesaplama
  Map<String, dynamic> _calculateAdvancedPriceMetrics(
      CurrencyData currencyData) {
    final currentPrice = currencyData.buying ?? 0.0;
    final previousClose = currencyData.close ?? 0.0;
    final high = currencyData.high ?? 0.0;
    final low = currencyData.low ?? 0.0;

    double change = 0.0;
    double changePercent = 0.0;
    bool isPositive = false;
    String confidence = 'low'; // Hesaplama güvenilirliği

    // En güvenilir: Önceki kapanış vs şu anki
    if (previousClose > 0 && currentPrice > 0) {
      change = currentPrice - previousClose;
      changePercent = (change / previousClose) * 100;
      confidence = 'high';
    }
    // Orta güvenilir: High-low ortalaması
    else if (high > 0 && low > 0) {
      final midPrice = (high + low) / 2;
      change = currentPrice - midPrice;
      changePercent = midPrice > 0 ? (change / midPrice) * 100 : 0.0;
      confidence = 'medium';
    }
    // Düşük güvenilir: Sabit %1 varsayımı
    else {
      change = currentPrice * 0.01;
      changePercent = 1.0;
      confidence = 'low';
    }

    // Trend yönü belirleme - WebSocket'ten gelen dir bilgisini kullan
    if (currencyData.buyingDir?.toLowerCase() == 'up') {
      isPositive = true;
    } else if (currencyData.buyingDir?.toLowerCase() == 'down') {
      isPositive = false;
    } else {
      isPositive = change >= 0;
    }

    return {
      'change': change,
      'changePercent': changePercent,
      'isPositive': isPositive,
      'confidence': confidence,
    };
  }
}

import 'package:asset_tracker/core/constants/colors/app_colors.dart';
import 'package:asset_tracker/features/currencyAssets/presentation/pages/modern_portfolio_screen.dart';
import 'package:asset_tracker/features/home/data/models/user_asset_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Kullanıcı varlıkları listesi widget'ı - SKELETON LOADING İLE
class UserAssetsWidget extends StatelessWidget {
  final List<UserAssetModel> userAssets; // Kullanıcının varlıkları
  final bool isLoading; // Yükleniyor durumu

  const UserAssetsWidget({
    super.key,
    required this.userAssets,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    // Minimum 3 kart göster (skeleton ile doldur)

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 20.w,
      ),
      child: Column(
        children: [
          // Başlık satırı
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Varlıklarım",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      fontSize: 20.sp,
                    ),
              ),
              // Portföy sayfasına git
              TextButton(
                onPressed: isLoading
                    ? null
                    : () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const ModernPortfolioScreen(),
                          ),
                        );
                      },
                child: Text(
                  "Tümünü Gör",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isLoading
                            ? Colors.grey[400]
                            : AppColors.primaryGreen,
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                      ),
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),

          if (isLoading)
            // Loading: 3 skeleton kart göster
            Column(
              children: List.generate(3, (index) => _buildSkeletonCard()),
            )
          else if (userAssets.isEmpty)
            // Empty: Boş durum göster
            _buildEmptyState(context)
          else
            // Data: Gerçek varlık kartlarını göster (maksimum 3 adet)
            Column(
              children: userAssets
                  .take(3)
                  .map((asset) => _buildAssetCard(context, asset))
                  .toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildSkeletonCard() {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey[200]!, width: 1.w),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Row(
          children: [
            // Skeleton Icon
            Container(
              width: 48.w,
              height: 48.h,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(14.r),
              ),
            ),
            SizedBox(width: 12.w),

            // Skeleton Varlık bilgileri
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Skeleton varlık adı
                  Container(
                    width: 120.w,
                    height: 16.h,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  // Skeleton miktar
                  Container(
                    width: 80.w,
                    height: 12.h,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(width: 8.w),

            // Skeleton Değer ve değişim
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Skeleton güncel değer
                Container(
                  width: 70.w,
                  height: 16.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                SizedBox(height: 6.h),
                // Skeleton değişim
                Container(
                  width: 50.w,
                  height: 12.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Boş durum widget'ı (varlık yoksa)
  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(40.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(40),
            offset: Offset(0, 4.h),
            blurRadius: 12.r,
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.account_balance_wallet_outlined,
            size: 48.r,
            color: Colors.grey.withAlpha(125),
          ),
          SizedBox(height: 16.h),
          Text(
            "Henüz varlığınız yok",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                  fontSize: 16.sp,
                ),
          ),
          SizedBox(height: 8.h),
          Text(
            "İlk varlığınızı eklemek için portföy sayfasına gidin",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 14.sp,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Varlık kartı
  Widget _buildAssetCard(BuildContext context, UserAssetModel asset) {
    final isPositive = asset.change >= 0;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(40),
            offset: Offset(0, 4.h),
            blurRadius: 12.r,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Row(
          children: [
            // Asset Icon
            Container(
              width: 48.w,
              height: 48.h,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.all(Radius.circular(14.r)),
              ),
              child: Center(
                child: Text(
                  asset.icon,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),

            // Varlık bilgileri
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Varlık adı
                  Text(
                    asset.displayName,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                          fontSize: 12.sp,
                        ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  SizedBox(height: 2.h),
                  // Miktar
                  Text(
                    "${asset.quantity} ${_getQuantityUnit(asset.assetType)}",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 12.sp,
                        ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),

            SizedBox(width: 8.w),

            // Değer ve değişim - Sağa hizalı
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Güncel değer
                Text(
                  "₺${asset.currentValue.toStringAsFixed(2)}",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        fontSize: 14.sp,
                      ),
                ),
                SizedBox(height: 2.h),
                // Değişim
                Text(
                  "${isPositive ? '+' : ''}₺${asset.change.toStringAsFixed(2)}",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isPositive ? Colors.green : Colors.red,
                        fontSize: 12.sp,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Varlık türüne göre birim belirleme
  String _getQuantityUnit(String assetType) {
    switch (assetType.toLowerCase()) {
      case 'altin':
      case 'ayar14':
      case 'ayar22':
      case 'kulcealtin':
      case 'gumustry':
        return 'gram';
      case 'usdtry':
        return 'USD';
      case 'eurtry':
        return 'EUR';
      case 'gbptry':
        return 'GBP';
      default:
        return 'adet';
    }
  }
}

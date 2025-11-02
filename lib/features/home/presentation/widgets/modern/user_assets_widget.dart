// lib/features/home/presentation/widgets/modern/user_assets_widget.dart

import 'package:asset_tracker/core/constants/colors/app_colors.dart';
import 'package:asset_tracker/core/routing/route_names.dart';
import 'package:asset_tracker/core/utils/get_asset_icon.dart';
import 'package:asset_tracker/core/utils/get_quantity_unit.dart';
import 'package:asset_tracker/features/currencyAssets/presentation/pages/modern_portfolio_screen.dart';
import 'package:asset_tracker/features/home/data/models/user_asset_model.dart';
import 'package:asset_tracker/features/home/presentation/pages/asset_detail_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class UserAssetsWidget extends ConsumerWidget {
  final List<UserAssetModel> userAssets;
  final bool isLoading;

  const UserAssetsWidget({
    super.key,
    required this.userAssets,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          // Başlık
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 40.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primaryGreen.withAlpha(200),
                          AppColors.primaryGreen,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      Icons.account_balance_wallet,
                      color: Colors.white,
                      size: 20.r,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Varlıklarım",
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                  fontSize: 20.sp,
                                ),
                      ),
                      Text(
                        isLoading
                            ? "Güncelleniyor..."
                            : "En fazla 3 varlık gösteriliyor.",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              TextButton.icon(
                onPressed: isLoading
                    ? null
                    : () {
                        Navigator.pushNamed(
                            context, RouteNames.modernPortfolio);
                      },
                icon: Icon(
                  Icons.arrow_forward_ios,
                  size: 14.r,
                  color: isLoading ? Colors.grey[400] : AppColors.primaryGreen,
                ),
                label: Text(
                  "Tümü",
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
          SizedBox(height: 16.h),

          if (isLoading)
            Column(
              children: List.generate(3, (index) => _buildSkeletonCard()),
            )
          else if (userAssets.isEmpty)
            _buildEmptyState(context)
          else
            Column(
              children: userAssets
                  .take(3)
                  .map((asset) => _buildModernAssetCard(context, asset, ref))
                  .toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildModernAssetCard(
      BuildContext context, UserAssetModel asset, WidgetRef ref) {
    final isPositive = asset.change >= 0;
    final nf = NumberFormat('#,##0.00');
    final percentFormat = NumberFormat('#,##0.0');

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AssetDetailScreen(
              assetType: asset.assetType,
              assetSubType: asset.isBracelet == true ? 'bracelet' : 'normal',
              displayName: asset.displayName,
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 14.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              isPositive ? Colors.green.withAlpha(5) : Colors.red.withAlpha(5),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isPositive
                ? Colors.green.withAlpha(25)
                : Colors.red.withAlpha(25),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: (isPositive ? Colors.green : Colors.red).withAlpha(20),
              offset: Offset(0, 8.h),
              blurRadius: 20.r,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Stack(
          children: [
            // Arka plan deseni
            Positioned(
              right: -20.w,
              top: -20.h,
              child: Container(
                width: 100.w,
                height: 100.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (isPositive ? Colors.green : Colors.red).withAlpha(8),
                ),
              ),
            ),

            // İçerik
            Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                children: [
                  // Üst kısım
                  Row(
                    children: [
                      // Sol - Icon ve isim
                      Container(
                        width: 45.w,
                        height: 45.h,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primaryGreen.withAlpha(225),
                              AppColors.primaryGreen,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(15.r),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryGreen.withAlpha(75),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            getAssetIcon(
                                asset.assetType,
                                (asset.isBracelet != false)
                                    ? 'bracelet'
                                    : 'normal'),
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),

                      // Orta - Varlık bilgileri
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    asset.displayName,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                      fontSize: 15.sp,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(width: 4.w),
                                // İşlem sayısı badge
                                StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('asset_summary')
                                      .where('userId',
                                          isEqualTo: FirebaseAuth
                                              .instance.currentUser?.uid)
                                      .where('assetType',
                                          isEqualTo: asset.assetType)
                                      .where('assetSubType',
                                          isEqualTo: asset.isBracelet == true
                                              ? 'bracelet'
                                              : 'normal')
                                      .limit(1)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData ||
                                        snapshot.data!.docs.isEmpty) {
                                      return const SizedBox.shrink();
                                    }

                                    final data = snapshot.data!.docs.first
                                        .data() as Map<String, dynamic>;
                                    final transactionCount =
                                        data['transactionCount'] ?? 1;

                                    return Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8.w, vertical: 3.h),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            AppColors.primaryGreen
                                                .withAlpha(25),
                                            AppColors.primaryGreen
                                                .withAlpha(37),
                                          ],
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(12.r),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.receipt_long,
                                            size: 11.r,
                                            color: AppColors.primaryGreen,
                                          ),
                                          SizedBox(width: 4.w),
                                          Text(
                                            '$transactionCount',
                                            style: TextStyle(
                                              fontSize: 11.sp,
                                              color: AppColors.primaryGreen,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: 6.h),
                            Row(
                              children: [
                                Icon(
                                  Icons.inventory_2_outlined,
                                  size: 12.r,
                                  color: Colors.grey[600],
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  "${asset.quantity.toStringAsFixed(0)} ${getQuantityUnit(asset.assetType, asset.isBracelet ?? false)}",
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  " • ",
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 13.sp,
                                  ),
                                ),
                                Text(
                                  "₺${nf.format(asset.averagePrice)}",
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Sağ - Değişim göstergesi
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 8.h),
                        decoration: BoxDecoration(
                          color: isPositive
                              ? Colors.green.withAlpha(25)
                              : Colors.red.withAlpha(25),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: isPositive
                                ? Colors.green.withAlpha(50)
                                : Colors.red.withAlpha(50),
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isPositive
                                      ? Icons.trending_up_rounded
                                      : Icons.trending_down_rounded,
                                  color: isPositive ? Colors.green : Colors.red,
                                  size: 16.r,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  "%${percentFormat.format(asset.changePercentage.abs())}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color:
                                        isPositive ? Colors.green : Colors.red,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              "${isPositive ? '+' : ''}₺${nf.format(asset.change)}",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: isPositive
                                    ? Colors.green[700]
                                    : Colors.red[700],
                                fontSize: 11.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 14.h),

                  // Alt kısım - Detaylı bilgiler
                  Container(
                    padding: EdgeInsets.all(12.r),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: Colors.grey[200]!,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildInfoColumn(
                          context,
                          "Yatırım",
                          "₺${nf.format(asset.totalInvestment)}",
                          Icons.account_balance_wallet_outlined,
                        ),
                        Container(
                          width: 1,
                          height: 35.h,
                          color: Colors.grey[300],
                        ),
                        _buildInfoColumn(
                          context,
                          "Güncel Değer",
                          "₺${nf.format(asset.currentValue)}",
                          Icons.price_check,
                        ),
                        Container(
                          width: 1,
                          height: 35.h,
                          color: Colors.grey[300],
                        ),
                        _buildInfoColumn(
                          context,
                          "Güncel Fiyat",
                          "₺${nf.format(asset.currentPrice)}",
                          Icons.trending_up,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoColumn(
      BuildContext context, String label, String value, IconData icon) {
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 12.r, color: Colors.grey[600]),
              SizedBox(width: 4.w),
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonCard() {
    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.grey[200]!, width: 1.5),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 50.w,
                height: 50.h,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(15.r),
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 140.w,
                      height: 16.h,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      width: 100.w,
                      height: 12.h,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 70.w,
                height: 45.h,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Container(
            height: 60.h,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(40.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white,
            AppColors.primaryGreen.withAlpha(5),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: AppColors.primaryGreen.withAlpha(25),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGreen.withAlpha(20),
            offset: Offset(0, 8.h),
            blurRadius: 20.r,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 80.w,
            height: 80.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryGreen.withAlpha(25),
                  AppColors.primaryGreen.withAlpha(50),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.add_card,
              size: 40.r,
              color: AppColors.primaryGreen,
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            "Portföyünüz Boş",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  fontSize: 18.sp,
                ),
          ),
          SizedBox(height: 8.h),
          Text(
            "İlk varlığınızı ekleyerek yatırımlarınızı\ntakip etmeye başlayın",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                  fontSize: 14.sp,
                  height: 1.5,
                ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20.h),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ModernPortfolioScreen(),
                ),
              );
            },
            icon: Icon(Icons.add, size: 18.r),
            label: const Text("Varlık Ekle"),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

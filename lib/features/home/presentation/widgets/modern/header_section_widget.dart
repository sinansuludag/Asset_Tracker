import 'package:asset_tracker/core/constants/colors/app_colors.dart';
import 'package:asset_tracker/core/routing/route_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Üst kısım - Kullanıcı karşılama ve portföy özeti
class HeaderSectionWidget extends StatelessWidget {
  final double totalPortfolioValue; // Toplam portföy değeri
  final double totalChange; // Toplam değişim miktarı
  final double changePercentage; // Değişim yüzdesi
  final String userName;

  const HeaderSectionWidget({
    super.key,
    required this.totalPortfolioValue,
    required this.totalChange,
    required this.changePercentage,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 40.h),
          child: Column(
            children: [
              // Header Top
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Üst kısım - Selamlama ve butonlar
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Merhaba,",
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Colors.white.withAlpha(240),
                                    fontSize: 14.sp,
                                  ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          userName,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.sp,
                              ),
                          overflow: TextOverflow.ellipsis, // Taşma kontrolü
                          maxLines: 1, // Tek satırda sınırla
                        ),
                      ],
                    ),
                  ),
                  // Sağ taraf - Aksiyon butonları
                  Row(
                    mainAxisSize: MainAxisSize.min, // İçeriğe göre boyutlandır
                    children: [
                      _buildActionButton(
                        icon: Icons.settings_outlined,
                        onTap: () {
                          Navigator.pushNamed(context, RouteNames.profile);
                        },
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 25.h),

              // Portföy özeti
              Column(
                children: [
                  // Ana portföy değeri
                  Text(
                    "₺${totalPortfolioValue.toStringAsFixed(2)}",
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 36.sp,
                        ),
                    textAlign: TextAlign.center, // Merkeze hizala
                  ),
                  SizedBox(height: 8.h),
                  // Portföy açıklaması ve değişim
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        // Expanded yerine Flexible
                        child: Text(
                          "Toplam Portföy Değeri",
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Colors.white.withAlpha(240),
                                    fontSize: 14.sp,
                                  ),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis, // Taşma kontrolü
                        ),
                      ),
                      SizedBox(width: 8.w),
                      // Değişim badge'i
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: totalChange >= 0
                              ? Colors.green.withAlpha(225)
                              : Colors.red.withAlpha(225),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              // Text widget için Flexible
                              child: Text(
                                "₺${totalChange.toStringAsFixed(2)}",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12.sp,
                                    ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Icon(
                              totalChange >= 0
                                  ? Icons.trending_up
                                  : Icons.trending_down,
                              color: Colors.white,
                              size: 16.r,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Aksiyon butonu oluşturma helper'ı
  Widget _buildActionButton({
    required IconData icon,
    String? badge,
    required VoidCallback onTap,
  }) {
    return Stack(
      clipBehavior: Clip.none, // Taşma kontrolü
      children: [
        // Ana buton container'ı
        Container(
          width: 40.w,
          height: 40.h,
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(65),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: Colors.white.withAlpha(65),
              width: 1.w,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(12.r),
              child: Icon(icon, color: Colors.white, size: 20.r),
            ),
          ),
        ),
        // Badge (varsa)
        if (badge != null)
          Positioned(
            right: -2,
            top: -2,
            child: Container(
              padding: EdgeInsets.all(4.r),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              constraints: BoxConstraints(minWidth: 18.w, minHeight: 18.h),
              child: Text(
                badge,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10.r,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}

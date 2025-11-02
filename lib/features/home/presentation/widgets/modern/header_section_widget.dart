import 'package:asset_tracker/core/constants/colors/app_colors.dart';
import 'package:asset_tracker/core/routing/route_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Üst kısım - Kullanıcı karşılama ve portföy özeti
class HeaderSectionWidget extends StatelessWidget {
  final double totalPortfolioValue;
  final double totalChange;
  final double changePercentage;
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
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1DD1A1),
            Color(0xFF26D0CE),
            Color(0xFF00E5FF),
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 32.h),
          child: Column(
            children: [
              // Üst satır - Selamlama ve ayarlar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Merhaba,",
                          style: TextStyle(
                            color: Colors.white.withAlpha(220),
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          userName,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 22.sp,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 42.w,
                    height: 42.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(80),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: Colors.white.withAlpha(100),
                        width: 1.w,
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, RouteNames.profile);
                        },
                        borderRadius: BorderRadius.circular(12.r),
                        child: Icon(
                          Icons.settings_rounded,
                          color: Colors.white,
                          size: 20.r,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 28.h),

              // Portföy değeri bölümü
              Column(
                children: [
                  Text(
                    "₺${totalPortfolioValue.toStringAsFixed(2)}",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 38.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Toplam Portföy Değeri",
                        style: TextStyle(
                          color: Colors.white.withAlpha(220),
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 5.h,
                        ),
                        decoration: BoxDecoration(
                          color: totalChange >= 0
                              ? Colors.green.shade400
                              : Colors.red.shade400,
                          borderRadius: BorderRadius.circular(8.r),
                          boxShadow: [
                            BoxShadow(
                              color: (totalChange >= 0
                                      ? Colors.green.shade400
                                      : Colors.red.shade400)
                                  .withAlpha(150),
                              offset: const Offset(0, 4),
                              blurRadius: 12.r,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              totalChange >= 0
                                  ? Icons.trending_up
                                  : Icons.trending_down,
                              color: Colors.white,
                              size: 14.r,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              "${totalChange >= 0 ? '+' : ''}₺${totalChange.toStringAsFixed(2)} (${changePercentage.toStringAsFixed(2)}%)",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12.sp,
                              ),
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
}

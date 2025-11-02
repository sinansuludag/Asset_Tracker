import 'package:asset_tracker/core/constants/colors/app_colors.dart';
import 'package:asset_tracker/features/home/presentation/widgets/modern/ultra_modern_buying_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Modern ve uyumlu Varlık Ekle kartı
class QuickActionsWidget extends StatelessWidget {
  const QuickActionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: GestureDetector(
        onTap: () => showUltraModernBuyingDialog(context),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.teal.shade50,
                Colors.teal.shade100.withAlpha(60),
              ],
            ),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: Colors.teal.shade200,
              width: 1.5.w,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.teal.withAlpha(40),
                offset: const Offset(0, 4),
                blurRadius: 16.r,
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
            child: Row(
              children: [
                Container(
                  width: 56.w,
                  height: 56.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.teal.shade500,
                        Colors.teal.shade600,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(14.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.teal.shade400.withAlpha(150),
                        offset: const Offset(0, 4),
                        blurRadius: 12.r,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.add_circle_outline,
                    color: Colors.white,
                    size: 28.r,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Varlık Ekle',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal.shade900,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Portföyünüze yeni varlık ekleyin',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.teal.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade100,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.teal.shade600,
                    size: 16.r,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

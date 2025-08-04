import 'package:animate_do/animate_do.dart';
import 'package:asset_tracker/core/constants/dimensions/app_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ModernAuthLogo extends StatelessWidget {
  final String title;
  final String subtitle;

  const ModernAuthLogo({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return FadeInDown(
      duration: const Duration(milliseconds: 800),
      child: Column(
        children: [
          // Logo container with glassmorphism effect
          Container(
            width: 100.w,
            height: 100.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.r),
              color: Colors.white.withAlpha(50),
              border: Border.all(
                color: Colors.white.withAlpha(75),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(25),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Center(
              child: Pulse(
                infinite: true,
                duration: const Duration(seconds: 2),
                child: Icon(
                  Icons.diamond,
                  size: 50.r,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          SizedBox(height: AppDimensions.spaceM.h),

          // Title
          Text(
            title,
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),

          SizedBox(height: AppDimensions.spaceS.h),

          // Subtitle
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: Colors.white.withAlpha(225),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

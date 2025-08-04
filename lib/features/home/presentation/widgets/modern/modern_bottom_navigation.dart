import 'package:asset_tracker/core/constants/colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ModernBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabTapped;

  const ModernBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTabTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(35),
            offset: const Offset(0, -10),
            blurRadius: 30.r,
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavButton(
              context,
              icon: Icons.home_rounded,
              label: "Ana Sayfa",
              index: 0,
              isSelected: currentIndex == 0,
            ),
            _buildNavButton(
              context,
              icon: Icons.trending_up_rounded,
              label: "Piyasalar",
              index: 1,
              isSelected: currentIndex == 1,
            ),
            _buildNavButton(
              context,
              icon: Icons.pie_chart_rounded, // UPDATED: Better portfolio icon
              label: "Portföy",
              index: 2,
              isSelected: currentIndex == 2,
            ),
            _buildNavButton(
              context,
              icon: Icons.person_rounded,
              label: "Profil",
              index: 3,
              isSelected: currentIndex == 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required int index,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => onTabTapped(index),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryGreen.withAlpha(40)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color:
                  isSelected ? AppColors.primaryGreen : AppColors.textSecondary,
              size: 24.r,
            ),
            SizedBox(height: 3.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? AppColors.primaryGreen
                    : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

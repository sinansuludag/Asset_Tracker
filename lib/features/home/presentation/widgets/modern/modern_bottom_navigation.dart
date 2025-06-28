import 'package:asset_tracker/core/constants/colors/app_colors.dart';
import 'package:asset_tracker/core/constants/strings/locale/tr_strings.dart';
import 'package:flutter/material.dart';

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
      height: 90,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            offset: const Offset(0, -10),
            blurRadius: 30,
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavButton(
                context,
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: TrStrings.bottomNavigationHome,
                index: 0,
              ),
              _buildNavButton(
                context,
                icon: Icons.trending_up_outlined,
                activeIcon: Icons.trending_up,
                label: "Piyasalar",
                index: 1,
              ),
              _buildNavButton(
                context,
                icon: Icons.account_balance_wallet_outlined,
                activeIcon: Icons.account_balance_wallet,
                label: TrStrings.bottomNavigationCurrency,
                index: 2,
              ),
              _buildNavButton(
                context,
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                label: TrStrings.bottomNavigationProfile,
                index: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavButton(
    BuildContext context, {
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
  }) {
    final isActive = currentIndex == index;

    return GestureDetector(
      onTap: () => onTabTapped(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primaryGreen.withOpacity(0.1) : null,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color:
                  isActive ? AppColors.primaryGreen : AppColors.textSecondary,
              size: 22,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isActive
                        ? AppColors.primaryGreen
                        : AppColors.textSecondary,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                    fontSize: 11,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

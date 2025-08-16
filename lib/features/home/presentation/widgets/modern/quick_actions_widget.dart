import 'package:asset_tracker/core/constants/colors/app_colors.dart';
import 'package:asset_tracker/features/home/presentation/pages/calculator_screen.dart'; // Yeni import
import 'package:asset_tracker/features/home/presentation/widgets/modern/ultra_modern_buying_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Hızlı işlem butonları widget'ı
class QuickActionsWidget extends StatelessWidget {
  const QuickActionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(20.w, 0.h, 20.w, 20.h),
      transform: Matrix4.translationValues(0, -15, 0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Colors.white.withAlpha(230),
            Colors.white,
          ],
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.white.withAlpha(100)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
            offset: const Offset(0, 10),
            blurRadius: 30.r,
          ),
          BoxShadow(
            color: const Color(0xFF1DD1A1).withAlpha(25),
            offset: const Offset(0, -5),
            blurRadius: 20.r,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20.r),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Varlık Ekle Butonu
            _buildHolographicActionItem(
              context,
              icon: Icons.rocket_launch,
              label: "Varlık Ekle",
              gradient: const LinearGradient(
                  colors: [Color(0xFF1DD1A1), Color(0xFF26D0CE)]),
              onTap: () => showUltraModernBuyingDialog(context),
            ),
            // Hesaplayıcı Butonu - Güncellenmiş
            _buildHolographicActionItem(
              context,
              icon: Icons.calculate,
              label: "Hesaplayıcı",
              gradient: const LinearGradient(
                  colors: [Colors.orange, Colors.deepOrange]),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CalculatorScreen(),
                  ),
                );
              },
            ),
            // Alarmlar Butonu
            _buildHolographicActionItem(
              context,
              icon: Icons.notifications_active,
              label: "Alarmlar",
              gradient:
                  const LinearGradient(colors: [Colors.purple, Colors.indigo]),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("🔔 Alarm özelliği yakında..."),
                    backgroundColor: Colors.purple,
                  ),
                );
              },
            ),
            // Grafikler Butonu
            // _buildHolographicActionItem(
            //   context,
            //   icon: Icons.trending_up,
            //   label: "Grafikler",
            //   gradient:
            //       const LinearGradient(colors: [Colors.cyan, Colors.blue]),
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => const ChartsScreen(),
            //       ),
            //     );
            //   },
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildHolographicActionItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 52.w,
              height: 52.h,
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: gradient.colors.first.withAlpha(95),
                    offset: const Offset(0, 8),
                    blurRadius: 20.r,
                  ),
                  BoxShadow(
                    color: gradient.colors.last.withAlpha(95),
                    offset: const Offset(0, 4),
                    blurRadius: 12.r,
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 24.r),
            ),
            SizedBox(height: 8.h),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    fontSize: 11.sp,
                  ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:asset_tracker/core/constants/colors/app_colors.dart';
import 'package:flutter/material.dart';

/// Üst kısım - Kullanıcı karşılama ve portföy özeti
class HeaderSectionWidget extends StatelessWidget {
  final double totalPortfolioValue; // Toplam portföy değeri
  final double totalChange; // Toplam değişim
  final double changePercentage; // Değişim yüzdesi
  final String userName; // Kullanıcı adı

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
        gradient: AppColors.primaryGradient, // Gradyan arka plan
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
          child: Column(
            children: [
              // Header Top
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Üst kısım - Selamlama ve butonlar
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Merhaba,",
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          userName,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ),
                  // Sağ taraf - Aksiyon butonları
                  Row(
                    children: [
                      _buildActionButton(
                        icon: Icons.notifications_outlined,
                        badge: "3",
                        onTap: () {
                          // Notification handler
                        },
                      ),
                      const SizedBox(width: 12),
                      _buildActionButton(
                        icon: Icons.settings_outlined,
                        onTap: () {
                          // Settings handler
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Portföy özeti
              Column(
                children: [
                  // Ana portföy değeri
                  Text(
                    "₺${totalPortfolioValue.toStringAsFixed(2)}",
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 36,
                        ),
                  ),
                  const SizedBox(height: 8),
                  // Portföy açıklaması ve değişim
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Toplam Portföy Değeri",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.white.withOpacity(0.9),
                            ),
                      ),
                      const SizedBox(width: 8),
                      // Değişim badge'i
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: totalChange >= 0
                              ? Colors.green.withOpacity(0.2)
                              : Colors.red.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "${totalChange >= 0 ? '+' : ''}₺${totalChange.toStringAsFixed(2)}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              totalChange >= 0
                                  ? Icons.trending_up
                                  : Icons.trending_down,
                              color: Colors.white,
                              size: 16,
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
    String? badge, // Opsiyonel badge (bildirim sayısı)
    required VoidCallback onTap,
  }) {
    return Stack(
      children: [
        // Ana buton container'ı
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(12),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
          ),
        ),
        // Badge (varsa)
        if (badge != null)
          Positioned(
            right: -2,
            top: -2,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
              child: Text(
                badge,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
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

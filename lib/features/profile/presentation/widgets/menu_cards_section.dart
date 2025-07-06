import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:asset_tracker/core/routing/route_names.dart';
import 'package:asset_tracker/core/riverpod/all_riverpod.dart';

class MenuCardsSection extends StatelessWidget {
  final AnimationController mainController;
  final WidgetRef ref;
  final VoidCallback onLogoutTap;

  const MenuCardsSection({
    super.key,
    required this.mainController,
    required this.ref,
    required this.onLogoutTap,
  });

  @override
  Widget build(BuildContext context) {
    final menuItems = [
      {
        'icon': Icons.person_outline,
        'title': 'Hesap Ayarları',
        'subtitle': 'Profil bilgilerini düzenle',
        'color': const Color(0xFF1DD1A1),
        'onTap': () => Navigator.pushNamed(context, RouteNames.accountInfo),
      },
      {
        'icon': Icons.security,
        'title': 'Güvenlik',
        'subtitle': 'Şifre ve güvenlik ayarları',
        'color': const Color(0xFF0984E3),
        'onTap': () =>
            Navigator.pushNamed(context, RouteNames.securitySettings),
      },
      {
        'icon': Icons.dark_mode_outlined,
        'title': 'Tema Ayarları',
        'subtitle': 'Görünüm tercihlerini ayarla',
        'color': const Color(0xFF6C5CE7),
        'hasSwitch': true,
        'onTap': () {},
      },
      {
        'icon': Icons.notifications_active,
        'title': 'Bildirimler',
        'subtitle': 'Fiyat alarmları ve uyarılar',
        'color': const Color(0xFFFD79A8),
        'badge': '3',
        'onTap': () =>
            Navigator.pushNamed(context, RouteNames.notificationSettings),
      },
      {
        'icon': Icons.language,
        'title': 'Dil Ayarları',
        'subtitle': 'Uygulama dilini değiştir',
        'color': const Color(0xFFE17055),
        'onTap': () {},
      },
      {
        'icon': Icons.help_outline,
        'title': 'Yardım & Destek',
        'subtitle': 'SSS ve iletişim',
        'color': const Color(0xFF00B894),
        'onTap': () => Navigator.pushNamed(context, RouteNames.helpSupport),
      },
      {
        'icon': Icons.star_border,
        'title': 'Uygulamayı Değerlendir',
        'subtitle': 'Store\'da puan ver',
        'color': const Color(0xFFFAB1A0),
        'onTap': () {},
      },
      {
        'icon': Icons.info_outline,
        'title': 'Uygulama Hakkında',
        'subtitle': 'Versiyon ve bilgiler',
        'color': const Color(0xFF74B9FF),
        'onTap': () {},
      },
      {
        'icon': Icons.logout,
        'title': 'Çıkış Yap',
        'subtitle': 'Güvenli çıkış',
        'color': const Color(0xFFE74C3C),
        'isLogout': true,
        'onTap': onLogoutTap,
      },
    ];

    return Column(
      children: menuItems.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;

        return AnimatedBuilder(
          animation: mainController,
          builder: (context, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: mainController,
                curve: Interval(
                  (0.6 + (index * 0.05)).clamp(0.0, 0.9),
                  1.0,
                  curve: Curves.easeOutCubic,
                ),
              )),
              child: _buildMenuCard(context, item),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildMenuCard(BuildContext context, Map<String, dynamic> item) {
    final color = item['color'] as Color;
    final isLogout = item['isLogout'] == true;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Colors.white.withOpacity(0.95),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: item['onTap'] as VoidCallback,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // Icon Container
                Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        color,
                        color.withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Icon(
                    item['icon'] as IconData,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 20),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              item['title'] as String,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    color: const Color(0xFF2C3E50),
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.3,
                                  ),
                            ),
                          ),
                          if (item['badge'] != null) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFE74C3C),
                                    Color(0xFFD63031)
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFE74C3C)
                                        .withOpacity(0.3),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Text(
                                item['badge'] as String,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item['subtitle'] as String,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: const Color(0xFF7F8C8D),
                              height: 1.3,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),

                // Trailing Widget
                if (item['hasSwitch'] == true) ...[
                  Switch(
                    value: ref.watch(themeModeProvider) == ThemeMode.dark,
                    onChanged: (val) =>
                        ref.read(themeModeProvider.notifier).toggleTheme(val),
                    activeColor: color,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ] else ...[
                  Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: color.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: color,
                      size: 16,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

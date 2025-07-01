import 'package:asset_tracker/core/constants/colors/app_colors.dart';
import 'package:asset_tracker/core/constants/border_radius/border_radius.dart';
import 'package:asset_tracker/core/constants/media_query_sizes/media_query_size.dart';
import 'package:asset_tracker/core/constants/paddings/paddings.dart';
import 'package:asset_tracker/core/extensions/build_context_extension.dart';
import 'package:asset_tracker/core/extensions/snack_bar_extension.dart';
import 'package:asset_tracker/core/extensions/assets_path_extension.dart';
import 'package:asset_tracker/core/routing/route_names.dart';
import 'package:asset_tracker/core/services/user_service/state_management/riverpod/all_providers.dart';
import 'package:asset_tracker/core/riverpod/all_riverpod.dart';
import 'package:asset_tracker/features/auth/presentation/state_management/auth_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;

class ModernProfileScreen extends ConsumerStatefulWidget {
  const ModernProfileScreen({super.key});

  @override
  ConsumerState<ModernProfileScreen> createState() =>
      _ModernProfileScreenState();
}

class _ModernProfileScreenState extends ConsumerState<ModernProfileScreen>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _floatingController;
  late AnimationController _parallaxController;

  @override
  void initState() {
    super.initState();
    _mainController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _floatingController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    _parallaxController = AnimationController(
      duration: const Duration(milliseconds: 8000),
      vsync: this,
    );

    _mainController.forward();
    _floatingController.repeat();
    _parallaxController.repeat();
  }

  @override
  void dispose() {
    _mainController.dispose();
    _floatingController.dispose();
    _parallaxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(commonUserProvider);

    if (userState.isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFFF8FFFE),
        body: Center(
          child: _buildLoadingAnimation(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FFFE), // Diğer ekranlarla aynı
      extendBodyBehindAppBar: true,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Animated Header
          SliverToBoxAdapter(
            child: _buildAnimatedHeader(context, userState.user),
          ),

          // Floating Profile Card
          SliverToBoxAdapter(
            child: _buildFloatingProfileCard(context, userState.user),
          ),

          // Quick Stats
          SliverToBoxAdapter(
            child: _buildQuickStats(context),
          ),

          // Modern Menu Cards
          SliverToBoxAdapter(
            child: _buildMenuCards(context, ref),
          ),

          // Bottom Padding
          const SliverToBoxAdapter(
            child: SizedBox(height: 120),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingAnimation() {
    return AnimatedBuilder(
      animation: _floatingController,
      builder: (context, child) {
        return Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [
                Color(0xFF1DD1A1),
                Color(0xFF26D0CE),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1DD1A1).withOpacity(0.4),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Icon(
            Icons.person,
            color: Colors.white,
            size: 40,
          ),
        );
      },
    );
  }

  Widget _buildAnimatedHeader(BuildContext context, dynamic user) {
    return AnimatedBuilder(
      animation: _parallaxController,
      builder: (context, child) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.4,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF1DD1A1), // Sadece ana renkler
                const Color(0xFF26D0CE),
              ],
              transform: GradientRotation(_parallaxController.value * 0.5),
            ),
          ),
          child: Stack(
            children: [
              // Floating Particles
              ...List.generate(10, (index) {
                final delay = (index * 0.05).clamp(0.0, 0.5);
                final animation = Tween<double>(begin: 0, end: 1).animate(
                  CurvedAnimation(
                    parent: _parallaxController,
                    curve: Interval(delay, 1.0, curve: Curves.easeInOut),
                  ),
                );
                return AnimatedBuilder(
                  animation: animation,
                  builder: (context, child) {
                    final size = 4.0 + (index % 3) * 2;
                    final x =
                        50.0 + (index * 25) % MediaQuery.of(context).size.width;
                    final y = 100.0 +
                        math.sin(animation.value * 2 * math.pi + index) * 50;

                    return Positioned(
                      left: x,
                      top: y,
                      child: Container(
                        width: size,
                        height: size,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  },
                );
              }),

              // Content
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Top Bar
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildGlassmorphismButton(
                            icon: Icons.arrow_back_ios_new,
                            onTap: () => Navigator.pop(context),
                          ),
                          Text(
                            "Profile",
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.2,
                                ),
                          ),
                          _buildGlassmorphismButton(
                            icon: Icons.settings,
                            onTap: () => Navigator.pushNamed(
                                context, RouteNames.accountInfo),
                          ),
                        ],
                      ),
                      const Spacer(),

                      // Welcome Text
                      SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.3),
                          end: Offset.zero,
                        ).animate(CurvedAnimation(
                          parent: _mainController,
                          curve:
                              const Interval(0.3, 0.8, curve: Curves.easeOut),
                        )),
                        child: FadeTransition(
                          opacity: _mainController,
                          child: Column(
                            children: [
                              Text(
                                "Hoş geldin,",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      color: Colors.white.withOpacity(0.8),
                                      fontWeight: FontWeight.w300,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                user.username ?? "Zehra",
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineLarge
                                    ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 32,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withOpacity(0.3),
                                      offset: const Offset(0, 2),
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGlassmorphismButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
      ),
    );
  }

  Widget _buildFloatingProfileCard(BuildContext context, dynamic user) {
    return AnimatedBuilder(
      animation: _floatingController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
              0, math.sin(_floatingController.value * 2 * math.pi) * 8 - 60),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  Colors.white.withOpacity(0.95),
                ],
              ),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                ),
                BoxShadow(
                  color: const Color(0xFF6C5CE7).withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                _buildAnimatedAvatar(),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.email ?? "zehra.ozkan@email.com",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: const Color(0xFF2D3436),
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF1DD1A1), Color(0xFF26D0CE)],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Aktif Üye",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
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
      },
    );
  }

  Widget _buildAnimatedAvatar() {
    return AnimatedBuilder(
      animation: _floatingController,
      builder: (context, child) {
        return Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                const Color(0xFF6C5CE7),
                const Color(0xFFA29BFE),
              ],
              transform:
                  GradientRotation(_floatingController.value * 2 * math.pi),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6C5CE7).withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(
            Icons.person,
            color: Colors.white,
            size: 35,
          ),
        );
      },
    );
  }

  Widget _buildQuickStats(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
              child:
                  _buildStatCard("127", "Gün Aktif", const Color(0xFF1DD1A1))),
          const SizedBox(width: 12),
          Expanded(
              child: _buildStatCard("15", "Varlık", const Color(0xFF1DD1A1))),
          const SizedBox(width: 12),
          Expanded(
              child:
                  _buildStatCard("₺139K", "Portföy", const Color(0xFF1DD1A1))),
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label, Color color) {
    return AnimatedBuilder(
      animation: _mainController,
      builder: (context, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.5),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: _mainController,
            curve: const Interval(0.5, 1.0, curve: Curves.elasticOut),
          )),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: color.withOpacity(0.3)),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: color,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white.withOpacity(0.7),
                        fontWeight: FontWeight.w500,
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMenuCards(BuildContext context, WidgetRef ref) {
    final menuItems = [
      {
        'icon': Icons.person_outline,
        'title': 'Hesap Ayarları',
        'subtitle': 'Profil bilgilerini düzenle',
        'color': const Color(0xFF1DD1A1), // Sadece ana renk
        'onTap': () => Navigator.pushNamed(context, RouteNames.accountInfo),
      },
      {
        'icon': Icons.security,
        'title': 'Güvenlik',
        'subtitle': 'Şifre ve güvenlik ayarları',
        'color': const Color(0xFF1DD1A1), // Sadece ana renk
        'onTap': () => Navigator.pushNamed(context, RouteNames.changePassword),
      },
      {
        'icon': Icons.dark_mode_outlined,
        'title': 'Tema Ayarları',
        'subtitle': 'Görünüm tercihlerini ayarla',
        'color': const Color(0xFF1DD1A1), // Sadece ana renk
        'hasSwitch': true,
        'onTap': () {},
      },
      {
        'icon': Icons.notifications_active,
        'title': 'Bildirimler',
        'subtitle': 'Fiyat alarmları ve uyarılar',
        'color': const Color(0xFF1DD1A1), // Sadece ana renk
        'badge': '3',
        'onTap': () =>
            Navigator.pushNamed(context, RouteNames.notificationSettings),
      },
      {
        'icon': Icons.help_outline,
        'title': 'Yardım & Destek',
        'subtitle': 'SSS ve iletişim',
        'color': const Color(0xFF1DD1A1), // Sadece ana renk
        'onTap': () => Navigator.pushNamed(context, RouteNames.helpSupport),
      },
      {
        'icon': Icons.star_border,
        'title': 'Uygulamayı Değerlendir',
        'subtitle': 'Store\'da puan ver',
        'color': const Color(0xFF1DD1A1), // Sadece ana renk
        'onTap': () => Navigator.pushNamed(context, RouteNames.rateApp),
      },
      {
        'icon': Icons.logout,
        'title': 'Çıkış Yap',
        'subtitle': 'Güvenli çıkış',
        'color': const Color(0xFFE74C3C), // Sadece logout kırmızı
        'isLogout': true,
        'onTap': () => _showModernLogoutDialog(context),
      },
    ];

    return Column(
      children: menuItems.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;

        return AnimatedBuilder(
          animation: _mainController,
          builder: (context, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: _mainController,
                curve: Interval(
                  (0.6 + (index * 0.05)).clamp(0.0, 0.9),
                  1.0,
                  curve: Curves.easeOutCubic,
                ),
              )),
              child: _buildMenuCard(context, item, ref),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildMenuCard(
      BuildContext context, Map<String, dynamic> item, WidgetRef ref) {
    final color = item['color'] as Color;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
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
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    item['icon'] as IconData,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['title'] as String,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: const Color(0xFF2C3E50), // Koyu metin
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['subtitle'] as String,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: const Color(0xFF7F8C8D), // Gri metin
                            ),
                      ),
                    ],
                  ),
                ),
                if (item['badge'] != null) ...[
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD63031),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      item['badge'] as String,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                if (item['hasSwitch'] == true) ...[
                  Switch(
                    value: ref.watch(themeModeProvider) == ThemeMode.dark,
                    onChanged: (val) =>
                        ref.read(themeModeProvider.notifier).toggleTheme(val),
                    activeColor: color,
                  ),
                ] else
                  Icon(
                    Icons.arrow_forward_ios,
                    color: const Color(0xFF7F8C8D), // Gri ok
                    size: 16,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showModernLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF2D3436),
                Color(0xFF636E72),
              ],
            ),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 30,
                offset: const Offset(0, 15),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFFD63031),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFD63031).withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(Icons.logout, color: Colors.white, size: 30),
              ),
              const SizedBox(height: 20),
              Text(
                "Çıkış Yap",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 12),
              Text(
                "Hesabından çıkış yapmak istediğinden emin misin?",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withOpacity(0.8),
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.1),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        "İptal",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        await ref.read(authProvider.notifier).signOut();
                        context.showSnackBar(
                          "Başarıyla çıkış yapıldı",
                          Icons.check_circle_outline,
                          AppColors.success,
                        );
                        Navigator.pushNamed(context, RouteNames.login);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD63031),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        "Çıkış Yap",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
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

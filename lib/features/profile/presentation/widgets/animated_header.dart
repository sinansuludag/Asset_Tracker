import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimatedHeader extends StatelessWidget {
  final AnimationController parallaxController;
  final AnimationController mainController;
  final dynamic user;
  final VoidCallback onSettingsTap;

  const AnimatedHeader({
    super.key,
    required this.parallaxController,
    required this.mainController,
    required this.user,
    required this.onSettingsTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: parallaxController,
      builder: (context, child) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.4, // ORİJİNAL AYNI
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF1DD1A1),
                const Color(0xFF26D0CE),
              ],
              transform: GradientRotation(parallaxController.value * 0.5),
            ),
          ),
          child: Stack(
            children: [
              // Enhanced Floating Particles - ORİJİNAL AYNI
              ..._buildFloatingParticles(context),

              // Glowing Orbs - ORİJİNAL AYNI
              ..._buildGlowingOrbs(context),

              // Content - Sadece overflow düzeltildi
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20), // ORİJİNAL AYNI
                  child: Column(
                    mainAxisSize: MainAxisSize
                        .min, // SADECE BU EKLENDİ - overflow önlemek için
                    children: [
                      _buildTopBar(context),
                      Expanded(
                        // ORİJİNAL AYNI - Spacer yerine değil, gerçek Expanded
                        child: _buildWelcomeSection(context),
                      ),
                      const SizedBox(height: 40), // ORİJİNAL AYNI
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

  List<Widget> _buildFloatingParticles(BuildContext context) {
    return List.generate(15, (index) {
      // ORİJİNAL AYNI
      final delay = (index * 0.05).clamp(0.0, 0.5);
      final animation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: parallaxController,
          curve: Interval(delay, 1.0, curve: Curves.easeInOut),
        ),
      );

      return AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          final size = 3.0 + (index % 4) * 2; // ORİJİNAL AYNI
          final x = 30.0 + (index * 25) % MediaQuery.of(context).size.width;
          final y = 80.0 + math.sin(animation.value * 2 * math.pi + index) * 60;
          final opacity =
              (0.2 + math.sin(animation.value * math.pi + index) * 0.3)
                  .clamp(0.1, 0.5);

          return Positioned(
            left: x,
            top: y,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(opacity),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.3),
                    blurRadius: size * 2,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  List<Widget> _buildGlowingOrbs(BuildContext context) {
    return List.generate(3, (index) {
      // ORİJİNAL AYNI
      final animation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: parallaxController,
          curve: Curves.easeInOut,
        ),
      );

      return AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          final size = 100.0 + index * 50; // ORİJİNAL AYNI
          final x = (index * 150.0) % MediaQuery.of(context).size.width;
          final y = 50.0 + math.sin(animation.value * math.pi + index * 2) * 30;

          return Positioned(
            left: x,
            top: y,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.white.withOpacity(0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildTopBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildGlassmorphismButton(
          icon: Icons.arrow_back_ios_new,
          onTap: () => Navigator.pop(context),
        ),
        // Modern Profile Title with Glow Effect - ORİJİNAL AYNI
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.2),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Text(
            "Profil",
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              shadows: [
                Shadow(
                  color: Colors.white.withOpacity(0.5),
                  blurRadius: 10,
                ),
              ],
            ),
          ),
        ),
        _buildGlassmorphismButton(
          icon: Icons.settings,
          onTap: onSettingsTap,
        ),
      ],
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.3),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: mainController,
        curve: const Interval(0.3, 0.8, curve: Curves.easeOut),
      )),
      child: FadeTransition(
        opacity: mainController,
        child: Column(
          mainAxisSize:
              MainAxisSize.min, // SADECE BU EKLENDİ - overflow önlemek için
          children: [
            // Enhanced Welcome Text - ORİJİNAL AYNI
            Container(
              padding: const EdgeInsets.all(30), // ORİJİNAL AYNI
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 30,
                    offset: const Offset(0, 15),
                  ),
                ],
              ),
              child: Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min, // SADECE BU EKLENDİ
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min, // SADECE BU EKLENDİ
                      children: [
                        Icon(
                          Icons.waving_hand,
                          color: Colors.amber,
                          size: 28, // ORİJİNAL AYNI
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          // SADECE BU EKLENDİ - overflow önlemek için
                          child: Text(
                            "Hoş geldin,",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  color: Colors.white.withOpacity(0.9),
                                  fontWeight: FontWeight.w400,
                                ),
                            overflow:
                                TextOverflow.ellipsis, // SADECE BU EKLENDİ
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12), // ORİJİNAL AYNI
                    Text(
                      user?.username ?? "Zehra",
                      style:
                          Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 36,
                        letterSpacing: 1.5,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.3),
                            offset: const Offset(0, 3),
                            blurRadius: 12,
                          ),
                          Shadow(
                            color: Colors.white.withOpacity(0.3),
                            offset: const Offset(0, -1),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      overflow: TextOverflow.ellipsis, // SADECE BU EKLENDİ
                      maxLines: 1, // SADECE BU EKLENDİ
                    ),
                    // const SizedBox(height: 4), // ORİJİNAL AYNI
                    // Animated Status Indicator - ORİJİNAL AYNI
                    AnimatedBuilder(
                      animation: parallaxController,
                      builder: (context, child) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: Colors.green.withOpacity(0.4)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.green.withOpacity(0.5 +
                                          math.sin(parallaxController.value *
                                                  4 *
                                                  math.pi) *
                                              0.3),
                                      blurRadius: 8,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Çevrimiçi",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGlassmorphismButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      width: 48, // ORİJİNAL AYNI
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Icon(icon, color: Colors.white, size: 24), // ORİJİNAL AYNI
        ),
      ),
    );
  }
}

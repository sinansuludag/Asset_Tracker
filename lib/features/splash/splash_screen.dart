import 'package:asset_tracker/core/constants/colors/app_colors.dart';
import 'package:asset_tracker/features/auth/presentation/state_management/auth_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/routing/route_names.dart';
import '../auth/presentation/state_management/auth_state_manager.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _particleController;
  late AnimationController _progressController;

  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoRotateAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();

    // Main Animation Controller
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    // Particle Animation Controller (for background elements)
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);

    // Progress Controller
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    // Logo Scale Animation
    _logoScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.5, curve: Curves.elasticOut),
      ),
    );

    // Logo Rotate Animation
    _logoRotateAnimation = Tween<double>(begin: -0.5, end: 0.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    // Fade Animation
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.3, 0.8, curve: Curves.easeIn),
      ),
    );

    // Slide Animation
    _slideAnimation = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.3, 0.8, curve: Curves.easeOut),
      ),
    );

    // Progress Animation
    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _progressController,
        curve: Curves.easeInOut,
      ),
    );

    // Start animations
    _startAnimations();

    // Navigate after delay
    Future.delayed(const Duration(milliseconds: 3000), () {
      ref.read(authProvider.notifier).checkLoginStatus().then((_) {
        final authState = ref.read(authProvider);
        if (authState == AuthState.authenticated) {
          Navigator.pushReplacementNamed(context, RouteNames.home);
        } else {
          Navigator.pushReplacementNamed(context, RouteNames.login);
        }
      });
    });
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _mainController.forward();
    await Future.delayed(const Duration(milliseconds: 400));
    _progressController.forward();
  }

  @override
  void dispose() {
    _mainController.dispose();
    _particleController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF8FAFB), // Ana sayfa arka plan rengi
              Color(0xFFFFFFFF), // Beyaz
            ],
          ),
        ),
        child: Stack(
          children: [
            // Background Animated Patterns
            ...List.generate(
              5,
              (index) => _buildFloatingElement(index),
            ),

            // Main Content
            SafeArea(
              child: Column(
                children: [
                  const Spacer(flex: 3),

                  // Logo Container
                  AnimatedBuilder(
                    animation: _mainController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _logoScaleAnimation.value,
                        child: Transform.rotate(
                          angle: _logoRotateAnimation.value,
                          child: Container(
                            width: 120.w,
                            height: 120.h,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  AppColors.primaryGreen,
                                  AppColors.primaryGreen.withBlue(30),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(28.r),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primaryGreen.withAlpha(100),
                                  blurRadius: 30,
                                  offset: const Offset(0, 15),
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Icon(
                                Icons.account_balance_wallet_rounded,
                                size: 60.r,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 40.h),

                  // App Name
                  AnimatedBuilder(
                    animation: _mainController,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, _slideAnimation.value),
                        child: Opacity(
                          opacity: _fadeAnimation.value,
                          child: Column(
                            children: [
                              ShaderMask(
                                shaderCallback: (bounds) => LinearGradient(
                                  colors: [
                                    AppColors.primaryGreen,
                                    AppColors.primaryGreen.withBlue(40),
                                  ],
                                ).createShader(bounds),
                                child: Text(
                                  'Asset Tracker',
                                  style: TextStyle(
                                    fontSize: 38.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: -0.5,
                                    height: 1.2,
                                  ),
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                'Varlıklarınızı Akıllıca Yönetin',
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF1A1A2E).withAlpha(150),
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  const Spacer(flex: 2),

                  // Features
                  AnimatedBuilder(
                    animation: _mainController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _fadeAnimation.value,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildFeatureItem(
                              Icons.trending_up,
                              'Takip',
                            ),
                            SizedBox(width: 40.w),
                            _buildFeatureItem(
                              Icons.analytics_outlined,
                              'Analiz',
                            ),
                            SizedBox(width: 40.w),
                            _buildFeatureItem(
                              Icons.security_rounded,
                              'Güvenli',
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  const Spacer(flex: 2),

                  // Loading Progress
                  AnimatedBuilder(
                    animation: _progressController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _fadeAnimation.value,
                        child: Column(
                          children: [
                            Container(
                              width: 180.w,
                              height: 5.h,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(2.5.r),
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  width: 180.w * _progressAnimation.value,
                                  height: 5.h,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        AppColors.primaryGreen,
                                        AppColors.primaryGreen.withBlue(30),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(2.5.r),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.primaryGreen
                                            .withAlpha(100),
                                        blurRadius: 8,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              'Yükleniyor...',
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: const Color(0xFF1A1A2E).withAlpha(120),
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 40.h),

                  // Bottom Info
                  AnimatedBuilder(
                    animation: _mainController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _fadeAnimation.value,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.copyright_rounded,
                                  size: 13.r,
                                  color: const Color(0xFF1A1A2E).withAlpha(100),
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  '2025 Asset Tracker',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color:
                                        const Color(0xFF1A1A2E).withAlpha(100),
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 6.h),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryGreen.withAlpha(25),
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: AppColors.primaryGreen.withAlpha(50),
                                ),
                              ),
                              child: Text(
                                'Version 1.0.0',
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: AppColors.primaryGreen,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 30.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 50.w,
          height: 50.h,
          decoration: BoxDecoration(
            color: AppColors.primaryGreen.withAlpha(25),
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: AppColors.primaryGreen.withAlpha(50),
            ),
          ),
          child: Icon(
            icon,
            size: 24.r,
            color: AppColors.primaryGreen,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: const Color(0xFF1A1A2E).withAlpha(150),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildFloatingElement(int index) {
    final positions = [
      {'left': -30.0, 'top': 100.0},
      {'right': -50.0, 'top': 200.0},
      {'left': 40.0, 'bottom': 150.0},
      {'right': 30.0, 'bottom': 250.0},
      {'left': -20.0, 'top': 350.0},
    ];

    final sizes = [80.0, 120.0, 60.0, 100.0, 70.0];
    final pos = positions[index];
    final size = sizes[index];

    return AnimatedBuilder(
      animation: _particleController,
      builder: (context, child) {
        final offset = _particleController.value * 20;
        return Positioned(
          left: pos['left'] != null ? pos['left']! + offset : null,
          right: pos['right'] != null ? pos['right']! - offset : null,
          top: pos['top'] != null ? pos['top']! + offset : null,
          bottom: pos['bottom'] != null ? pos['bottom']! - offset : null,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.primaryGreen.withAlpha(25),
                  AppColors.primaryGreen.withAlpha(0),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

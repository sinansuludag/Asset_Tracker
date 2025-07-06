import 'package:asset_tracker/core/constants/colors/app_colors.dart';
import 'package:asset_tracker/core/constants/border_radius/border_radius.dart';
import 'package:asset_tracker/core/constants/media_query_sizes/media_query_size.dart';
import 'package:asset_tracker/core/constants/paddings/paddings.dart';
import 'package:asset_tracker/core/extensions/build_context_extension.dart';
import 'package:asset_tracker/core/extensions/snack_bar_extension.dart';
import 'package:asset_tracker/core/routing/route_names.dart';
import 'package:asset_tracker/core/services/user_service/state_management/riverpod/all_providers.dart';
import 'package:asset_tracker/core/riverpod/all_riverpod.dart';
import 'package:asset_tracker/features/auth/presentation/state_management/auth_state_provider.dart';
import 'package:asset_tracker/features/profile/presentation/widgets/animated_header.dart';
import 'package:asset_tracker/features/profile/presentation/widgets/floating_profile_card.dart';
import 'package:asset_tracker/features/profile/presentation/widgets/logout_dialog.dart';
import 'package:asset_tracker/features/profile/presentation/widgets/menu_cards_section.dart';
import 'package:asset_tracker/features/profile/presentation/widgets/quick_stats_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    _initializeAnimations();
  }

  void _initializeAnimations() {
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
      return _buildLoadingScreen();
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FFFE),
      extendBodyBehindAppBar: true, // ORİJİNAL AYNI
      body: CustomScrollView(
        // ORİJİNAL SCROLL YAPISI KORUNDU
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Animated Header - Sadece overflow düzeltildi
          SliverToBoxAdapter(
            child: AnimatedHeader(
              parallaxController: _parallaxController,
              mainController: _mainController,
              user: userState.user,
              onSettingsTap: () =>
                  Navigator.pushNamed(context, RouteNames.securitySettings),
            ),
          ),

          // Floating Profile Card - Sadece overflow düzeltildi
          SliverToBoxAdapter(
            child: FloatingProfileCard(
              floatingController: _floatingController,
              user: userState.user,
            ),
          ),

          // Quick Stats - Sadece overflow düzeltildi
          SliverToBoxAdapter(
            child: QuickStatsSection(
              mainController: _mainController,
            ),
          ),

          // Menu Cards - ORİJİNAL AYNI
          SliverToBoxAdapter(
            child: MenuCardsSection(
              mainController: _mainController,
              ref: ref,
              onLogoutTap: () => _showLogoutDialog(context),
            ),
          ),

          // Bottom Padding - ORİJİNAL AYNI
          const SliverToBoxAdapter(
            child: SizedBox(height: 120),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FFFE),
      body: Center(
        child: AnimatedBuilder(
          animation: _floatingController,
          builder: (context, child) {
            return Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFF1DD1A1), Color(0xFF26D0CE)],
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
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => LogoutDialog(
        onConfirm: () async {
          Navigator.pop(context);
          await ref.read(authProvider.notifier).signOut();
          context.showSnackBar(
            "Başarıyla çıkış yapıldı",
            Icons.check_circle_outline,
            AppColors.success,
          );
          Navigator.pushNamed(context, RouteNames.login);
        },
      ),
    );
  }
}

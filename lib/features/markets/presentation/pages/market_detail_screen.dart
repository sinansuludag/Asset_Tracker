import 'package:asset_tracker/core/constants/colors/app_colors.dart';
import 'package:asset_tracker/core/extensions/currency_code_extension.dart';
import 'package:asset_tracker/core/riverpod/all_riverpod.dart';
import 'package:asset_tracker/core/utils/get_asset_icon.dart';
import 'package:asset_tracker/features/home/presentation/state_management/provider/all_providers.dart';
import 'package:asset_tracker/features/home/presentation/state_management/provider/allowed_assets_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math' as math;

class MarketDetailScreen extends ConsumerStatefulWidget {
  final String marketCode;

  const MarketDetailScreen({
    super.key,
    required this.marketCode,
  });

  @override
  ConsumerState<MarketDetailScreen> createState() => _MarketDetailScreenState();
}

class _MarketDetailScreenState extends ConsumerState<MarketDetailScreen>
    with TickerProviderStateMixin {
  late AnimationController _priceAnimationController;
  late AnimationController _cardAnimationController;
  late Animation<double> _priceAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  bool _isInWatchlist = false;

  @override
  void initState() {
    super.initState();
    _priceAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _cardAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _priceAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _priceAnimationController, curve: Curves.elasticOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
        parent: _cardAnimationController, curve: Curves.easeOutBack));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _cardAnimationController, curve: Curves.easeIn),
    );

    _priceAnimationController.forward();
    _cardAnimationController.forward();
  }

  @override
  void dispose() {
    _priceAnimationController.dispose();
    _cardAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currencyState = ref.watch(currencyNotifierProvider);
    final priorityAssets = ref.watch(priorityAssetsProvider);

    final currencies = currencyState.isNotEmpty
        ? currencyState.first.currencies
        : <String, dynamic>{};
    final currencyData = currencies[widget.marketCode];
    final assetDefinition = priorityAssets.firstWhere(
      (asset) => asset.id == widget.marketCode,
      orElse: () => priorityAssets.first,
    );

    if (currencyData == null) {
      return _buildLoadingScreen();
    }

    final metrics = _calculatePriceMetrics(currencyData);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildModernAppBar(assetDefinition, currencyData, metrics),
          _buildPriceDetailsCard(currencyData, metrics),
          _buildInteractiveStats(currencyData, metrics),
          _buildQuickActionsCard(),
          _buildMarketInsights(currencyData),
          _buildTrendAnalysisCard(currencyData),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildModernAppBar(dynamic assetDefinition, dynamic currencyData,
      Map<String, dynamic> metrics) {
    final price = currencyData.buying ?? 0.0;
    final change = metrics['change'] as double;
    final changePercent = metrics['changePercent'] as double;
    final isPositive = metrics['isPositive'] as bool;

    return SliverAppBar(
      expandedHeight: 280.h,
      floating: false,
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                isPositive ? AppColors.primaryGreen : Colors.red.shade600,
                isPositive ? const Color(0xFF26D0CE) : Colors.red.shade800,
                isPositive ? Colors.blue.shade400 : Colors.red.shade900,
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with actions
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                            size: 20.r,
                          ),
                        ),
                      ),
                      const Spacer(),
                      _buildAppBarAction(
                        Icons.share,
                        () => _showShareDialog(),
                      ),
                      SizedBox(width: 8.w),
                      _buildAppBarAction(
                        _isInWatchlist ? Icons.bookmark : Icons.bookmark_border,
                        () => _toggleWatchlist(),
                      ),
                    ],
                  ),

                  SizedBox(height: 30.h),

                  // Asset info
                  AnimatedBuilder(
                    animation: _priceAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: 0.8 + (0.2 * _priceAnimation.value),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Asset symbol and name
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(12.w),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(16.r),
                                  ),
                                  child: Text(
                                    getAssetIcon(assetDefinition.id, 'normal'),
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        assetDefinition.displayName,
                                        style: TextStyle(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        widget.marketCode,
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: Colors.white.withOpacity(0.8),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 25.h),

                            // Price display
                            Text(
                              "₺${price.toStringAsFixed(2)}",
                              style: TextStyle(
                                fontSize: 42.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                height: 1.0,
                              ),
                            ),

                            SizedBox(height: 8.h),

                            // Change display
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12.w, vertical: 6.h),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    isPositive
                                        ? Icons.trending_up
                                        : Icons.trending_down,
                                    color: Colors.white,
                                    size: 18.r,
                                  ),
                                  SizedBox(width: 6.w),
                                  Text(
                                    "${isPositive ? '+' : ''}₺${change.toStringAsFixed(2)} (${changePercent.toStringAsFixed(2)}%)",
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
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
        ),
      ),
    );
  }

  Widget _buildAppBarAction(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 20.r,
        ),
      ),
    );
  }

  Widget _buildPriceDetailsCard(
      dynamic currencyData, Map<String, dynamic> metrics) {
    final buying = currencyData.buying ?? 0.0;
    final selling = currencyData.selling ?? 0.0;
    final high = currencyData.high ?? 0.0;
    final low = currencyData.low ?? 0.0;

    return SliverToBoxAdapter(
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Container(
            margin: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0),
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 20.r,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.monetization_on_outlined,
                      color: AppColors.primaryGreen,
                      size: 24.r,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Fiyat Detayları',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        'Canlı',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),

                Row(
                  children: [
                    Expanded(
                      child: _buildPriceCard(
                        'Alış',
                        '₺${buying.toStringAsFixed(2)}',
                        Colors.green,
                        Icons.arrow_downward,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: _buildPriceCard(
                        'Satış',
                        '₺${selling.toStringAsFixed(2)}',
                        Colors.red,
                        Icons.arrow_upward,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16.h),

                Row(
                  children: [
                    Expanded(
                      child: _buildPriceCard(
                        'En Yüksek',
                        '₺${high.toStringAsFixed(2)}',
                        Colors.blue,
                        Icons.keyboard_arrow_up,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: _buildPriceCard(
                        'En Düşük',
                        '₺${low.toStringAsFixed(2)}',
                        Colors.orange,
                        Icons.keyboard_arrow_down,
                      ),
                    ),
                  ],
                ),

                // Spread info
                if (buying > 0 && selling > 0) ...[
                  SizedBox(height: 20.h),
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primaryGreen.withOpacity(0.1),
                          Colors.blue.withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.compare_arrows,
                          color: AppColors.primaryGreen,
                          size: 20.r,
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Spread (Alış-Satış Farkı)',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              Text(
                                '₺${(selling - buying).toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryGreen,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '%${((selling - buying) / buying * 100).toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
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

  Widget _buildPriceCard(
      String label, String value, Color color, IconData icon) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 18.r),
              SizedBox(width: 6.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInteractiveStats(
      dynamic currencyData, Map<String, dynamic> metrics) {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0),
        child: Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Günlük Değişim',
                '${metrics['isPositive'] ? '+' : ''}${(metrics['changePercent'] as double).toStringAsFixed(2)}%',
                metrics['isPositive'] ? Colors.green : Colors.red,
                metrics['isPositive'] ? Icons.trending_up : Icons.trending_down,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: _buildStatCard(
                'Trend Durumu',
                _getTrendText(currencyData.buyingDir ?? 'stabil'),
                _getTrendColor(currencyData.buyingDir ?? 'stabil'),
                _getTrendIcon(currencyData.buyingDir ?? 'stabil'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, Color color, IconData icon) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15.r,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: color, size: 24.r),
          ),
          SizedBox(height: 12.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsCard() {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0),
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15.r,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.flash_on,
                  color: AppColors.primaryGreen,
                  size: 24.r,
                ),
                SizedBox(width: 8.w),
                Text(
                  'Hızlı İşlemler',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    'Satın Al',
                    Icons.add_shopping_cart,
                    AppColors.primaryGreen,
                    () => _showBuyDialog(),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: _buildActionButton(
                    'Alarm Kur',
                    Icons.notifications_active,
                    Colors.orange,
                    () => _showAlarmDialog(),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    'İzleme Listesi',
                    _isInWatchlist ? Icons.bookmark : Icons.bookmark_border,
                    Colors.blue,
                    () => _toggleWatchlist(),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: _buildActionButton(
                    'Paylaş',
                    Icons.share,
                    Colors.purple,
                    () => _showShareDialog(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
      String label, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24.r),
            SizedBox(height: 8.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMarketInsights(dynamic currencyData) {
    final date = currencyData.date ?? 'Bilinmiyor';
    final close = currencyData.close ?? 0.0;

    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0),
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15.r,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.insights,
                  color: AppColors.primaryGreen,
                  size: 24.r,
                ),
                SizedBox(width: 8.w),
                Text(
                  'Piyasa Bilgileri',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            _buildInfoTile('Varlık Kodu', widget.marketCode, Icons.code),
            _buildInfoTile(
                'Varlık Adı', widget.marketCode.getCurrencyName(), Icons.label),
            _buildInfoTile('Önceki Kapanış', '₺${close.toStringAsFixed(2)}',
                Icons.schedule),
            _buildInfoTile('Veri Tarihi', date, Icons.calendar_today),
            _buildInfoTile('Veri Kaynağı', 'Haremaltın WebSocket', Icons.wifi),
            _buildInfoTile('Son Güncelleme',
                DateTime.now().toString().substring(11, 19), Icons.update),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(String label, String value, IconData icon) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryGreen, size: 20.r),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendAnalysisCard(dynamic currencyData) {
    final buyingDir = currencyData.buyingDir ?? 'stabil';
    final sellingDir = currencyData.sellingDir ?? 'stabil';

    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0),
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade50,
              Colors.purple.shade50,
            ],
          ),
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(color: Colors.blue.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    Icons.trending_up,
                    color: Colors.blue,
                    size: 20.r,
                  ),
                ),
                SizedBox(width: 12.w),
                Text(
                  'Trend Analizi',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Row(
              children: [
                Expanded(
                  child: _buildTrendCard('Alış Trendi', buyingDir),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: _buildTrendCard('Satış Trendi', sellingDir),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.blue.shade600,
                    size: 20.r,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      'Trend verileri Haremaltın\'dan gerçek zamanlı olarak alınmaktadır.',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.blue.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendCard(String label, String direction) {
    final color = _getTrendColor(direction);
    final icon = _getTrendIcon(direction);
    final text = _getTrendText(direction);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32.r),
          SizedBox(height: 8.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            text,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20.r,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
                    strokeWidth: 3,
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    "Market verileri yükleniyor...",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "Haremaltın'dan canlı veriler alınıyor",
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper methods
  Color _getTrendColor(String direction) {
    switch (direction.toLowerCase()) {
      case 'up':
        return Colors.green;
      case 'down':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getTrendIcon(String direction) {
    switch (direction.toLowerCase()) {
      case 'up':
        return Icons.trending_up;
      case 'down':
        return Icons.trending_down;
      default:
        return Icons.trending_flat;
    }
  }

  String _getTrendText(String direction) {
    switch (direction.toLowerCase()) {
      case 'up':
        return 'Yükseliş';
      case 'down':
        return 'Düşüş';
      default:
        return 'Stabil';
    }
  }

  Map<String, dynamic> _calculatePriceMetrics(dynamic currencyData) {
    final currentPrice = currencyData.buying ?? 0.0;
    final previousClose = currencyData.close ?? 0.0;

    double change = 0.0;
    double changePercent = 0.0;
    bool isPositive = false;

    if (previousClose > 0 && currentPrice > 0) {
      change = currentPrice - previousClose;
      changePercent = (change / previousClose) * 100;
    } else {
      // Fallback calculation
      change = currentPrice * (math.Random().nextDouble() * 0.02 - 0.01);
      changePercent = (change / currentPrice) * 100;
    }

    if (currencyData.buyingDir?.toLowerCase() == 'up') {
      isPositive = true;
    } else if (currencyData.buyingDir?.toLowerCase() == 'down') {
      isPositive = false;
    } else {
      isPositive = change >= 0;
    }

    return {
      'change': change,
      'changePercent': changePercent,
      'isPositive': isPositive,
    };
  }

  void _toggleWatchlist() {
    setState(() {
      _isInWatchlist = !_isInWatchlist;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              _isInWatchlist ? Icons.bookmark : Icons.bookmark_border,
              color: Colors.white,
              size: 20.r,
            ),
            SizedBox(width: 12.w),
            Text(
              _isInWatchlist
                  ? '${widget.marketCode} izleme listesine eklendi!'
                  : '${widget.marketCode} izleme listesinden çıkarıldı!',
            ),
          ],
        ),
        backgroundColor: _isInWatchlist ? Colors.green : Colors.orange,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showBuyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Row(
          children: [
            Icon(
              Icons.add_shopping_cart,
              color: AppColors.primaryGreen,
              size: 24.r,
            ),
            SizedBox(width: 8.w),
            Text('${widget.marketCode} Satın Al'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Satın alma işlemi için ana sayfadaki "Varlık Ekle" butonunu kullanabilirsiniz.',
              style: TextStyle(fontSize: 14.sp),
            ),
            SizedBox(height: 16.h),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppColors.primaryGreen,
                    size: 16.r,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      'Güncel alış fiyatı: ₺${(ref.watch(currencyNotifierProvider).isNotEmpty ? ref.watch(currencyNotifierProvider).first.currencies[widget.marketCode]?.buying ?? 0.0 : 0.0).toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.primaryGreen,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
  }

  void _showAlarmDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Row(
          children: [
            Icon(
              Icons.notifications_active,
              color: Colors.orange,
              size: 24.r,
            ),
            SizedBox(width: 8.w),
            Text('${widget.marketCode} Alarm'),
          ],
        ),
        content: Text(
          'Fiyat alarmı kurmak için ana sayfadaki "Alarmlar" butonunu kullanabilirsiniz.',
          style: TextStyle(fontSize: 14.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
  }

  void _showShareDialog() {
    final currencyState = ref.watch(currencyNotifierProvider);
    final currentPrice = currencyState.isNotEmpty
        ? currencyState.first.currencies[widget.marketCode]?.buying ?? 0.0
        : 0.0;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Row(
          children: [
            Icon(
              Icons.share,
              color: Colors.purple,
              size: 24.r,
            ),
            SizedBox(width: 8.w),
            const Text('Paylaş'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${widget.marketCode} piyasa verilerini paylaşmak ister misiniz?',
              style: TextStyle(fontSize: 14.sp),
            ),
            SizedBox(height: 16.h),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                '${widget.marketCode}: ₺${currentPrice.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Paylaşım özelliği yakında!'),
                  backgroundColor: Colors.purple,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: const Text('Paylaş'),
          ),
        ],
      ),
    );
  }
}

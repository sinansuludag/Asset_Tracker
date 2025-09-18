import 'package:asset_tracker/core/constants/colors/app_colors.dart';
import 'package:asset_tracker/core/utils/get_asset_icon.dart';
import 'package:asset_tracker/core/utils/get_quantity_unit.dart';
import 'package:asset_tracker/features/home/data/models/asset_transaction_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class AssetDetailScreen extends ConsumerStatefulWidget {
  final String assetType;
  final String assetSubType;
  final String displayName;

  const AssetDetailScreen({
    super.key,
    required this.assetType,
    required this.assetSubType,
    required this.displayName,
  });

  @override
  ConsumerState<AssetDetailScreen> createState() => _AssetDetailScreenState();
}

class _AssetDetailScreenState extends ConsumerState<AssetDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeInOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic),
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock_outline, size: 64.r, color: Colors.grey),
              SizedBox(height: 16.h),
              Text(
                'Kullanıcı girişi gerekli',
                style: TextStyle(fontSize: 16.sp, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('asset_transactions')
            .where('userId', isEqualTo: userId)
            .where('assetType', isEqualTo: widget.assetType)
            .where('assetSubType', isEqualTo: widget.assetSubType)
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text(
                  'Bir hata oluştu: ${snapshot.error}',
                  style: TextStyle(fontSize: 16.sp, color: Colors.red),
                ),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingState();
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return _buildEmptyState();
          }

          final transactions = snapshot.data!.docs
              .map((doc) {
                try {
                  return AssetTransactionModel.fromJson({
                    ...doc.data() as Map<String, dynamic>,
                    'id': doc.id,
                  });
                } catch (e) {
                  debugPrint('Transaction parse error: $e');
                  return null;
                }
              })
              .whereType<AssetTransactionModel>()
              .toList();

          return _buildContent(transactions);
        },
      ),
    );
  }

  Widget _buildContent(List<AssetTransactionModel> transactions) {
    final totalQuantity = transactions.fold(0.0, (sum, t) => sum + t.quantity);
    final totalInvestment =
        transactions.fold(0.0, (sum, t) => sum + t.totalInvestment);
    final totalGramWeight =
        transactions.fold(0.0, (sum, t) => sum + (t.gramWeight ?? 0));

    double averagePrice = 0.0;
    if (widget.assetSubType == 'bracelet' && totalGramWeight > 0) {
      averagePrice = totalInvestment / totalGramWeight;
    } else if (totalQuantity > 0) {
      averagePrice = totalInvestment / totalQuantity;
    }

    return CustomScrollView(
      slivers: [
        // Modern Header
        SliverToBoxAdapter(
          child: _buildModernHeader(transactions.length),
        ),

        // Animated Summary Cards
        SliverToBoxAdapter(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: _buildSummaryCards(
                totalQuantity: totalQuantity,
                totalInvestment: totalInvestment,
                totalGramWeight: totalGramWeight,
                averagePrice: averagePrice,
              ),
            ),
          ),
        ),

        // Section Header
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 12.h),
            child: Row(
              children: [
                Container(
                  width: 4.w,
                  height: 24.h,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                SizedBox(width: 12.w),
                Text(
                  'İşlem Geçmişi',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1A1A2E),
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primaryGreen.withAlpha(25),
                        AppColors.primaryGreen.withAlpha(12),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: AppColors.primaryGreen.withAlpha(50),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.receipt_long,
                        size: 14.r,
                        color: AppColors.primaryGreen,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        '${transactions.length} İşlem',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryGreen,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Transaction List
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          sliver: SliverList.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              // Animasyon için delay hesaplama
              final delay = index * 100;
              const maxDelay = 1000; // Maximum 1 saniye delay
              final actualDelay = delay > maxDelay ? maxDelay : delay;

              return TweenAnimationBuilder<double>(
                key: ValueKey('transaction_$index'),
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOutCubic,
                builder: (context, value, child) {
                  // Value değerini 0-1 aralığında tut
                  final clampedValue = value.clamp(0.0, 1.0);

                  return AnimatedContainer(
                    duration: Duration(milliseconds: actualDelay),
                    curve: Curves.easeOut,
                    transform: Matrix4.translationValues(
                      0,
                      (1 - clampedValue) * 20,
                      0,
                    ),
                    child: Opacity(
                      opacity: clampedValue,
                      child: _buildModernTransactionCard(
                        transaction: transactions[index],
                        index: index,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),

        // Bottom Padding
        SliverToBoxAdapter(
          child: SizedBox(height: 100.h),
        ),
      ],
    );
  }

  Widget _buildModernHeader(int transactionCount) {
    return Container(
      height: 280.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryGreen,
            AppColors.primaryGreen.withAlpha(225),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Background Pattern
          Positioned(
            right: -50.w,
            top: -50.h,
            child: Container(
              width: 200.w,
              height: 200.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withAlpha(25),
              ),
            ),
          ),
          Positioned(
            left: -30.w,
            bottom: -30.h,
            child: Container(
              width: 150.w,
              height: 150.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withAlpha(12),
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back Button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40.w,
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(50),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: Colors.white.withAlpha(75),
                        ),
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 18.r,
                      ),
                    ),
                  ),

                  SizedBox(height: 20.h),

                  // Title
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.displayName,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 6.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withAlpha(50),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.category_outlined,
                                    color: Colors.white,
                                    size: 14.r,
                                  ),
                                  SizedBox(width: 6.w),
                                  Text(
                                    widget.assetSubType == 'bracelet'
                                        ? 'Bilezik'
                                        : 'Normal',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Asset Icon
                      Container(
                        width: 80.w,
                        height: 80.h,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withAlpha(75),
                              Colors.white.withAlpha(25),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                            color: Colors.white.withAlpha(75),
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            getAssetIcon(widget.assetType, widget.assetSubType),
                            style: TextStyle(fontSize: 32.sp),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards({
    required double totalQuantity,
    required double totalInvestment,
    required double totalGramWeight,
    required double averagePrice,
  }) {
    final nf = NumberFormat('#,##0.00');

    return Container(
      margin: const EdgeInsets.only(top: 0),
      transform: Matrix4.translationValues(0, -40.h, 0),
      child: Column(
        children: [
          // Main Summary Card
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w),
            padding: EdgeInsets.all(20.r),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(15),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                // Top Stats
                Row(
                  children: [
                    Expanded(
                      child: _buildStatItem(
                        icon: Icons.inventory_2,
                        label: 'Toplam Miktar',
                        value: widget.assetSubType == 'bracelet'
                            ? '${totalQuantity.toStringAsFixed(0)} adet'
                            : '${totalQuantity.toStringAsFixed(2)} ${getQuantityUnit(widget.assetType, (widget.assetSubType == 'bracelet' ? true : false))}',
                        color: Colors.blue,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 50.h,
                      color: Colors.grey[200],
                    ),
                    Expanded(
                      child: _buildStatItem(
                        icon: Icons.account_balance_wallet,
                        label: 'Toplam Yatırım',
                        value: '₺${nf.format(totalInvestment)}',
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),

                if (widget.assetSubType == 'bracelet' &&
                    totalGramWeight > 0) ...[
                  SizedBox(height: 16.h),
                  Container(
                    padding: EdgeInsets.all(12.r),
                    decoration: BoxDecoration(
                      color: Colors.amber.withAlpha(25),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: Colors.amber.withAlpha(75),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.scale,
                          color: Colors.amber[700],
                          size: 20.r,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Toplam Ağırlık: ',
                          style: TextStyle(
                            color: Colors.amber[700],
                            fontSize: 14.sp,
                          ),
                        ),
                        Text(
                          '${totalGramWeight.toStringAsFixed(1)} gram',
                          style: TextStyle(
                            color: Colors.amber[700],
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Average Price Card
          Container(
            margin: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryGreen.withAlpha(12),
                  AppColors.primaryGreen.withAlpha(5),
                ],
              ),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: AppColors.primaryGreen.withAlpha(50),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 48.w,
                  height: 48.h,
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen.withAlpha(25),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    Icons.analytics,
                    color: AppColors.primaryGreen,
                    size: 24.r,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ortalama Alış Fiyatı',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13.sp,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Text(
                            '₺${nf.format(averagePrice)}',
                            style: TextStyle(
                              color: AppColors.primaryGreen,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryGreen.withAlpha(25),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Text(
                              getQuantityUnit(
                                  widget.assetType,
                                  (widget.assetSubType == 'bracelet'
                                      ? true
                                      : false)),
                              style: TextStyle(
                                color: AppColors.primaryGreen,
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          width: 40.w,
          height: 40.h,
          decoration: BoxDecoration(
            color: color.withAlpha(25),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(icon, color: color, size: 20.r),
        ),
        SizedBox(height: 8.h),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 11.sp,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            color: const Color(0xFF1A1A2E),
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildModernTransactionCard({
    required AssetTransactionModel transaction,
    required int index,
  }) {
    final nf = NumberFormat('#,##0.00');
    final dateFormat = DateFormat('dd MMMM yyyy');

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Colors.grey[200]!,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16.r),
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: () {
            HapticFeedback.lightImpact();
            _showTransactionDetail(transaction);
          },
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Row(
              children: [
                // Transaction Number Badge
                Container(
                  width: 52.w,
                  height: 52.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primaryGreen.withAlpha(200),
                        AppColors.primaryGreen,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(14.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryGreen.withAlpha(75),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '#${transaction.transactionNumber}',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                        ),
                      ),
                      Text(
                        'İşlem',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 10.sp,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 14.w),

                // Transaction Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 14.r,
                            color: Colors.grey[600],
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            dateFormat.format(transaction.buyingDate),
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1A1A2E),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Wrap(
                        spacing: 6.w,
                        runSpacing: 4.h,
                        children: [
                          _buildInfoChip(
                            Icons.inventory_2_outlined,
                            transaction.assetSubType == 'bracelet'
                                ? '${transaction.quantity.toStringAsFixed(0)} adet'
                                : '${transaction.quantity.toStringAsFixed(2)} ${getQuantityUnit(widget.assetType, (widget.assetSubType == 'bracelet' ? true : false))}',
                            Colors.blue,
                          ),
                          if (transaction.assetSubType == 'bracelet' &&
                              transaction.gramWeight != null)
                            _buildInfoChip(
                              Icons.scale,
                              '${transaction.gramWeight!.toStringAsFixed(1)} gr',
                              Colors.amber,
                            ),
                          _buildInfoChip(
                            Icons.local_offer,
                            '₺${nf.format(transaction.buyingPrice)}',
                            Colors.purple,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Total Amount
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withAlpha(25),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        '₺${nf.format(transaction.totalInvestment)}',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700],
                        ),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Toplam',
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: color.withAlpha(50),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12.r, color: color),
          SizedBox(width: 4.w),
          Text(
            text,
            style: TextStyle(
              fontSize: 11.sp,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _showTransactionDetail(
    AssetTransactionModel transaction,
  ) {
    final nf = NumberFormat('#,##0.00');
    final dateFormat = DateFormat('dd MMMM yyyy, HH:mm:ss');

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      enableDrag: true,
      isDismissible: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(50),
                blurRadius: 30,
                offset: const Offset(0, -10),
              ),
            ],
          ),
          child: Column(
            children: [
              // Handle Bar
              Container(
                margin: EdgeInsets.only(top: 12.h),
                width: 50.w,
                height: 5.h,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2.5.r),
                ),
              ),

              // Header Section
              Container(
                margin: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 0),
                child: Row(
                  children: [
                    // Transaction Badge
                    Container(
                      width: 60.w,
                      height: 60.h,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primaryGreen,
                            AppColors.primaryGreen.withAlpha(200),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(18.r),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryGreen.withAlpha(75),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '#${transaction.transactionNumber}',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                            ),
                          ),
                          Text(
                            'İşlem',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 11.sp,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(width: 16.w),

                    // Title and Close Button
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'İşlem Detayları',
                            style: TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF1A1A2E),
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryGreen.withAlpha(25),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.access_time,
                                  size: 12.r,
                                  color: AppColors.primaryGreen,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  dateFormat.format(transaction.createdAt),
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primaryGreen,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Close Button
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 36.w,
                        height: 36.h,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Icon(
                          Icons.close,
                          size: 20.r,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24.h),

              // Content Section
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    children: [
                      // Main Info Cards
                      Row(
                        children: [
                          Expanded(
                            child: _buildInfoCard(
                              icon: Icons.inventory_2,
                              title: 'Miktar',
                              value: transaction.assetSubType == 'bracelet'
                                  ? '${transaction.quantity.toStringAsFixed(0)} adet'
                                  : '${transaction.quantity.toStringAsFixed(2)} ${getQuantityUnit(widget.assetType, (widget.assetSubType == 'bracelet' ? true : false))}',
                              color: Colors.blue,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: _buildInfoCard(
                              icon: Icons.local_offer,
                              title: 'Birim Fiyat',
                              value: '₺${nf.format(transaction.buyingPrice)}',
                              color: Colors.purple,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 12.h),

                      // Weight Card (if applicable)
                      if (transaction.gramWeight != null)
                        Container(
                          margin: EdgeInsets.only(bottom: 12.h),
                          child: _buildInfoCard(
                            icon: Icons.scale,
                            title: 'Toplam Ağırlık',
                            value:
                                '${transaction.gramWeight!.toStringAsFixed(1)} gram',
                            color: Colors.amber,
                            isFullWidth: true,
                          ),
                        ),

                      // Total Investment Card
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(20.r),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primaryGreen.withAlpha(25),
                              AppColors.primaryGreen.withAlpha(12),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                            color: AppColors.primaryGreen.withAlpha(75),
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 40.w,
                                  height: 40.h,
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryGreen.withAlpha(25),
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: Icon(
                                    Icons.account_balance_wallet,
                                    color: AppColors.primaryGreen,
                                    size: 20.r,
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Toplam Yatırım',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      '₺${nf.format(transaction.totalInvestment)}',
                                      style: TextStyle(
                                        fontSize: 28.sp,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryGreen,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 20.h),

                      // Additional Details
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(20.r),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: Colors.grey[200]!,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  size: 18.r,
                                  color: Colors.grey[600],
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  'Ek Bilgiler',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF1A1A2E),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16.h),
                            _buildDetailItem(
                              'Varlık Türü',
                              widget.displayName,
                              Icons.category,
                            ),
                            _buildDetailItem(
                              'Alt Kategori',
                              transaction.assetSubType == 'bracelet'
                                  ? 'Bilezik'
                                  : 'Normal',
                              Icons.subdirectory_arrow_right,
                            ),
                            _buildDetailItem(
                              'İşlem Tarihi',
                              DateFormat('EEEE, dd MMMM yyyy')
                                  .format(transaction.buyingDate),
                              Icons.calendar_today,
                            ),
                            _buildDetailItem(
                              'İşlem Saati',
                              DateFormat('HH:mm:ss')
                                  .format(transaction.createdAt),
                              Icons.access_time,
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 32.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    bool isFullWidth = false,
  }) {
    return Container(
      width: isFullWidth ? double.infinity : null,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: color.withAlpha(75),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 44.w,
            height: 44.h,
            decoration: BoxDecoration(
              color: color.withAlpha(50),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: color, size: 22.r),
          ),
          SizedBox(height: 12.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
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

  Widget _buildDetailItem(String label, String value, IconData icon) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16.r,
            color: Colors.grey[500],
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[600],
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1A1A2E),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      body: CustomScrollView(
        slivers: [
          // Loading Header
          SliverToBoxAdapter(
            child: Container(
              height: 280.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primaryGreen,
                    AppColors.primaryGreen.withAlpha(200),
                  ],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 40.w,
                          height: 40.h,
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(50),
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: Colors.white.withAlpha(75),
                            ),
                          ),
                          child: Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                            size: 18.r,
                          ),
                        ),
                      ),
                      const Spacer(),
                      // Skeleton loaders for title
                      Container(
                        width: 200.w,
                        height: 24.h,
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(50),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Container(
                        width: 120.w,
                        height: 20.h,
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(37),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Loading Cards
          SliverToBoxAdapter(
            child: Container(
              transform: Matrix4.translationValues(0, -40.h, 0),
              child: Column(
                children: [
                  // Main loading card
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20.w),
                    height: 140.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(20),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryGreen,
                        strokeWidth: 3,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  // Skeleton transaction cards
                  ...List.generate(
                      3,
                      (index) => Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 20.w, vertical: 6.h),
                            height: 80.h,
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(16.r),
                              child: Row(
                                children: [
                                  // Skeleton badge
                                  Container(
                                    width: 52.w,
                                    height: 52.h,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(14.r),
                                    ),
                                  ),
                                  SizedBox(width: 14.w),
                                  // Skeleton content
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 120.w,
                                          height: 14.h,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius:
                                                BorderRadius.circular(7.r),
                                          ),
                                        ),
                                        SizedBox(height: 8.h),
                                        Container(
                                          width: 180.w,
                                          height: 12.h,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius:
                                                BorderRadius.circular(6.r),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Skeleton amount
                                  Container(
                                    width: 70.w,
                                    height: 30.h,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      body: CustomScrollView(
        slivers: [
          // Header
          SliverToBoxAdapter(
            child: _buildModernHeader(0),
          ),

          // Empty State Content
          SliverFillRemaining(
            hasScrollBody: false,
            child: Container(
              transform: Matrix4.translationValues(0, -40.h, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Empty icon
                  Container(
                    width: 120.w,
                    height: 120.w,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primaryGreen.withAlpha(25),
                          AppColors.primaryGreen.withAlpha(12),
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.receipt_long_outlined,
                      size: 60.r,
                      color: AppColors.primaryGreen.withAlpha(12),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    'İşlem Bulunamadı',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1A1A2E),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Bu varlık için henüz işlem kaydı yok',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 32.h),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.arrow_back, size: 18.r),
                    label: const Text('Geri Dön'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                          horizontal: 24.w, vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // String _getUnit() {
  //   switch (widget.assetType.toUpperCase()) {
  //     case 'ALTIN':
  //     case 'KULCEALTIN':
  //     case 'AYAR14':
  //     case 'AYAR22':
  //       return 'gram';
  //     case 'USDTRY':
  //       return 'USD';
  //     case 'EURTRY':
  //       return 'EUR';
  //     case 'GBPTRY':
  //       return 'GBP';
  //     default:
  //       return 'adet';
  //   }
  // }

  // String _getAssetIcon() {
  //   // Bilezik kontrolü
  //   if (widget.assetSubType == 'bracelet') {
  //     switch (widget.assetType.toUpperCase()) {
  //       case 'AYAR14':
  //         return '🔗'; // 14K bilezik (zincir)
  //       case 'AYAR22':
  //         return '📿'; // 22K bilezik (daha değerli, tespih görünümü)
  //       case 'ALTIN':
  //       case 'KULCEALTIN':
  //         return '📿'; // Altın bilezik
  //       case 'GUMUSTRY':
  //         return '⚪'; // Gümüş bilezik (beyaz/gümüş renk)
  //       default:
  //         return '🔗'; // Genel bilezik
  //     }
  //   }

  //   // Normal ürünler (külçe/gram)
  //   switch (widget.assetType.toUpperCase()) {
  //     case 'AYAR14':
  //       return '🪙'; // 14K altın külçe/sikke
  //     case 'AYAR22':
  //       return '🥇'; // 22K altın külçe (daha değerli)
  //     case 'ALTIN':
  //     case 'KULCEALTIN':
  //       return '🧈'; // Külçe altın (gerçek külçe görünümü)
  //     case 'USDTRY':
  //       return '💵'; // Dolar banknotu
  //     case 'EURTRY':
  //       return '💶'; // Euro banknotu
  //     case 'GBPTRY':
  //       return '💷'; // Sterlin banknotu
  //     case 'GUMUSTRY':
  //       return '🥈'; // Gümüş külçe/madalya
  //     case 'PLATIN':
  //       return '💎'; // Platin (değerli taş görünümü)
  //     default:
  //       return '💰'; // Genel para torbası
  //   }
  // }
}

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
        SliverToBoxAdapter(
          child: _buildModernHeader(transactions.length),
        ),
        SliverToBoxAdapter(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: _buildModernSummary(
                totalQuantity: totalQuantity,
                totalInvestment: totalInvestment,
                totalGramWeight: totalGramWeight,
                averagePrice: averagePrice,
                transactionCount: transactions.length,
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 16.h),
            child: Text(
              'Tüm İşlemler',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1A1A2E),
                letterSpacing: -0.5,
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          sliver: SliverList.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              return _buildModernTransactionCard(
                transaction: transactions[index],
                index: index,
              );
            },
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(height: 100.h),
        ),
      ],
    );
  }

  Widget _buildModernHeader(int transactionCount) {
    return Container(
      height: 250.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryGreen,
            AppColors.primaryGreen.withBlue(20),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -80.w,
            top: -20.h,
            child: Container(
              width: 240.w,
              height: 240.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withAlpha(50),
                  width: 2.5,
                ),
              ),
            ),
          ),
          Positioned(
            right: -50.w,
            top: 10.h,
            child: Container(
              width: 180.w,
              height: 180.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withAlpha(35),
                  width: 2,
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 44.w,
                      height: 44.h,
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(90),
                        borderRadius: BorderRadius.circular(14.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(15),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: AppColors.primaryGreen,
                        size: 18.r,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 80.w,
                          height: 80.h,
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(120),
                            borderRadius: BorderRadius.circular(20.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(20),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              getAssetIcon(
                                  widget.assetType, widget.assetSubType),
                              style: TextStyle(fontSize: 40.sp),
                            ),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          widget.displayName,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        if (widget.assetSubType == 'bracelet') ...[
                          SizedBox(height: 8.h),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 5.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(90),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Text(
                              'Bilezik',
                              style: TextStyle(
                                color: AppColors.primaryGreen,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernSummary({
    required double totalQuantity,
    required double totalInvestment,
    required double totalGramWeight,
    required double averagePrice,
    required int transactionCount,
  }) {
    final nf = NumberFormat('#,##0.00');

    return Container(
      margin: EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
      transform: Matrix4.translationValues(0, -40.h, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final cardWidth = (constraints.maxWidth - 12.w) / 2;
              final cardHeight = cardWidth * 0.85;

              return Wrap(
                spacing: 12.w,
                runSpacing: 12.h,
                children: [
                  SizedBox(
                    width: cardWidth,
                    height: cardHeight,
                    child: _buildInfoCard(
                      icon: Icons.account_balance_wallet,
                      label: 'Toplam Yatırım',
                      value: '₺${nf.format(totalInvestment)}',
                      color: AppColors.primaryGreen,
                      isLarge: true,
                    ),
                  ),
                  SizedBox(
                    width: cardWidth,
                    height: cardHeight,
                    child: _buildInfoCard(
                      icon: Icons.inventory_2_outlined,
                      label: 'Toplam Miktar',
                      value: widget.assetSubType == 'bracelet'
                          ? '${totalQuantity.toStringAsFixed(0)} adet'
                          : '${totalQuantity.toStringAsFixed(2)} ${getQuantityUnit(widget.assetType, false)}',
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(
                    width: cardWidth,
                    height: cardHeight,
                    child: _buildInfoCard(
                      icon: Icons.trending_up,
                      label: 'Ortalama Fiyat',
                      value: '₺${nf.format(averagePrice)}',
                      color: Colors.purple,
                    ),
                  ),
                  SizedBox(
                    width: cardWidth,
                    height: cardHeight,
                    child:
                        widget.assetSubType == 'bracelet' && totalGramWeight > 0
                            ? _buildInfoCard(
                                icon: Icons.scale_outlined,
                                label: 'Toplam Ağırlık',
                                value: '${totalGramWeight.toStringAsFixed(1)}g',
                                color: Colors.amber,
                              )
                            : _buildInfoCard(
                                icon: Icons.receipt,
                                label: 'İşlem Sayısı',
                                value: '$transactionCount',
                                color: Colors.teal,
                              ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    bool isLarge = false,
  }) {
    return Container(
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: isLarge ? 44.w : 36.w,
            height: isLarge ? 44.h : 36.h,
            decoration: BoxDecoration(
              color: color.withAlpha(25),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              icon,
              color: color,
              size: isLarge ? 22.r : 18.r,
            ),
          ),
          SizedBox(height: 6.h),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 9.sp,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(height: 2.h),
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Text(
                  value,
                  style: TextStyle(
                    color: const Color(0xFF1A1A2E),
                    fontSize: isLarge ? 13.sp : 11.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernTransactionCard({
    required AssetTransactionModel transaction,
    required int index,
  }) {
    final nf = NumberFormat('#,##0.00');
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20.r),
        child: InkWell(
          borderRadius: BorderRadius.circular(20.r),
          onTap: () {
            HapticFeedback.lightImpact();
            _showTransactionDetail(transaction);
          },
          child: Padding(
            padding: EdgeInsets.all(14.r),
            child: Row(
              children: [
                Container(
                  width: 50.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primaryGreen.withAlpha(200),
                        AppColors.primaryGreen,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryGreen.withAlpha(60),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Padding(
                        padding: EdgeInsets.all(4.r),
                        child: Text(
                          '#${transaction.transactionNumber}',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        dateFormat.format(transaction.buyingDate),
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1A1A2E),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildCompactChip(
                              '${transaction.quantity.toStringAsFixed(transaction.assetSubType == 'bracelet' ? 0 : 2)} ${getQuantityUnit(widget.assetType, transaction.assetSubType == 'bracelet')}',
                              Icons.inventory_2_outlined,
                              Colors.blue.shade600,
                            ),
                            SizedBox(width: 6.w),
                            _buildCompactChip(
                              '₺${nf.format(transaction.buyingPrice)}',
                              Icons.attach_money,
                              Colors.purple.shade600,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        '₺${nf.format(transaction.totalInvestment)}',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryGreen,
                        ),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen.withAlpha(25),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        'TOPLAM',
                        style: TextStyle(
                          fontSize: 7.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryGreen,
                          letterSpacing: 0.5,
                        ),
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

  Widget _buildCompactChip(String text, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10.r, color: color),
          SizedBox(width: 3.w),
          Text(
            text,
            style: TextStyle(
              fontSize: 9.sp,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _showTransactionDetail(AssetTransactionModel transaction) {
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
              Container(
                margin: EdgeInsets.only(top: 12.h),
                width: 50.w,
                height: 5.h,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2.5.r),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 0),
                child: Row(
                  children: [
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
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildInfoCardDialog(
                              icon: Icons.inventory_2,
                              title: 'Miktar',
                              value: transaction.assetSubType == 'bracelet'
                                  ? '${transaction.quantity.toStringAsFixed(0)} adet'
                                  : '${transaction.quantity.toStringAsFixed(2)} ${getQuantityUnit(widget.assetType, transaction.assetSubType == 'bracelet')}',
                              color: Colors.blue,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: _buildInfoCardDialog(
                              icon: Icons.local_offer,
                              title: 'Birim Fiyat',
                              value: '₺${nf.format(transaction.buyingPrice)}',
                              color: Colors.purple,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      if (transaction.gramWeight != null)
                        Container(
                          margin: EdgeInsets.only(bottom: 12.h),
                          child: _buildInfoCardDialog(
                            icon: Icons.scale,
                            title: 'Toplam Ağırlık',
                            value:
                                '${transaction.gramWeight!.toStringAsFixed(1)} gram',
                            color: Colors.amber,
                            isFullWidth: true,
                          ),
                        ),
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
                              DateFormat('dd MMMM yyyy')
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

  Widget _buildInfoCardDialog({
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
          SliverToBoxAdapter(
            child: Container(
              height: 250.h,
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
                          width: 44.w,
                          height: 44.h,
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(90),
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                          child: Icon(
                            Icons.arrow_back_ios_new,
                            color: AppColors.primaryGreen,
                            size: 18.r,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      ),
                    ],
                  ),
                ),
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
          SliverToBoxAdapter(
            child: _buildModernHeader(0),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Container(
              transform: Matrix4.translationValues(0, -40.h, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                      color: AppColors.primaryGreen.withAlpha(150),
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
}

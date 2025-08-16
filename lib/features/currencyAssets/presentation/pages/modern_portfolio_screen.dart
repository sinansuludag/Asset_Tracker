import 'package:asset_tracker/core/constants/colors/app_colors.dart';
import 'package:asset_tracker/features/currencyAssets/presentation/state_management/riverpod/all_provider.dart';
import 'package:asset_tracker/features/currencyAssets/presentation/widgets/modern/portfolio_assets_widget.dart';
import 'package:asset_tracker/features/currencyAssets/presentation/widgets/modern/portfolio_chart_widget.dart';
import 'package:asset_tracker/features/currencyAssets/presentation/widgets/modern/portfolio_header_widget.dart';
import 'package:asset_tracker/features/currencyAssets/presentation/widgets/modern/portfolio_performance_widget.dart';
import 'package:asset_tracker/features/currencyAssets/presentation/widgets/modern/portfolio_quick_actions_widget.dart';
import 'package:asset_tracker/features/auth/presentation/state_management/user_firestore_provider.dart';
import 'package:asset_tracker/features/home/presentation/state_management/provider/all_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ModernPortfolioScreen extends ConsumerStatefulWidget {
  const ModernPortfolioScreen({super.key});

  @override
  ConsumerState<ModernPortfolioScreen> createState() =>
      _ModernPortfolioScreenState();
}

class _ModernPortfolioScreenState extends ConsumerState<ModernPortfolioScreen>
    with TickerProviderStateMixin {
  String? userId;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  /// İlk girişte veriler hazır olana kadar skeleton göstermek için
  bool _booting = true;

  /// Kur verileri gelmeden önce son bilinen fiyatı tutar (beyaz ekran/crash önler)
  final Map<String, double> _lastKnownPrices = {};

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _initializeData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// Kullanıcıyı çek → kullanıcıya göre portföy stream’ini başlat → kur verisini tazele
  Future<void> _initializeData() async {
    try {
      final uid = await ref.read(userProvider.notifier).getUserFromFirestore();
      userId = uid;

      if (userId != null && userId!.isNotEmpty) {
        // Kullanıcının varlıklarını dinlemeye başla
        ref.read(currencyAssetProvider.notifier).listenCurrencyAssets(userId!);

        // Kur verisini elle tetikle (senin projende vardı)
        ref.read(currencyNotifierProvider.notifier).manualRefresh();
      }
    } catch (e) {
      debugPrint('ModernPortfolio init error: $e');
    } finally {
      if (mounted) {
        setState(() => _booting = false);
        _animationController.forward();
      }
    }
  }

  /// Map<Model/dynamic> ayrımı yaparak güvenli şekilde buying değerini al
  double? _extractBuying(dynamic v) {
    if (v == null) return null;
    if (v is Map) {
      final raw = v['buying'];
      if (raw is num) return raw.toDouble();
      return null;
    }
    try {
      final candidate = (v as dynamic).buying;
      if (candidate is num) return candidate.toDouble();
    } catch (_) {}
    return null;
  }

  /// fullCurrencyResponse.currencies içinden lastKnownPrices’ı günceller
  void _updateLastKnownPrices(Map<String, dynamic> currencies) {
    for (final entry in currencies.entries) {
      final buying = _extractBuying(entry.value);
      if (buying != null) {
        _lastKnownPrices[entry.key] = buying;
      }
    }
  }

  /// Tekil fiyatı güvenli getir (currency model/Map farkını tolere eder)
  double _getCurrentPrice(String assetType, dynamic currencyResponse) {
    final curMap = currencyResponse?.currencies;
    if (curMap == null) return _lastKnownPrices[assetType] ?? 0.0;

    final v = curMap[assetType];
    final buying = _extractBuying(v);
    return buying ?? (_lastKnownPrices[assetType] ?? 0.0);
  }

  @override
  Widget build(BuildContext context) {
    // Varlık state’i (list)
    final state = ref.watch(currencyAssetProvider);

    // Kur verisi (notifier’da duruyor)
    final currencyNotifier = ref.watch(currencyNotifierProvider.notifier);
    final fullCurrencyResponse = currencyNotifier.fullCurrencyResponse;

    // Güvenli null kontrolü
    final hasCurrencyData =
        (fullCurrencyResponse?.currencies?.isNotEmpty ?? false);
    final hasAssetData = state.assets.isNotEmpty;

    // Kur verisi/varlık verisi gelmeye başladıysa lastKnownPrices’ı güncelle
    if (hasCurrencyData && hasAssetData) {
      _updateLastKnownPrices(fullCurrencyResponse!.currencies);
    }

    // "Yükleniyor mu?" ölçütü:
    // - İlk kez açılış (_booting)
    // - Kullanıcı kimliği daha belli değil (auth/cached)
    // - Kur verisi gelmedi
    final isLoadingOverall = _booting || userId == null || !hasCurrencyData;

    // Portföy metrikleri (boşsa 0’lar)
    final metrics = _calculatePortfolioMetrics(state, fullCurrencyResponse).map(
      (k, v) => MapEntry(k, v ?? 0.0),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF8FFFE),
      body: RefreshIndicator(
        onRefresh: () async {
          if (userId != null) {
            ref
                .read(currencyAssetProvider.notifier)
                .listenCurrencyAssets(userId!);
          }
          ref.read(currencyNotifierProvider.notifier).manualRefresh();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: isLoadingOverall
                ? _buildSkeletonScreen(context)
                : FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        PortfolioHeaderWidget(
                          totalValue: metrics['totalCurrent'] ?? 0.0,
                          totalChange: metrics['profitAmount'] ?? 0.0,
                          changePercentage: metrics['profitRate'] ?? 0.0,
                          userName: "Zehra",
                        ),

                        // Hızlı Aksiyonlar (her durumda gösterebilirsin)
                        const PortfolioQuickActionsWidget(),

                        // Grafik
                        Builder(
                          builder: (_) {
                            final chartData =
                                _buildChartData(state, fullCurrencyResponse);
                            final safeChartData = chartData.isEmpty
                                ? const [
                                    {
                                      'name': '—',
                                      'value': 0.0,
                                      'color': Colors.transparent
                                    }
                                  ]
                                : chartData;

                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: PortfolioChartWidget(
                                portfolioData: safeChartData,
                              ),
                            );
                          },
                        ),

                        // Varlık Listesi
                        if (!hasAssetData)
                          _buildEmptyPortfolioCallout(context)
                        else
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: PortfolioAssetsWidget(
                              assets: state.assets,
                              currencyData:
                                  fullCurrencyResponse?.currencies ?? {},
                              lastKnownPrices: _lastKnownPrices,
                              onAssetTap: (asset) =>
                                  _showAssetDetail(context, asset),
                              onAssetDelete: (asset) => _deleteAsset(asset),
                            ),
                          ),

                        // Performans Kartları (veri yoksa 0 gösterir)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 12),
                          child: PortfolioPerformanceWidget(
                            dailyChange: metrics['dailyChange'] ?? 0.0,
                            weeklyChange: metrics['weeklyChange'] ?? 0.0,
                            monthlyChange: metrics['monthlyChange'] ?? 0.0,
                            totalReturn: metrics['profitAmount'] ?? 0.0,
                          ),
                        ),

                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  /// Gerçek veri yokken görünen ana iskelet ekran
  Widget _buildSkeletonScreen(BuildContext context) {
    return Column(
      key: const ValueKey('skeleton'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),

        // Header Skeleton
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: _SkeletonCard(
            height: 140,
            radius: 24,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: const [
                  _SkeletonBox(width: 60, height: 60, radius: 16),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _SkeletonBox(width: 160, height: 18, radius: 10),
                        SizedBox(height: 10),
                        _SkeletonBox(width: 220, height: 14, radius: 8),
                        SizedBox(height: 10),
                        _SkeletonBox(width: 140, height: 14, radius: 8),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Quick Actions Skeleton
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: const [
              Expanded(child: _SkeletonBox(height: 56, radius: 14)),
              SizedBox(width: 12),
              Expanded(child: _SkeletonBox(height: 56, radius: 14)),
              SizedBox(width: 12),
              Expanded(child: _SkeletonBox(height: 56, radius: 14)),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Chart Skeleton
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: _SkeletonCard(height: 220, radius: 20),
        ),

        const SizedBox(height: 16),

        // Assets Skeleton (3 satır)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: const [
              _AssetRowSkeleton(),
              SizedBox(height: 12),
              _AssetRowSkeleton(),
              SizedBox(height: 12),
              _AssetRowSkeleton(),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Performance Skeleton
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: const [
              Expanded(child: _SkeletonCard(height: 90, radius: 16)),
              SizedBox(width: 12),
              Expanded(child: _SkeletonCard(height: 90, radius: 16)),
              SizedBox(width: 12),
              Expanded(child: _SkeletonCard(height: 90, radius: 16)),
            ],
          ),
        ),

        const SizedBox(height: 40),
      ],
    );
  }

  /// Portföy boşken görünen davet kartı (gerçek veri akışında)
  Widget _buildEmptyPortfolioCallout(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white,
            AppColors.primaryGreen.withOpacity(0.04),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primaryGreen.withOpacity(0.1),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGreen.withOpacity(0.08),
            offset: const Offset(0, 8),
            blurRadius: 18,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryGreen.withOpacity(0.12),
                  AppColors.primaryGreen.withOpacity(0.2),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.add_card,
              size: 36,
              color: AppColors.primaryGreen,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            "Portföyünüz Boş",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  fontSize: 18,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            "İlk varlığınızı ekleyerek yatırımlarınızı\ntakip etmeye başlayın",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                  height: 1.4,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () {
              // Buraya "Varlık Ekle" modal/route'unu bağlayabilirsin
            },
            icon: const Icon(Icons.add),
            label: const Text("Varlık Ekle"),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Map<String, double?> _calculatePortfolioMetrics(
      dynamic state, dynamic currencyResponse) {
    double totalBuy = 0.0;
    double totalCurrent = 0.0;

    for (var asset in state.assets) {
      if (asset == null) continue;

      totalBuy += (asset.buyingPrice ?? 0.0) * (asset.quantity ?? 0.0);

      final currentPrice = _getCurrentPrice(asset.assetType, currencyResponse);
      totalCurrent += currentPrice * (asset.quantity ?? 0.0);
    }

    final profitAmount = totalCurrent - totalBuy;
    final profitRate = totalBuy > 0 ? ((profitAmount) / totalBuy) * 100 : 0.0;

    // Gerçek verin yoksa 0 döner; skeleton aşamasında kullanılmaz
    return {
      'totalBuy': totalBuy,
      'totalCurrent': totalCurrent,
      'profitAmount': profitAmount,
      'profitRate': profitRate,
      // Aşağıdakiler örnek; gerçek hesaplar sende nasıl ise güncelleyebilirsin
      'dailyChange': profitAmount * 0.10,
      'weeklyChange': profitAmount * 0.70,
      'monthlyChange': profitAmount,
    };
  }

  List<Map<String, dynamic>> _buildChartData(
      dynamic state, dynamic currencyResponse) {
    if (state.assets.isEmpty) return [];

    final Map<String, double> assetValues = {};
    final Map<String, Color> assetColors = {};

    for (var asset in state.assets) {
      if (asset == null) continue;

      final currentPrice = _getCurrentPrice(asset.assetType, currencyResponse);
      final value = currentPrice * (asset.quantity ?? 0.0);

      if (value > 0) {
        final displayName = _getDisplayName(asset.assetType);
        assetValues[displayName] = (assetValues[displayName] ?? 0.0) + value;
        assetColors[displayName] = _getColorFromString(asset.assetType);
      }
    }

    return assetValues.entries
        .map((e) => {
              'name': e.key,
              'value': e.value,
              'color': assetColors[e.key] ?? _getColorFromString(e.key),
            })
        .toList();
  }

  String _getDisplayName(String assetType) {
    final manualMapping = {
      'ALTIN': 'Altın',
      'USDTRY': 'ABD Doları',
      'EURTRY': 'Euro',
      'GBPTRY': 'İngiliz Sterlini',
      'AYAR14': '14 Ayar Altın',
      'AYAR22': '22 Ayar Altın',
      'GUMUSTRY': 'Gümüş',
      'ONS': 'Ons Altın',
      'PALADYUM': 'Paladyum',
      'PLATIN': 'Platin',
      'XPTUSD': 'Platin',
      'ATA5_ESKI': "5'li Ata Altın",
      'ATA5_YENI': "5'li Ata Altın",
      'ATA_ESKI': 'Ata Altın',
      'ATA_YENI': 'Ata Altın',
      'CEYREK_ESKI': 'Çeyrek Altın',
      'CEYREK_YENI': 'Çeyrek Altın',
      'TEK_ESKI': 'Tam Altın',
      'TEK_YENI': 'Tam Altın',
      'YARIM_ESKI': 'Yarım Altın',
      'YARIM_YENI': 'Yarım Altın',
      'GREMESE_ESKI': 'Gremse Altın',
      'GREMESE_YENI': 'Gremse Altın',
      'KULCEALTIN': 'Külçe Altın',
    };
    return manualMapping[assetType.toUpperCase()] ?? assetType;
  }

  Color _getColorFromString(String input) {
    final specialColors = {
      'ALTIN': const Color(0xFFFFD700),
      'USDTRY': const Color(0xFF2E8B57),
      'EURTRY': const Color(0xFF4169E1),
      'GBPTRY': const Color(0xFF8B008B),
      'AYAR14': const Color(0xFFDAA520),
      'AYAR22': const Color(0xFFFFD700),
      'GUMUSTRY': const Color(0xFFC0C0C0),
      'ONS': const Color(0xFFFF8C00),
      'PALADYUM': const Color(0xFF9932CC),
      'PLATIN': const Color(0xFF708090),
    };
    final color = specialColors[input.toUpperCase()];
    if (color != null) return color;

    // Hash based fallback
    final hash = input.hashCode;
    final r = ((hash & 0xFF0000) >> 16).clamp(50, 255);
    final g = ((hash & 0x00FF00) >> 8).clamp(50, 255);
    final b = (hash & 0x0000FF).clamp(50, 255);
    return Color.fromARGB(255, r, g, b);
  }

  void _showAssetDetail(BuildContext context, dynamic asset) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AssetDetailModal(asset: asset),
    );
  }

  Future<void> _deleteAsset(dynamic asset) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Varlığı Sil"),
        content: Text(
            "${asset.assetType} varlığını silmek istediğinizden emin misiniz?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("İptal"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Sil"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await ref
          .read(currencyAssetProvider.notifier)
          .deleteCurrencyAsset(asset.id);
    }
  }
}

/* ------------------------------ SKELETONS ------------------------------ */

class _SkeletonCard extends StatelessWidget {
  final double height;
  final double radius;
  final Widget? child;

  const _SkeletonCard(
      {required this.height, this.radius = 16, this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: child,
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  final double width;
  final double height;
  final double radius;

  const _SkeletonBox(
      {this.width = double.infinity,
      required this.height,
      this.radius = 12,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

class _AssetRowSkeleton extends StatelessWidget {
  const _AssetRowSkeleton({super.key});
  @override
  Widget build(BuildContext context) {
    return _SkeletonCard(
      height: 96,
      radius: 20,
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Row(
          children: const [
            _SkeletonBox(width: 50, height: 50, radius: 14),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SkeletonBox(width: 160, height: 14, radius: 8),
                  SizedBox(height: 8),
                  _SkeletonBox(width: 110, height: 12, radius: 8),
                  SizedBox(height: 12),
                  _SkeletonBox(width: double.infinity, height: 32, radius: 10),
                ],
              ),
            ),
            SizedBox(width: 12),
            _SkeletonBox(width: 62, height: 48, radius: 12),
          ],
        ),
      ),
    );
  }
}

/* --------------------------- DETAIL BOTTOM SHEET --------------------------- */

class _AssetDetailModal extends StatelessWidget {
  final dynamic asset;
  const _AssetDetailModal({required this.asset});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      asset.assetType.length >= 2
                          ? asset.assetType.substring(0, 2).toUpperCase()
                          : asset.assetType.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        asset.assetType,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        "Miktar: ${asset.quantity}",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),

          // Body
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _detailRow("Alış Fiyatı",
                      "₺${(asset.buyingPrice ?? 0).toStringAsFixed(2)}"),
                  _detailRow("Miktar", "${asset.quantity ?? 0}"),
                  _detailRow(
                    "Toplam Yatırım",
                    "₺${(((asset.buyingPrice ?? 0) * (asset.quantity ?? 0)).toStringAsFixed(2))}",
                  ),
                  _detailRow(
                    "Alış Tarihi",
                    asset.buyingDate != null
                        ? "${asset.buyingDate.day}/${asset.buyingDate.month}/${asset.buyingDate.year}"
                        : "-",
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
              )),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

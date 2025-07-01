import 'package:asset_tracker/core/constants/colors/app_colors.dart';
import 'package:asset_tracker/features/currencyAssets/presentation/state_management/riverpod/all_provider.dart';
import 'package:asset_tracker/features/currencyAssets/presentation/widgets/modern/portfolio_assets_widget.dart';
import 'package:asset_tracker/features/currencyAssets/presentation/widgets/modern/portfolio_chart_widget.dart';
import 'package:asset_tracker/features/currencyAssets/presentation/widgets/modern/portfolio_header_widget.dart';
import 'package:asset_tracker/features/currencyAssets/presentation/widgets/modern/portfolio_performance_widget.dart';
import 'package:asset_tracker/features/currencyAssets/presentation/widgets/modern/portfolio_quick_actions_widget.dart';
import 'package:asset_tracker/features/home/presentation/state_management/provider/all_providers.dart';
import 'package:asset_tracker/features/auth/presentation/state_management/user_firestore_provider.dart';
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
  final Map<String, double> _lastKnownPrices = {};

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _initializeData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _initializeData() async {
    final getUser =
        await ref.read(userProvider.notifier).getUserFromFirestore();
    userId = getUser;

    if (userId != null && userId!.isNotEmpty) {
      ref.read(currencyAssetProvider.notifier).listenCurrencyAssets(userId!);
      _animationController.forward();
    }
  }

  void _updateLastKnownPrices(Map<String, dynamic> currencies) {
    for (final entry in currencies.entries) {
      if (entry.value?.buying != null) {
        _lastKnownPrices[entry.key] = entry.value.buying;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(currencyAssetProvider);
    final currencyNotifier = ref.watch(currencyNotifierProvider.notifier);
    final fullCurrencyResponse = currencyNotifier.fullCurrencyResponse;

    final hasCurrencyData = fullCurrencyResponse != null &&
        fullCurrencyResponse.currencies.isNotEmpty;
    final hasAssetData = state.assets.isNotEmpty;

    if (hasCurrencyData && hasAssetData) {
      _updateLastKnownPrices(fullCurrencyResponse!.currencies);
    }

    // Calculate portfolio metrics
    final portfolioMetrics =
        _calculatePortfolioMetrics(state, fullCurrencyResponse);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FFFE),
      body: !hasAssetData
          ? _buildEmptyState(context)
          : FadeTransition(
              opacity: _fadeAnimation,
              child: RefreshIndicator(
                onRefresh: () async {
                  if (userId != null) {
                    ref
                        .read(currencyAssetProvider.notifier)
                        .listenCurrencyAssets(userId!);
                    ref.read(currencyNotifierProvider.notifier).manualRefresh();
                  }
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Portfolio Header
                      PortfolioHeaderWidget(
                        totalValue: portfolioMetrics['totalCurrent'] ?? 0.0,
                        totalChange: portfolioMetrics['profitAmount'] ?? 0.0,
                        changePercentage: portfolioMetrics['profitRate'] ?? 0.0,
                        userName: "Zehra",
                      ),

                      // Quick Actions
                      const PortfolioQuickActionsWidget(),

                      // Chart Section
                      LayoutBuilder(
                        builder: (context, constraints) {
                          return Container(
                            width: constraints.maxWidth,
                            child: PortfolioChartWidget(
                              portfolioData:
                                  _buildChartData(state, fullCurrencyResponse),
                            ),
                          );
                        },
                      ),

                      // Assets List
                      PortfolioAssetsWidget(
                        assets: state.assets,
                        currencyData: fullCurrencyResponse?.currencies ?? {},
                        lastKnownPrices: _lastKnownPrices,
                        onAssetTap: (asset) => _showAssetDetail(context, asset),
                        onAssetDelete: (asset) => _deleteAsset(asset),
                      ),

                      // Performance Metrics
                      PortfolioPerformanceWidget(
                        dailyChange: portfolioMetrics['dailyChange'] ?? 0.0,
                        weeklyChange: portfolioMetrics['weeklyChange'] ?? 0.0,
                        monthlyChange: portfolioMetrics['monthlyChange'] ?? 0.0,
                        totalReturn: portfolioMetrics['profitAmount'] ?? 0.0,
                      ),

                      // Bottom Padding for navigation
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryGreen.withOpacity(0.3),
                    offset: const Offset(0, 8),
                    blurRadius: 24,
                  ),
                ],
              ),
              child: const Icon(
                Icons.account_balance_wallet_outlined,
                size: 60,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              "Portföyünüz Boş",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              "İlk yatırımınızı eklemek için aşağıdaki\nbutona dokunun",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                // Navigate to add asset screen
                // showBuyingAssets(context);
              },
              icon: const Icon(Icons.add_circle_outline),
              label: const Text("İlk Varlığınızı Ekleyin"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, double> _calculatePortfolioMetrics(
      dynamic state, dynamic currencyResponse) {
    double totalBuy = 0.0;
    double totalCurrent = 0.0;

    for (var asset in state.assets) {
      if (asset == null) continue;

      totalBuy += asset.buyingPrice * asset.quantity;

      final currentPrice = _getCurrentPrice(asset.assetType, currencyResponse);
      totalCurrent += currentPrice * asset.quantity;
    }

    final profitAmount = totalCurrent - totalBuy;
    final profitRate =
        totalBuy > 0 ? ((totalCurrent - totalBuy) / totalBuy) * 100 : 0.0;

    return {
      'totalBuy': totalBuy,
      'totalCurrent': totalCurrent,
      'profitAmount': profitAmount,
      'profitRate': profitRate,
      'dailyChange': profitAmount * 0.1, // Mock data
      'weeklyChange': profitAmount * 0.7, // Mock data
      'monthlyChange': profitAmount,
    };
  }

  double _getCurrentPrice(String assetType, dynamic currencyResponse) {
    if (currencyResponse?.currencies == null) {
      return _lastKnownPrices[assetType] ?? 0.0;
    }

    // Convert asset type to currency code if needed
    final currencyData = currencyResponse.currencies[assetType];
    return currencyData?.buying ?? _lastKnownPrices[assetType] ?? 0.0;
  }

  List<Map<String, dynamic>> _buildChartData(
      dynamic state, dynamic currencyResponse) {
    if (state.assets.isEmpty) return [];

    final Map<String, double> assetValues = {};
    final Map<String, Color> assetColors = {};

    for (var asset in state.assets) {
      if (asset == null) continue;

      final currentPrice = _getCurrentPrice(asset.assetType, currencyResponse);
      final value = currentPrice * asset.quantity;

      // Eğer değer 0'dan büyükse ekle
      if (value > 0) {
        final displayName = _getDisplayName(asset.assetType);
        assetValues[displayName] = (assetValues[displayName] ?? 0.0) + value;
        assetColors[displayName] = _getColorFromString(asset.assetType);
      }
    }

    return assetValues.entries.map((entry) {
      return {
        'name': entry.key,
        'value': entry.value,
        'color': assetColors[entry.key] ?? _getColorFromString(entry.key),
      };
    }).toList();
  }

  String _getDisplayName(String assetType) {
    // Manuel mapping ile asset isimlerini düzgün göster
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
    // Özel renkler bazı asset türleri için
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

    // Fallback: Hash based color
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

  void _deleteAsset(dynamic asset) async {
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

// Asset Detail Modal
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

          // Asset Details
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildDetailRow("Alış Fiyatı",
                      "₺${asset.buyingPrice.toStringAsFixed(2)}"),
                  _buildDetailRow("Miktar", "${asset.quantity}"),
                  _buildDetailRow("Toplam Yatırım",
                      "₺${(asset.buyingPrice * asset.quantity).toStringAsFixed(2)}"),
                  _buildDetailRow("Alış Tarihi",
                      "${asset.buyingDate.day}/${asset.buyingDate.month}/${asset.buyingDate.year}"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
          ),
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

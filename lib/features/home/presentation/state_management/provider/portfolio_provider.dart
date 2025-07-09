import 'package:asset_tracker/features/home/data/models/portfolio_model.dart';
import 'package:asset_tracker/features/home/data/models/user_asset_model.dart';
import 'package:asset_tracker/features/home/data/models/buying_asset_model.dart';
import 'package:asset_tracker/features/home/data/models/curreny_response_model.dart';
import 'package:asset_tracker/features/home/presentation/state_management/provider/all_providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Portföy hesaplamalarını yöneten StateNotifier
class PortfolioNotifier extends StateNotifier<PortfolioModel> {
  final Ref _ref;

  PortfolioNotifier(this._ref) : super(PortfolioModel.initial()) {
    _initializePortfolio();
  }

  void _initializePortfolio() {
    // Currency güncellemelerini dinle
    _ref.listen(currencyNotifierProvider, (previous, next) {
      if (next.isNotEmpty) {
        _calculatePortfolio(next.first);
      }
    });

    // İlk yükleme
    refreshPortfolio();
  }

  /// Portföyü yenileme
  Future<void> refreshPortfolio() async {
    state = state.copyWith(isLoading: true, hasError: false);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        state = state.copyWith(isLoading: false, hasError: true);
        return;
      }

      // Kullanıcının varlıklarını çek
      final assetRepository = _ref.read(assetRepositoryProvider);
      final userAssets =
          await assetRepository.getUserAssetsRepository(user.uid);

      // Güncel kurları al
      final currencies = _ref.read(currencyNotifierProvider);

      if (currencies.isNotEmpty) {
        // Portföy hesaplamalarını yap
        _calculatePortfolioWithAssets(
            userAssets.cast<BuyingAssetModel>(), currencies.first);
      } else {
        // Currency verisi yoksa boş portföy
        state = state.copyWith(
          assets: [],
          isLoading: false,
          hasError: false,
        );
      }
    } catch (e) {
      print('❌ Portfolio refresh error: $e');
      state = state.copyWith(
        isLoading: false,
        hasError: true,
      );
    }
  }

  /// Currency güncellemesi geldiğinde portföy hesaplama
  void _calculatePortfolio(CurrencyResponse currencyResponse) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final assetRepository = _ref.read(assetRepositoryProvider);
      final userAssets =
          await assetRepository.getUserAssetsRepository(user.uid);

      _calculatePortfolioWithAssets(
          userAssets.cast<BuyingAssetModel>(), currencyResponse);
    } catch (e) {
      print('❌ Portfolio calculation error: $e');
    }
  }

  /// Portföy değerlerini hesaplama - Ana business logic
  void _calculatePortfolioWithAssets(
      List<BuyingAssetModel> buyingAssets, CurrencyResponse currencyResponse) {
    final List<UserAssetModel> userAssets = [];
    double totalValue = 0.0;
    double totalInvested = 0.0;

    // Her bir satın alınan varlık için hesaplama
    for (final buyingAsset in buyingAssets) {
      final currencyData = currencyResponse.currencies[buyingAsset.assetType];

      if (currencyData != null) {
        // Issue gereksinimi: Bilezik özel hesaplama
        double investedAmount;
        if (buyingAsset.isBracelet && buyingAsset.gramWeight != null) {
          // Bilezik: gramWeight × ayarPrice
          final ayar14Price =
              currencyResponse.currencies['AYAR14']?.buying ?? 0.0;
          final ayar22Price =
              currencyResponse.currencies['AYAR22']?.buying ?? 0.0;

          investedAmount =
              buyingAsset.calculateBraceletValue(ayar14Price, ayar22Price);
        } else {
          // Normal: quantity × buyingPrice
          investedAmount = buyingAsset.quantity * buyingAsset.buyingPrice;
        }

        // BuyingAsset'i UserAsset'e çevir (güncel fiyatlarla)
        final userAsset =
            UserAssetModel.fromBuyingAsset(buyingAsset, currencyData);
        userAssets.add(userAsset);

        // Toplam değer ve yatırılan miktar hesaplama
        totalValue += userAsset.currentValue;
        totalInvested += investedAmount;
      }
    }

    // Toplam değişim ve yüzdesi hesaplama
    final totalChange = totalValue - totalInvested;
    final changePercentage =
        totalInvested > 0 ? (totalChange / totalInvested) * 100 : 0.0;

    // Yeni state oluşturma
    state = PortfolioModel(
      totalValue: totalValue,
      totalChange: totalChange,
      changePercentage: changePercentage,
      assets: userAssets,
      isLoading: false,
      hasError: false,
    );
  }

  /// Varlıkları türe göre gruplama (portfolyo görünümü için)
  Map<String, List<UserAssetModel>> get groupedAssets {
    final Map<String, List<UserAssetModel>> grouped = {};

    for (final asset in state.assets) {
      if (grouped[asset.assetType] == null) {
        grouped[asset.assetType] = [];
      }
      grouped[asset.assetType]!.add(asset);
    }

    return grouped;
  }
}

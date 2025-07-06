import 'package:asset_tracker/features/home/data/datasources/firebase_store/portfolio_service.dart';
import 'package:asset_tracker/features/home/data/models/portfolio_model.dart';
import 'package:asset_tracker/features/home/data/models/user_asset_model.dart';
import 'package:asset_tracker/features/home/data/models/buying_asset_model.dart';
import 'package:asset_tracker/features/home/data/models/curreny_response_model.dart';

import 'package:asset_tracker/features/home/presentation/state_management/provider/all_providers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Portföy hesaplamalarını yöneten notifier
class PortfolioNotifier extends StateNotifier<PortfolioModel> {
  final Ref _ref;
  final IPortfolioService _portfolioService;

  PortfolioNotifier(this._ref)
      : _portfolioService = PortfolioFirestoreService(
            FirebaseFirestore.instance, FirebaseAuth.instance),
        super(PortfolioModel.initial()) {
    _initializePortfolio();
  }

  void _initializePortfolio() {
    // Currency güncellemelerini dinle
    _ref.listen(currencyNotifierProvider, (previous, next) {
      if (next.isNotEmpty) {
        _calculatePortfolio(next.first); // Yeni kurlarla hesapla
      }
    });

    // İlk yükleme
    refreshPortfolio();
  }

  Future<void> refreshPortfolio() async {
    state = state.copyWith(isLoading: true);

    try {
      // Kullanıcının varlıklarını çek
      final userAssets = await _portfolioService.getUserAssets();
      // Güncel kurları al
      final currencies = _ref.read(currencyNotifierProvider);

      if (currencies.isNotEmpty) {
        // Portföy hesaplamalarını yap
        _calculatePortfolioWithAssets(userAssets, currencies.first);
      } else {
        // Currency verisi yoksa sadece asset'leri göster
        state = state.copyWith(
          assets: [],
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        hasError: true,
      );
    }
  }

  void _calculatePortfolio(CurrencyResponse currencyResponse) {
    _portfolioService.getUserAssets().then((userAssets) {
      _calculatePortfolioWithAssets(userAssets, currencyResponse);
    });
  }

  void _calculatePortfolioWithAssets(
      List<BuyingAssetModel> buyingAssets, CurrencyResponse currencyResponse) {
    final List<UserAssetModel> userAssets = [];
    double totalValue = 0.0;
    double totalInvested = 0.0;

    // Her bir satın alınan varlık için hesaplama
    for (final buyingAsset in buyingAssets) {
      final currencyData = currencyResponse.currencies[buyingAsset.assetType];

      if (currencyData != null) {
        // BuyingAsset'i UserAsset'e çevir (güncel fiyatlarla)
        final userAsset =
            UserAssetModel.fromBuyingAsset(buyingAsset, currencyData);
        userAssets.add(userAsset);
        // Toplam değer ve yatırılan miktar hesaplama
        totalValue += userAsset.currentValue;
        totalInvested += (buyingAsset.quantity * buyingAsset.buyingPrice);
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
    );
  }

  // Grouped assets by type (for portfolio view)
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

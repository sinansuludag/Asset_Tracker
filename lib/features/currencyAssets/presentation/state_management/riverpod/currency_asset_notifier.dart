import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:asset_tracker/features/currencyAssets/domain/entities/currency_asset_entity.dart';
import 'package:asset_tracker/features/currencyAssets/domain/repository/i_currency_asset_repository.dart';

/// State tipi artık sadece loading gibi durumlar için değil, listeyi de içerecek şekilde genişletildi.
class CurrencyAssetState {
  final List<CurrencyAssetEntity?> assets;
  final bool isLoading;
  final bool hasError;

  CurrencyAssetState({
    required this.assets,
    this.isLoading = false,
    this.hasError = false,
  });

  factory CurrencyAssetState.initial() => CurrencyAssetState(assets: []);
}

class CurrencyAssetNotifier extends StateNotifier<CurrencyAssetState> {
  final ICurrencyAssetRepository _currencyAssetRepository;
  Stream<List<CurrencyAssetEntity?>>? _stream;

  CurrencyAssetNotifier(this._currencyAssetRepository)
      : super(CurrencyAssetState.initial());

  void listenCurrencyAssets(String userId) {
    state = CurrencyAssetState(assets: [], isLoading: true);
    _stream = _currencyAssetRepository.streamCurrencyAssets(userId);
    _stream!.listen(
      (assets) {
        state = CurrencyAssetState(assets: assets);
      },
      onError: (_) {
        state = CurrencyAssetState(assets: [], hasError: true);
      },
    );
  }

  Future<void> deleteCurrencyAsset(String assetId) async {
    state = CurrencyAssetState(assets: state.assets, isLoading: true);
    final result =
        await _currencyAssetRepository.deleteCurrencyAssetRepository(assetId);
    if (!result) {
      state = CurrencyAssetState(
          assets: state.assets, isLoading: false, hasError: true);
    }
  }

  Future<void> updateCurrencyAsset(CurrencyAssetEntity assetEntityModel) async {
    state = CurrencyAssetState(assets: state.assets, isLoading: true);
    final result = await _currencyAssetRepository
        .updateCurrencyAssetRepository(assetEntityModel);
    if (!result) {
      state = CurrencyAssetState(
          assets: state.assets, isLoading: false, hasError: true);
    }
  }

  double calculateTotalBuyPrice() {
    return state.assets.fold(0.0, (sum, asset) {
      if (asset == null) return sum;
      return sum + (asset.buyingPrice * asset.quantity);
    });
  }

  double calculateTotalCurrentValue(Map<String, double> currentPrices) {
    return state.assets.fold(0.0, (sum, asset) {
      if (asset == null) return sum;
      final currentPrice = currentPrices[asset.assetType];
      if (currentPrice == null) return sum;
      return sum + (currentPrice * asset.quantity);
    });
  }
}

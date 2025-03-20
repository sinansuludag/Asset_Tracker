import 'package:asset_tracker/features/currencyAssets/domain/entities/currency_asset_entity.dart';
import 'package:asset_tracker/features/currencyAssets/domain/repository/i_currency_asset_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum CurrencyAssetState { initial, loading, loaded, error }

class CurrencyAssetNotifier extends StateNotifier<CurrencyAssetState> {
  final ICurrencyAssetRepository _currencyAssetRepository;
  List<CurrencyAssetEntity?> _currencyAssetList = [];

  CurrencyAssetNotifier(this._currencyAssetRepository)
      : super(CurrencyAssetState.initial);

  List<CurrencyAssetEntity?> get currencyAssetList => _currencyAssetList;

  Future<void> getCurrencyAsset(String userId) async {
    state = CurrencyAssetState.loading;
    final result =
        await _currencyAssetRepository.getCurrencyAssetRepository(userId);
    state = (result.isNotEmpty)
        ? CurrencyAssetState.loaded
        : CurrencyAssetState.error;
    _currencyAssetList = result;
    state = CurrencyAssetState.loaded;
  }

  Future<void> deleteCurrencyAsset(String assetId) async {
    state = CurrencyAssetState.loading;
    final result =
        await _currencyAssetRepository.deleteCurrencyAssetRepository(assetId);
    if (result) {
      _currencyAssetList.removeWhere((asset) => asset?.id == assetId);
      state = CurrencyAssetState.loaded;
    } else {
      state = CurrencyAssetState.error;
    }
  }

  Future<void> updateCurrencyAsset(CurrencyAssetEntity assetEntityModel) async {
    state = CurrencyAssetState.loading;
    final result = await _currencyAssetRepository
        .updateCurrencyAssetRepository(assetEntityModel);
    state = result ? CurrencyAssetState.loaded : CurrencyAssetState.error;
  }
}

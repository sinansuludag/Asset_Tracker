import 'package:asset_tracker/features/currencyAssets/domain/entities/currency_asset_entity.dart';
import 'package:asset_tracker/features/currencyAssets/domain/repository/i_currency_asset_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum CurrencyAssetState { initial, loading, loaded, error }

class CurrencyAssetNotifier extends StateNotifier<CurrencyAssetState> {
  final ICurrencyAssetRepository _currencyAssetRepository;
  CurrencyAssetNotifier(this._currencyAssetRepository)
      : super(CurrencyAssetState.initial);

  Future<void> getCurrencyAsset(String assetId) async {
    state = CurrencyAssetState.loading;
    final result =
        await _currencyAssetRepository.getCurrencyAssetRepository(assetId);
    state =
        result != null ? CurrencyAssetState.loaded : CurrencyAssetState.error;
  }

  Future<void> updateCurrencyAsset(CurrencyAssetEntity assetEntityModel) async {
    state = CurrencyAssetState.loading;
    final result = await _currencyAssetRepository
        .updateCurrencyAssetRepository(assetEntityModel);
    state = result ? CurrencyAssetState.loaded : CurrencyAssetState.error;
  }

  Future<void> deleteCurrencyAsset(String assetId) async {
    state = CurrencyAssetState.loading;
    final result =
        await _currencyAssetRepository.deleteCurrencyAssetRepository(assetId);
    state = result ? CurrencyAssetState.loaded : CurrencyAssetState.error;
  }
}

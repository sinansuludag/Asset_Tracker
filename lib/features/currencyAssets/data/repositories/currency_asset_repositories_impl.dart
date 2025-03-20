import 'package:asset_tracker/features/currencyAssets/data/data_source/remote/abstract_currency_asset_service.dart';
import 'package:asset_tracker/features/currencyAssets/domain/entities/currency_asset_entity.dart';
import 'package:asset_tracker/features/currencyAssets/domain/repository/i_currency_asset_repository.dart';
import 'package:asset_tracker/features/home/domain/entities/asset_model.dart';

class CurrencyAssetRepositoriesImpl implements ICurrencyAssetRepository {
  final ICurrencyAssetService _currencyAssetService;

  CurrencyAssetRepositoriesImpl(this._currencyAssetService);

  @override
  Future<bool> deleteCurrencyAssetRepository(String assetId) async {
    final result = await _currencyAssetService.deleteCurrencyAsset(assetId);
    return result;
  }

  @override
  Future<List<CurrencyAssetEntity?>> getCurrencyAssetRepository(
      String userId) async {
    final result = await _currencyAssetService.getCurrencyAssets(userId);
    return result;
  }

  @override
  Future<bool> updateCurrencyAssetRepository(CurrencyAssetEntity asset) async {
    final result = await _currencyAssetService.updateCurrencyAsset(asset);
    return result;
  }
}

import 'package:asset_tracker/features/currencyAssets/domain/entities/currency_asset_entity.dart';

abstract class ICurrencyAssetService {
  Future<CurrencyAssetEntity?> getCurrencyAsset(String assetId);
  Future<bool> updateCurrencyAsset(CurrencyAssetEntity asset);
  Future<bool> deleteCurrencyAsset(String assetId);
}

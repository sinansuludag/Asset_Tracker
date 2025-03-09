import 'package:asset_tracker/features/currencyAssets/domain/entities/currency_asset_entity.dart';

abstract class ICurrencyAssetRepository {
  Future<CurrencyAssetEntity?> getCurrencyAssetRepository(String assetId);
  Future<bool> updateCurrencyAssetRepository(CurrencyAssetEntity asset);
  Future<bool> deleteCurrencyAssetRepository(String assetId);
}

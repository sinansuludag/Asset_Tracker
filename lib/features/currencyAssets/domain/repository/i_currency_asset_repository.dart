import 'package:asset_tracker/features/currencyAssets/domain/entities/currency_asset_entity.dart';

abstract class ICurrencyAssetRepository {
  Stream<List<CurrencyAssetEntity?>> streamCurrencyAssets(String userId);
  Future<bool> updateCurrencyAssetRepository(CurrencyAssetEntity asset);
  Future<bool> deleteCurrencyAssetRepository(String assetId);
}

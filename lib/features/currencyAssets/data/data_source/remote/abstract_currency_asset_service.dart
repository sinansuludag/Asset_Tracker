import 'package:asset_tracker/features/currencyAssets/domain/entities/currency_asset_entity.dart';

abstract class ICurrencyAssetService {
  Stream<List<CurrencyAssetEntity?>> streamCurrencyAssets(String userId);
  Future<bool> updateCurrencyAsset(CurrencyAssetEntity asset);
  Future<bool> deleteCurrencyAsset(String assetId);
}

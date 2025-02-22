import 'package:asset_tracker/features/buying_asset/domain/entities/asset_model.dart';

abstract class IAssetRepository {
  Future<AssetEntity?> getAssetRepository(String assetId);
  Future<bool> saveAssetRepository(AssetEntity asset);
  Future<bool> updateAssetRepository(AssetEntity asset);
  Future<bool> deleteAssetRepository(String assetId);
}

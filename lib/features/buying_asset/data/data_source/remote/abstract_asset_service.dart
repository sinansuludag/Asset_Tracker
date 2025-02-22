import 'package:asset_tracker/features/buying_asset/domain/entities/asset_model.dart';

abstract class IAssetService {
  Future<AssetEntity?> getAsset(String assetId);
  Future<bool> saveAsset(AssetEntity asset);
  Future<bool> updateAsset(AssetEntity asset);
  Future<bool> deleteAsset(String assetId);
}

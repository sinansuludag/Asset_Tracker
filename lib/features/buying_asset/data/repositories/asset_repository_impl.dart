import 'package:asset_tracker/features/buying_asset/data/data_source/remote/abstract_asset_service.dart';
import 'package:asset_tracker/features/buying_asset/domain/entities/asset_model.dart';
import 'package:asset_tracker/features/buying_asset/domain/repositories/asset_repository.dart';

class AssetRepositoryImpl implements IAssetRepository {
  final IAssetService _assetService;

  AssetRepositoryImpl(this._assetService);

  @override
  Future<bool> deleteAssetRepository(String assetId) {
    final result = _assetService.deleteAsset(assetId);
    return result;
  }

  @override
  Future<AssetEntity?> getAssetRepository(String assetId) {
    final result = _assetService.getAsset(assetId);
    return result;
  }

  @override
  Future<bool> saveAssetRepository(AssetEntity asset) {
    final result = _assetService.saveAsset(asset);
    return result;
  }

  @override
  Future<bool> updateAssetRepository(AssetEntity asset) {
    final result = _assetService.updateAsset(asset);
    return result;
  }
}

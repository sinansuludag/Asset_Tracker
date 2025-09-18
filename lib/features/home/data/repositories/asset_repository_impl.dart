import 'package:asset_tracker/features/home/data/datasources/firebase_store/abstract_asset_service.dart';
import 'package:asset_tracker/features/home/domain/entities/asset_entity.dart';
import 'package:asset_tracker/features/home/domain/repositories/i_asset_repository.dart';

/// Asset repository'nin concrete implementasyonu
/// Domain layer'daki interface'i implement eder
class AssetRepositoryImpl implements IAssetRepository {
  final IAssetService _assetService;

  AssetRepositoryImpl(this._assetService);

  @override
  Future<bool> saveAssetRepository(AssetEntity asset) async {
    try {
      return await _assetService.saveAsset(asset);
    } catch (e) {
      return false;
    }
  }

  @override
  Stream<List<AssetEntity>> getUserAssetsStreamRepository(String userId) {
    try {
      return _assetService.getUserAssetsStream(userId);
    } catch (e) {
      return [] as Stream<List<AssetEntity>>;
    }
  }

  @override
  Future<bool> deleteAssetRepository(String assetId) async {
    try {
      return await _assetService.deleteAsset(assetId);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> updateAssetRepository(AssetEntity asset) async {
    try {
      return await _assetService.updateAsset(asset);
    } catch (e) {
      return false;
    }
  }
}

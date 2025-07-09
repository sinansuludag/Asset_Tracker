import 'package:asset_tracker/features/home/data/datasources/firebase_store/abstract_asset_service.dart';
import 'package:asset_tracker/features/home/domain/entities/asset_model.dart';
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
      print('Repository error - saveAsset: $e');
      return false;
    }
  }

  @override
  Future<List<AssetEntity>> getUserAssetsRepository(String userId) async {
    try {
      return await _assetService.getUserAssets(userId);
    } catch (e) {
      print('Repository error - getUserAssets: $e');
      return [];
    }
  }

  @override
  Future<bool> deleteAssetRepository(String assetId) async {
    try {
      return await _assetService.deleteAsset(assetId);
    } catch (e) {
      print('Repository error - deleteAsset: $e');
      return false;
    }
  }

  @override
  Future<bool> updateAssetRepository(AssetEntity asset) async {
    try {
      return await _assetService.updateAsset(asset);
    } catch (e) {
      print('Repository error - updateAsset: $e');
      return false;
    }
  }
}

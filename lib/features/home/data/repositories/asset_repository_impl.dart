import 'package:asset_tracker/features/home/data/datasources/firebase_store/abstract_asset_service.dart';
import 'package:asset_tracker/features/home/domain/entities/asset_model.dart';
import 'package:asset_tracker/features/home/domain/repositories/i_asset_repository.dart';

/// Domain layer'daki interface'in concrete implementasyonu
class AssetRepositoryImpl implements IAssetRepository {
  final IAssetService _assetService;

  AssetRepositoryImpl(this._assetService);

  @override
  Future<bool> saveAssetRepository(AssetEntity asset) async {
    final result = await _assetService.saveAsset(asset);
    return result;
  }
}

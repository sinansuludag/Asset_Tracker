import 'package:asset_tracker/features/home/domain/entities/asset_model.dart';

/// Asset servisi için abstract sınıf - dependency injection için
abstract class IAssetService {
  /// Yeni varlık kaydetme
  Future<bool> saveAsset(AssetEntity asset);

  /// Kullanıcının varlıklarını getirme
  Future<List<AssetEntity>> getUserAssets(String userId);

  /// Varlık silme
  Future<bool> deleteAsset(String assetId);

  /// Varlık güncelleme
  Future<bool> updateAsset(AssetEntity asset);
}

import 'package:asset_tracker/features/home/domain/entities/asset_model.dart';

/// Asset repository interface - business logic'in data layer'dan bağımsız olması için
/// Clean Architecture pattern gereği domain layer'da interface tanımlanır
abstract class IAssetRepository {
  /// Yeni varlık kaydetme
  Future<bool> saveAssetRepository(AssetEntity asset);

  /// Kullanıcının varlıklarını getirme
  Stream<List<AssetEntity>> getUserAssetsStreamRepository(String userId);

  /// Varlık silme
  Future<bool> deleteAssetRepository(String assetId);

  /// Varlık güncelleme
  Future<bool> updateAssetRepository(AssetEntity asset);
}

import 'package:asset_tracker/features/home/data/datasources/firebase_store/allowed_assets_service.dart';
import 'package:asset_tracker/features/home/data/models/asset_definition_model.dart';
import 'package:asset_tracker/features/home/domain/entities/asset_type_enum.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// İzinli varlıklar için Riverpod provider'ları

/// Tüm izinli varlıklar
final allowedAssetsProvider = Provider<List<AssetDefinitionModel>>((ref) {
  return AllowedAssetsService.getAllowedAssets();
});

/// Ana sayfada gösterilecek varlıklar (isVisible: true)
final visibleAssetsProvider = Provider<List<AssetDefinitionModel>>((ref) {
  return AllowedAssetsService.getVisibleAssets();
});

/// Kullanıcının ekleyebileceği varlıklar (isSelectable: true)
/// EURUSD ve ONS burada olmayacak!
final selectableAssetsProvider = Provider<List<AssetDefinitionModel>>((ref) {
  return AllowedAssetsService.getSelectableAssets();
});

/// Türe göre varlıklar (altın, döviz vs.)
final assetsByTypeProvider =
    Provider.family<List<AssetDefinitionModel>, AssetType>((ref, type) {
  return AllowedAssetsService.getAssetsByType(type);
});

/// Ana sayfada gösterilecek öncelikli varlıklar (piyasa kartları için)
final priorityAssetsProvider = Provider<List<AssetDefinitionModel>>((ref) {
  return AllowedAssetsService.getPriorityAssets();
});

/// Bilezik ayar seçenekleri (issue gereksinimi)
final braceletAyarOptionsProvider = Provider<List<String>>((ref) {
  return AllowedAssetsService.getBraceletAyarOptions();
});

/// Belirli bir varlığın eklenip eklenemeyeceğini kontrol
final canAddAssetProvider = Provider.family<bool, String>((ref, assetId) {
  return AllowedAssetsService.canAddAsset(assetId);
});

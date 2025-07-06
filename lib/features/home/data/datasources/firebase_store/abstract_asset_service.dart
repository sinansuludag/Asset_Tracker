import 'package:asset_tracker/features/home/domain/entities/asset_model.dart';

/// Bu dosya, varlık kaydetme işlemleri için soyut sınıf tanımlar
abstract class IAssetService {
  Future<bool> saveAsset(AssetEntity asset);
}

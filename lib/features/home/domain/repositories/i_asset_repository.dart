import 'package:asset_tracker/features/home/domain/entities/asset_model.dart';

abstract class IAssetRepository {
  Future<bool> saveAssetRepository(AssetEntity asset);
}

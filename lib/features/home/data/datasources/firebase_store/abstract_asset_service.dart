import 'package:asset_tracker/features/home/domain/entities/asset_model.dart';

abstract class IAssetService {
  Future<bool> saveAsset(AssetEntity asset);
}

import 'package:asset_tracker/features/home/domain/entities/asset_model.dart';

/// Repository interface - business logic'in data layer'dan bağımsız olması iç
abstract class IAssetRepository {
  Future<bool> saveAssetRepository(AssetEntity asset);
}

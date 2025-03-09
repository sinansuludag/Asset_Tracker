import 'package:asset_tracker/features/home/domain/entities/asset_model.dart';
import 'package:asset_tracker/features/home/domain/repositories/i_asset_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum BuyingAssetState { initial, loading, loaded, error }

class BuyingAssetNotifier extends StateNotifier<BuyingAssetState> {
  final IAssetRepository _assetRepository;
  BuyingAssetNotifier(this._assetRepository) : super(BuyingAssetState.initial);

  Future<void> saveBuyingAsset(AssetEntity assetEntityModel) async {
    state = BuyingAssetState.loading;
    final result = await _assetRepository.saveAssetRepository(assetEntityModel);
    state = result ? BuyingAssetState.loaded : BuyingAssetState.error;
  }
}

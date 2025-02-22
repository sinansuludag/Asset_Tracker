import 'package:asset_tracker/features/buying_asset/domain/entities/asset_model.dart';
import 'package:asset_tracker/features/buying_asset/domain/repositories/asset_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum BuyingAssetState { initial, loading, loaded, error }

class BuyingAssetNotifier extends StateNotifier<BuyingAssetState> {
  final IAssetRepository _assetRepository;
  BuyingAssetNotifier(this._assetRepository) : super(BuyingAssetState.initial);

  Future<void> getBuyingAsset(String assetId) async {
    state = BuyingAssetState.loading;
    final result = await _assetRepository.getAssetRepository(assetId);
    state = result != null ? BuyingAssetState.loaded : BuyingAssetState.error;
  }

  Future<void> saveBuyingAsset(AssetEntity assetEntityModel) async {
    state = BuyingAssetState.loading;
    final result = await _assetRepository.saveAssetRepository(assetEntityModel);
    state = result ? BuyingAssetState.loaded : BuyingAssetState.error;
  }

  Future<void> updateBuyingAsset(AssetEntity assetEntityModel) async {
    state = BuyingAssetState.loading;
    final result =
        await _assetRepository.updateAssetRepository(assetEntityModel);
    state = result ? BuyingAssetState.loaded : BuyingAssetState.error;
  }

  Future<void> deleteBuyingAsset(String assetId) async {
    state = BuyingAssetState.loading;
    final result = await _assetRepository.deleteAssetRepository(assetId);
    state = result ? BuyingAssetState.loaded : BuyingAssetState.error;
  }
}

import 'package:asset_tracker/features/buying_asset/data/data_source/remote/abstract_asset_service.dart';
import 'package:asset_tracker/features/buying_asset/data/data_source/remote/asset_firestore_service_impl.dart';
import 'package:asset_tracker/features/buying_asset/data/repositories/asset_repository_impl.dart';
import 'package:asset_tracker/features/buying_asset/presentation/state_management/buying_asset_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _buyingAssetService = Provider<IAssetService>((ref) {
  return AssetFirestoreServiceImpl(FirebaseFirestore.instance);
});

final buyingAssetProvider =
    StateNotifierProvider<BuyingAssetNotifier, BuyingAssetState>(
  (ref) {
    final assetService = ref.watch(_buyingAssetService);
    final assetRepository = AssetRepositoryImpl(assetService);
    return BuyingAssetNotifier(assetRepository);
  },
);

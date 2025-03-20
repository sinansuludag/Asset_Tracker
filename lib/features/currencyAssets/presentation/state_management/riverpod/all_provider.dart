import 'package:asset_tracker/features/currencyAssets/data/data_source/remote/abstract_currency_asset_service.dart';
import 'package:asset_tracker/features/currencyAssets/data/data_source/remote/currency_asset_firestore_service_impl.dart';
import 'package:asset_tracker/features/currencyAssets/data/repositories/currency_asset_repositories_impl.dart';
import 'package:asset_tracker/features/currencyAssets/presentation/state_management/riverpod/currency_asset_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _currencyAssetService = Provider<ICurrencyAssetService>((ref) {
  return CurrencyAssetFirestoreServiceImpl(FirebaseFirestore.instance);
});

final currencyAssetProvider =
    StateNotifierProvider<CurrencyAssetNotifier, CurrencyAssetState>(
  (ref) {
    final currencyAssetService = ref.watch(_currencyAssetService);
    final currencyAssetRepository =
        CurrencyAssetRepositoriesImpl(currencyAssetService);
    return CurrencyAssetNotifier(currencyAssetRepository);
  },
);

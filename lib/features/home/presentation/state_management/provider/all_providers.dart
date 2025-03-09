import 'package:asset_tracker/features/home/data/datasources/firebase_store/abstract_asset_service.dart';
import 'package:asset_tracker/features/home/data/datasources/firebase_store/asset_firestore_service_impl.dart';
import 'package:asset_tracker/features/home/data/repositories/asset_repository_impl.dart';
import 'package:asset_tracker/features/home/data/datasources/web_socket/i_currency_websocket_service.dart';
import 'package:asset_tracker/features/home/data/models/curreny_response_model.dart';
import 'package:asset_tracker/features/home/domain/repositories/i_currency_repository.dart';
import 'package:asset_tracker/features/home/presentation/state_management/provider/buying_asset_notifier.dart';
import 'package:asset_tracker/features/home/presentation/state_management/provider/currency_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:asset_tracker/features/home/data/repositories/currency_repository.dart';
import 'package:asset_tracker/features/home/data/datasources/web_socket/currency_web_socket_service.dart';

final currencyWebSocketServiceProvider =
    Provider<ICurrencyWebSocketService>((ref) {
  return CurrencyWebSocketServiceImpl(dotenv.env['WEBSOCKET_URL'] ?? '');
});

final currencyRepositoryProvider = Provider<ICurrencyRepository>((ref) {
  final webSocketService = ref.read(currencyWebSocketServiceProvider);
  return CurrencyRepositoryImpl(webSocketService);
});

final currencyNotifierProvider =
    StateNotifierProvider<CurrencyNotifier, List<CurrencyResponse>>((ref) {
  final repository = ref.read(currencyRepositoryProvider);
  return CurrencyNotifier(repository);
});

//////////////////////
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

final assetAmountProvider = StateProvider<double>((ref) {
  return 0.0;
});

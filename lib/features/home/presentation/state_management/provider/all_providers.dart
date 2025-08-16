import 'package:asset_tracker/features/home/data/datasources/firebase_store/abstract_asset_service.dart';
import 'package:asset_tracker/features/home/data/datasources/firebase_store/asset_firestore_service_impl.dart';
import 'package:asset_tracker/features/home/data/models/asset_summary_model.dart';
import 'package:asset_tracker/features/home/data/models/asset_transaction_model.dart';
import 'package:asset_tracker/features/home/data/repositories/asset_repository_impl.dart';
import 'package:asset_tracker/features/home/data/datasources/web_socket/i_currency_websocket_service.dart';
import 'package:asset_tracker/features/home/data/models/curreny_response_model.dart';
import 'package:asset_tracker/features/home/domain/entities/asset_entity.dart';
import 'package:asset_tracker/features/home/domain/repositories/i_asset_repository.dart';
import 'package:asset_tracker/features/home/domain/repositories/i_currency_repository.dart';
import 'package:asset_tracker/features/home/presentation/state_management/provider/asset_notifier.dart';
import 'package:asset_tracker/features/home/presentation/state_management/provider/currency_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:asset_tracker/features/home/data/repositories/currency_repository.dart';
import 'package:asset_tracker/features/home/data/datasources/web_socket/currency_web_socket_service.dart';

/// Canlı veri yenileme interval’i (CurrencyNotifier içinde kullanılıyor)
final refreshIntervalProvider =
    StateProvider<Duration>((ref) => const Duration(seconds: 3));

/// WebSocket Service Provider
final _currencyWebSocketServiceProvider =
    Provider<ICurrencyWebSocketService>((ref) {
  final websocketUrl = dotenv.env['WEBSOCKET_URL'] ?? 'wss://default-url.com';
  return CurrencyWebSocketServiceImpl(websocketUrl);
});

/// Currency Repository Provider
final _currencyRepositoryProvider = Provider<ICurrencyRepository>((ref) {
  final webSocketService = ref.watch(_currencyWebSocketServiceProvider);
  return CurrencyRepositoryImpl(webSocketService);
});

/// Currency Notifier Provider
final currencyNotifierProvider =
    StateNotifierProvider<CurrencyNotifier, List<CurrencyResponse>>((ref) {
  final repository = ref.watch(_currencyRepositoryProvider);
  return CurrencyNotifier(repository, ref);
});

/// Asset Service Provider
final _assetServiceProvider = Provider<IAssetService>((ref) {
  return AssetFirestoreServiceImpl(
    FirebaseFirestore.instance,
    FirebaseAuth.instance,
  );
});

/// Asset Repository Provider
final _assetRepositoryProvider = Provider<IAssetRepository>((ref) {
  final assetService = ref.watch(_assetServiceProvider);
  return AssetRepositoryImpl(assetService);
});

/// Firebase Auth Provider
final _firebaseAuthProvider =
    Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

/// Asset Notifier Provider
final assetNotifierProvider =
    StateNotifierProvider<AssetNotifier, AssetUiState>((ref) {
  final repo = ref.watch(_assetRepositoryProvider);
  final auth = ref.watch(_firebaseAuthProvider);
  return AssetNotifier(repo, auth);
});

/// Kullanıcının varlıklarını stream ile izleme
final userAssetsStreamProvider =
    StreamProvider.autoDispose<List<AssetEntity>>((ref) {
  final auth = ref.watch(_firebaseAuthProvider);
  final repo = ref.watch(_assetRepositoryProvider);
  final user = auth.currentUser;
  if (user == null) return const Stream.empty();
  return repo.getUserAssetsStreamRepository(user.uid);
});

/// Asset Summary Stream
final assetSummaryStreamProvider =
    StreamProvider.autoDispose<List<AssetSummaryModel>>((ref) {
  final auth = ref.watch(_firebaseAuthProvider);
  final user = auth.currentUser;
  if (user == null) return const Stream.empty();

  return FirebaseFirestore.instance
      .collection('asset_summary')
      .where('userId', isEqualTo: user.uid)
      .orderBy('lastUpdated', descending: true)
      .snapshots()
      .map((s) =>
          s.docs.map((d) => AssetSummaryModel.fromJson(d.data())).toList());
});

/// Belirli asset işlemleri
final assetTransactionsProvider = StreamProvider.autoDispose
    .family<List<AssetTransactionModel>, Map<String, String>>((ref, params) {
  final auth = ref.watch(_firebaseAuthProvider);
  final user = auth.currentUser;
  if (user == null) return const Stream.empty();

  final assetType = params['assetType'] ?? '';
  final assetSubType = params['assetSubType'] ?? 'normal';

  return FirebaseFirestore.instance
      .collection('asset_transactions')
      .where('userId', isEqualTo: user.uid)
      .where('assetType', isEqualTo: assetType)
      .where('assetSubType', isEqualTo: assetSubType)
      .orderBy('transactionNumber', descending: false)
      .snapshots()
      .map((s) =>
          s.docs.map((d) => AssetTransactionModel.fromJson(d.data())).toList());
});

/// Currency → Asset senkron link’i
/// CurrencyNotifier'dan her yeni response geldiğinde AssetNotifier’a push eder.
final currencyToAssetLinkProvider = Provider<void>((ref) {
  ref.listen<List<CurrencyResponse>>(currencyNotifierProvider, (prev, next) {
    if (next.isNotEmpty) {
      ref.read(assetNotifierProvider.notifier).updateCurrencyData(next.first);
    }
  });
});

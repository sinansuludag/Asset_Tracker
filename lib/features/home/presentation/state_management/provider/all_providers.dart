import 'package:asset_tracker/features/home/data/datasources/firebase_store/abstract_asset_service.dart';
import 'package:asset_tracker/features/home/data/datasources/firebase_store/asset_firestore_service_impl.dart';
import 'package:asset_tracker/features/home/data/datasources/firebase_store/enhanced_portfolio_service.dart';
import 'package:asset_tracker/features/home/data/repositories/asset_repository_impl.dart';
import 'package:asset_tracker/features/home/data/datasources/web_socket/i_currency_websocket_service.dart';
import 'package:asset_tracker/features/home/data/models/curreny_response_model.dart';
import 'package:asset_tracker/features/home/data/models/portfolio_model.dart';
import 'package:asset_tracker/features/home/domain/repositories/i_asset_repository.dart';
import 'package:asset_tracker/features/home/domain/repositories/i_currency_repository.dart';
import 'package:asset_tracker/features/home/presentation/state_management/provider/buying_asset_notifier.dart';
import 'package:asset_tracker/features/home/presentation/state_management/provider/currency_notifier.dart';
import 'package:asset_tracker/features/home/presentation/state_management/provider/enhanced_portfolio_provider.dart';
import 'package:asset_tracker/features/home/presentation/state_management/provider/portfolio_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:asset_tracker/features/home/data/repositories/currency_repository.dart';
import 'package:asset_tracker/features/home/data/datasources/web_socket/currency_web_socket_service.dart';

/// Tüm home feature provider'larını merkezi yönetim
/// Dependency injection için gerekli provider'lar

// ===== WebSocket Service Provider =====
final currencyWebSocketServiceProvider =
    Provider<ICurrencyWebSocketService>((ref) {
  // .env dosyasından WebSocket URL'i al
  final websocketUrl = dotenv.env['WEBSOCKET_URL'] ?? 'wss://default-url.com';
  return CurrencyWebSocketServiceImpl(websocketUrl);
});

// ===== Currency Repository Provider =====
final currencyRepositoryProvider = Provider<ICurrencyRepository>((ref) {
  final webSocketService = ref.watch(currencyWebSocketServiceProvider);
  return CurrencyRepositoryImpl(webSocketService);
});

// ===== Currency Notifier Provider =====
final currencyNotifierProvider =
    StateNotifierProvider<CurrencyNotifier, List<CurrencyResponse>>((ref) {
  final repository = ref.watch(currencyRepositoryProvider);
  return CurrencyNotifier(repository, ref);
});

// ===== Asset Service Provider =====
final assetServiceProvider = Provider<IAssetService>((ref) {
  return AssetFirestoreServiceImpl(
    FirebaseFirestore.instance,
    FirebaseAuth.instance,
  );
});

// ===== Asset Repository Provider =====
final assetRepositoryProvider = Provider<IAssetRepository>((ref) {
  final assetService = ref.watch(assetServiceProvider);
  return AssetRepositoryImpl(assetService);
});

// ===== Buying Asset Notifier Provider =====
final buyingAssetProvider =
    StateNotifierProvider<BuyingAssetNotifier, BuyingAssetState>((ref) {
  final assetRepository = ref.watch(assetRepositoryProvider);
  return BuyingAssetNotifier(assetRepository);
});

// ===== Portfolio Provider =====
final userPortfolioProvider =
    StateNotifierProvider<PortfolioNotifier, PortfolioModel>((ref) {
  return PortfolioNotifier(ref);
});

// ===== Asset Amount Provider (Dialog için) =====
final assetAmountProvider = StateProvider<double>((ref) {
  return 0.0;
});

// ===== Current User Provider =====
final currentUserProvider = Provider<User?>((ref) {
  return FirebaseAuth.instance.currentUser;
});

/// Enhanced Portfolio Provider (Eskisinin yerini alır)
final enhancedPortfolioProvider =
    StateNotifierProvider<EnhancedPortfolioNotifier, PortfolioModel>((ref) {
  return EnhancedPortfolioNotifier(ref);
});

/// Enhanced Portfolio Service Provider
final enhancedPortfolioServiceProvider =
    Provider<EnhancedPortfolioService>((ref) {
  return EnhancedPortfolioService(
    FirebaseFirestore.instance,
    FirebaseAuth.instance,
  );
});

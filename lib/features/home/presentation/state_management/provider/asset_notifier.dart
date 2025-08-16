import 'dart:async';
import 'package:asset_tracker/features/home/domain/entities/asset_entity.dart';
import 'package:asset_tracker/features/home/domain/repositories/i_asset_repository.dart';
import 'package:asset_tracker/features/home/data/models/buying_asset_model.dart';
import 'package:asset_tracker/features/home/data/models/curreny_response_model.dart';
import 'package:asset_tracker/features/home/data/models/user_asset_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Varlık işlemleri için state'ler
enum BuyingAssetState {
  initial,
  loading,
  loaded,
  error,
}

/// UI’nin ihtiyacı olan tüm verileri taşıyan zengin state
class AssetUiState {
  final BuyingAssetState status;
  final String? lastError;
  final List<AssetEntity> rawAssets;
  final List<UserAssetModel> userAssets;

  // Türetilmiş (hesaplanan) alanlar:
  double get totalInvestedAmount =>
      userAssets.fold(0.0, (sum, u) => sum + (u.totalInvestment));

  double get totalValue =>
      userAssets.fold(0.0, (sum, u) => sum + u.currentValue);

  double get totalChange => userAssets.fold(0.0, (sum, u) => sum + u.change);

  double get changePercentage => totalInvestedAmount <= 0
      ? 0.0
      : (totalChange / totalInvestedAmount) * 100;

  const AssetUiState({
    required this.status,
    required this.lastError,
    required this.rawAssets,
    required this.userAssets,
  });

  factory AssetUiState.initial() => const AssetUiState(
        status: BuyingAssetState.initial,
        lastError: null,
        rawAssets: <AssetEntity>[],
        userAssets: <UserAssetModel>[],
      );

  AssetUiState copyWith({
    BuyingAssetState? status,
    String? lastError,
    List<AssetEntity>? rawAssets,
    List<UserAssetModel>? userAssets,
  }) {
    return AssetUiState(
      status: status ?? this.status,
      lastError: lastError,
      rawAssets: rawAssets ?? this.rawAssets,
      userAssets: userAssets ?? this.userAssets,
    );
  }
}

/// UserAsset hesaplamalarını yapan ve stream’i yöneten Notifier
class AssetNotifier extends StateNotifier<AssetUiState> {
  final IAssetRepository _assetRepository;
  final FirebaseAuth _auth;

  StreamSubscription<List<AssetEntity>>? _assetsSubscription;
  StreamSubscription<User?>? _authSubscription;
  bool _isListening = false;

  CurrencyResponse? _currentCurrencyData;

  AssetNotifier(this._assetRepository, this._auth)
      : super(AssetUiState.initial()) {
    _initializeAssetListening();
  }

  /// Kur verisi güncellenince UserAsset'leri yeniden kur
  void updateCurrencyData(CurrencyResponse currencyData) {
    _currentCurrencyData = currencyData;
    _rebuildUserAssets();
  }

  /// Ham varlıklardan UserAsset üret
  void _rebuildUserAssets() {
    if (_currentCurrencyData == null) {
      state = state.copyWith(userAssets: []);
      return;
    }

    // Artık özet tablosundan gelen veriler BuyingAssetModel olarak geliyor
    // asset_firestore_service_impl.dart'ta AssetSummaryModel → BuyingAssetModel dönüşümü yapılıyor
    final userAssets = state.rawAssets
        .whereType<BuyingAssetModel>()
        .map((buyingAsset) {
          final currencyData =
              _currentCurrencyData?.currencies[buyingAsset.assetType];
          if (currencyData == null) return null;

          // ✅ YENİ: transactionCount bilgisini ekle
          if (buyingAsset.isBracelet) {
            return _createUserAssetForBracelet(buyingAsset, currencyData);
          } else {
            return UserAssetModel.fromBuyingAsset(buyingAsset, currencyData);
          }
        })
        .whereType<UserAssetModel>()
        .toList();

    state = state.copyWith(userAssets: userAssets);
  }

  UserAssetModel? _createUserAssetFromBuyingAsset(
      BuyingAssetModel buyingAsset) {
    final currencyData =
        _currentCurrencyData?.currencies[buyingAsset.assetType];
    if (currencyData == null) {
      // İlgili kur verisi yoksa bu varlığı atla
      return null;
    }

    if (buyingAsset.isBracelet) {
      return _createUserAssetForBracelet(buyingAsset, currencyData);
    } else {
      return UserAssetModel.fromBuyingAsset(buyingAsset, currencyData);
    }
  }

  /// Bilezik için özel hesaplama
  UserAssetModel _createUserAssetForBracelet(
      BuyingAssetModel buyingAsset, dynamic currencyData) {
    final ayar14Data = _currentCurrencyData?.currencies['AYAR14'];
    final ayar22Data = _currentCurrencyData?.currencies['AYAR22'];

    double currentValue;
    double currentPrice;

    if (ayar14Data != null && ayar22Data != null) {
      final ayar14Price = ayar14Data.buying ?? 0.0;
      final ayar22Price = ayar22Data.buying ?? 0.0;

      currentValue =
          buyingAsset.calculateBraceletValue(ayar14Price, ayar22Price);

      if ((buyingAsset.gramWeight ?? 0) > 0) {
        currentPrice = currentValue / buyingAsset.gramWeight!;
      } else {
        currentPrice = buyingAsset.buyingPrice;
      }
    } else {
      // Fallback
      currentValue = buyingAsset.quantity * buyingAsset.buyingPrice;
      currentPrice = buyingAsset.buyingPrice;
    }

    final totalInvested = buyingAsset.totalInvestment;
    final change = currentValue - totalInvested;
    final changePercentage =
        totalInvested > 0 ? (change / totalInvested) * 100 : 0.0;

    return UserAssetModel(
      id: buyingAsset.id,
      assetType: buyingAsset.assetType,
      displayName: buyingAsset.displayName,
      quantity: buyingAsset.quantity,
      averagePrice: buyingAsset.buyingPrice,
      totalInvestment: buyingAsset.totalInvestment,
      currentPrice: currentPrice,
      currentValue: currentValue,
      change: change,
      changePercentage: changePercentage,
      icon: _getBraceletIcon(buyingAsset),
      lastUpdated: DateTime.now(),
    );
  }

  String _getBraceletIcon(BuyingAssetModel asset) {
    if (asset.ayarType == '14') return '14K';
    if (asset.ayarType == '22') return '22K';
    return '📿';
  }

  /// Auth’a göre varlık dinlemeyi yönet
  void _initializeAssetListening() {
    final user = _auth.currentUser;
    if (user != null) {
      startListeningToAssets(user.uid);
    }

    _authSubscription = _auth.authStateChanges().listen((user) {
      if (user != null) {
        startListeningToAssets(user.uid);
      } else {
        stopListeningToAssets();
      }
    });
  }

  /// Kullanıcının varlıklarını stream ile dinle
  void startListeningToAssets(String userId) {
    if (_isListening) {
      stopListeningToAssets();
    }

    state = state.copyWith(status: BuyingAssetState.loading, lastError: null);

    _assetsSubscription =
        _assetRepository.getUserAssetsStreamRepository(userId).listen(
      (assets) {
        // 1) Ham varlıkları state’e koy
        state = state.copyWith(rawAssets: assets);

        // 2) UserAsset’leri kur verisiyle yeniden oluştur
        _rebuildUserAssets();

        // 3) Yükleme bitti
        state = state.copyWith(status: BuyingAssetState.loaded);
      },
      onError: (error) {
        state = state.copyWith(
          status: BuyingAssetState.error,
          lastError: error.toString(),
        );
      },
    );

    _isListening = true;
  }

  /// Dinlemeyi durdur
  void stopListeningToAssets() {
    _assetsSubscription?.cancel();
    _assetsSubscription = null;
    _isListening = false;
    state = state.copyWith(rawAssets: [], userAssets: []);
  }

  /// Yeni varlık ekleme
  Future<void> saveBuyingAsset(AssetEntity assetEntityModel) async {
    state = state.copyWith(status: BuyingAssetState.loading, lastError: null);
    try {
      final ok = await _assetRepository.saveAssetRepository(assetEntityModel);
      state = state.copyWith(
        status: ok ? BuyingAssetState.loaded : BuyingAssetState.error,
        lastError: ok ? null : 'Varlık eklenirken bir hata oluştu',
      );
    } catch (e) {
      state = state.copyWith(status: BuyingAssetState.error, lastError: '$e');
    }
  }

  /// Varlık güncelleme
  Future<void> updateAsset(AssetEntity assetEntityModel) async {
    state = state.copyWith(status: BuyingAssetState.loading, lastError: null);
    try {
      final ok = await _assetRepository.updateAssetRepository(assetEntityModel);
      state = state.copyWith(
        status: ok ? BuyingAssetState.loaded : BuyingAssetState.error,
        lastError: ok ? null : 'Varlık güncellenirken bir hata oluştu',
      );
    } catch (e) {
      state = state.copyWith(status: BuyingAssetState.error, lastError: '$e');
    }
  }

  /// Varlık silme
  Future<void> deleteAsset(String assetId) async {
    // NOT: Artık özet tablosundan silme yerine,
    // belirli bir transaction'ı silme mantığı eklenebilir
    // Şimdilik aynen bırakıyoruz
    state = state.copyWith(status: BuyingAssetState.loading, lastError: null);
    try {
      final ok = await _assetRepository.deleteAssetRepository(assetId);
      state = state.copyWith(
        status: ok ? BuyingAssetState.loaded : BuyingAssetState.error,
        lastError: ok ? null : 'Varlık silinirken bir hata oluştu',
      );
    } catch (e) {
      state = state.copyWith(status: BuyingAssetState.error, lastError: '$e');
    }
  }

  /// Manuel yenileme
  Future<void> refreshAssets() async {
    final user = _auth.currentUser;
    if (user != null) {
      stopListeningToAssets();
      startListeningToAssets(user.uid);
    }
  }

  void reset() {
    state = AssetUiState.initial();
  }

  @override
  void dispose() {
    _assetsSubscription?.cancel();
    _authSubscription?.cancel();
    super.dispose();
  }
}

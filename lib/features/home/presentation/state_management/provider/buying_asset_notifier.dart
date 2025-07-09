import 'package:asset_tracker/features/home/domain/entities/asset_model.dart';
import 'package:asset_tracker/features/home/domain/repositories/i_asset_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Varlık ekleme durumları
enum BuyingAssetState {
  initial, // Başlangıç
  loading, // Yükleniyor
  loaded, // Başarıyla eklendi
  error // Hata oluştu
}

/// Varlık ekleme işlemlerini yöneten StateNotifier
class BuyingAssetNotifier extends StateNotifier<BuyingAssetState> {
  final IAssetRepository _assetRepository;
  String? _lastError; // Son hata mesajı

  BuyingAssetNotifier(this._assetRepository) : super(BuyingAssetState.initial);

  /// Getter for last error
  String? get lastError => _lastError;

  /// Yeni varlık ekleme
  Future<void> saveBuyingAsset(AssetEntity assetEntityModel) async {
    state = BuyingAssetState.loading;
    _lastError = null;

    try {
      final result =
          await _assetRepository.saveAssetRepository(assetEntityModel);

      if (result) {
        state = BuyingAssetState.loaded;
      } else {
        state = BuyingAssetState.error;
        _lastError = 'Varlık eklenirken bir hata oluştu';
      }
    } catch (e) {
      state = BuyingAssetState.error;
      _lastError = e.toString();
    }
  }

  /// Durumu sıfırlama
  void reset() {
    state = BuyingAssetState.initial;
    _lastError = null;
  }
}

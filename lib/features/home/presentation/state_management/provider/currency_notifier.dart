import 'dart:async';
import 'package:asset_tracker/core/extensions/currency_code_extension.dart';
import 'package:asset_tracker/core/riverpod/all_riverpod.dart';
import 'package:asset_tracker/features/home/data/models/currency_data_model.dart';
import 'package:asset_tracker/features/home/data/models/curreny_response_model.dart';
import 'package:asset_tracker/features/home/domain/repositories/i_currency_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Haremaltın WebSocket'inden gelen döviz kurlarını yöneten StateNotifier
class CurrencyNotifier extends StateNotifier<List<CurrencyResponse>> {
  final ICurrencyRepository _repository;
  final Ref _ref;

  String _searchQuery = '';
  CurrencyResponse? _originalResponse;
  bool isConnected = true;
  DateTime _lastUpdate = DateTime.fromMillisecondsSinceEpoch(0);
  late StreamSubscription<CurrencyResponse> _subscription;

  CurrencyNotifier(this._repository, this._ref) : super([]) {
    _listenToCurrencyUpdates();
  }

  /// Tam currency response'u getirme
  CurrencyResponse? get fullCurrencyResponse => _originalResponse;

  /// WebSocket'den gelen verileri dinleme
  void _listenToCurrencyUpdates() {
    _subscription = _repository.getCurrencyUpdates().listen(
      (currencyResponse) {
        final now = DateTime.now();
        final difference = now.difference(_lastUpdate);
        final interval = _ref.read(refreshIntervalProvider);

        // Manuel modda otomatik güncelleme yapma
        if (interval == Duration.zero) return;

        // Belirlenen interval'da güncelle
        if (difference >= interval) {
          _originalResponse = currencyResponse;
          _filterCurrencies();
          _lastUpdate = now;
          isConnected = true;
        }
      },
      onError: (error) {
        print('❌ WebSocket Error: $error');
        isConnected = false;
      },
      onDone: () {
        print('⚠️ WebSocket Stream closed');
        isConnected = false;
        if (!isConnected) _usePreviousData();
      },
    );
  }

  /// Bağlantı koptuğunda önceki veriyi kullanma
  void _usePreviousData() {
    if (_originalResponse != null) {
      state = [_originalResponse!];
    } else {
      state = [];
    }
  }

  /// Arama query'sini güncelleme
  void updateSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    _filterCurrencies();
  }

  /// Varlıkları filtreleme (arama + izinli varlıklar)
  void _filterCurrencies() {
    if (_originalResponse == null) return;

    final allCurrencies = _originalResponse!.currencies.values.toList();

    if (_searchQuery.isEmpty) {
      // Arama yoksa tüm veriyi göster
      state = [_originalResponse!];
    } else {
      // Arama varsa filtrele
      final filtered = allCurrencies
          .where((currency) => currency.code!
              .getCurrencyName()
              .toLowerCase()
              .contains(_searchQuery))
          .toList();

      // Filtrelenmiş veriyle yeni response oluştur
      state = [
        _originalResponse!.copyWith(
          currencies: {for (var currency in filtered) currency.code!: currency},
        )
      ];
    }
  }

  /// Filtrelenmiş currency listesi
  List<CurrencyData> get filteredCurrencies {
    if (state.isEmpty) return [];
    return state.first.currencies.values.toList();
  }

  /// Manuel yenileme
  void manualRefresh() async {
    try {
      final response = await _repository.getCurrencyUpdates().first;
      _originalResponse = response;
      _filterCurrencies();
      state = [_originalResponse!];
      _lastUpdate = DateTime.now();
    } catch (e) {
      print('❌ Manual refresh error: $e');
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    _repository.disconnect();
    super.dispose();
  }
}

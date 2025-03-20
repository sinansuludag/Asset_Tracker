import 'dart:async';

import 'package:asset_tracker/core/extensions/currency_code_extension.dart';
import 'package:asset_tracker/features/home/data/models/currency_data_model.dart';
import 'package:asset_tracker/features/home/data/models/curreny_response_model.dart';
import 'package:asset_tracker/features/home/domain/repositories/i_currency_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CurrencyNotifier extends StateNotifier<List<CurrencyResponse>> {
  final ICurrencyRepository _repository;
  String _searchQuery = ''; // Arama filtresi
  CurrencyResponse? _originalResponse; // Orijinal veriyi sakla
  Timer? _debounceTimer; // Debounce için timer
  bool isConnected = true; // Bağlantı durumu

  CurrencyNotifier(this._repository) : super([]) {
    _listenToCurrencyUpdates();
  }

  // Anlık veri güncellemeleri
  void _listenToCurrencyUpdates() {
    _repository.getCurrencyUpdates().listen(
      (currencyResponse) {
        _originalResponse = currencyResponse; // Orijinal veriyi kaydet
        _debounceUpdate(); // Gelen yeni veriye göre filtreleme işlemi yap
        isConnected = true;
      },
      onError: (error) {
        print('Error: $error');
      },
      onDone: () {
        // Akış tamamlandığında yapılacak işlemler
        print('Stream closed');
        if (!isConnected) {
          // Bağlantı kaybolduysa, önceki veriyi kullan
          _usePreviousData();
        }
      },
    );
  }

  void _usePreviousData() {
    if (_originalResponse != null) {
      state = [_originalResponse!];
    } else {
      // Önceki veri yoksa, boş bir liste göster
      state = [];
    }
  }

  // Gelen verileri debounce etmek için
  void _debounceUpdate() {
    // Eğer daha önce bir timer varsa iptal et

    _debounceTimer = Timer(const Duration(seconds: 5), () {
      _filterCurrencies();
      _debounceTimer?.cancel();
    });
  }

  // Arama filtresini güncelle
  void updateSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    _filterCurrencies(); // Filtreleme işlemini çağır
  }

  // Tüm verileri getir veya filtrele
  void _filterCurrencies() {
    if (_originalResponse == null) return;

    final allCurrencies = _originalResponse!.currencies.values.toList();
    if (_searchQuery.isEmpty) {
      // Arama boşsa, tüm verileri göster
      state = [_originalResponse!];
    } else {
      // Arama doluysa, filtreleme yap
      final filteredCurrencies = allCurrencies
          .where((currency) => currency.code!
              .getCurrencyName()
              .toLowerCase()
              .contains(_searchQuery))
          .toList();

      // Filtrelenmiş yeni bir state oluştur
      state = [
        _originalResponse!.copyWith(
          currencies: {
            for (var currency in filteredCurrencies) currency.code!: currency
          },
        )
      ];
    }
  }

  // 🔹 Ekranda gösterilecek filtrelenmiş liste
  List<CurrencyData> get filteredCurrencies {
    if (state.isEmpty) return [];
    return state.first.currencies.values.toList();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}

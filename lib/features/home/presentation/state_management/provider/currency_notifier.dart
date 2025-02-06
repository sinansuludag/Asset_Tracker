import 'package:asset_tracker/features/home/data/models/currency_data_model.dart';
import 'package:asset_tracker/features/home/data/models/curreny_response_model.dart';
import 'package:asset_tracker/features/home/domain/repositories/i_currency_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CurrencyNotifier extends StateNotifier<List<CurrencyResponse>> {
  final ICurrencyRepository _repository;
  String _searchQuery = ''; // Arama filtresi
  CurrencyResponse? _originalResponse; // Orijinal veriyi sakla

  CurrencyNotifier(this._repository) : super([]) {
    _listenToCurrencyUpdates();
  }

  // Anlık veri güncellemeleri
  void _listenToCurrencyUpdates() {
    _repository.getCurrencyUpdates().listen(
      (currencyResponse) {
        _originalResponse = currencyResponse; // Orijinal veriyi kaydet
        _filterCurrencies(); // Gelen yeni veriye göre filtreleme işlemi yap
      },
      onError: (error) {
        print('Error: $error');
      },
    );
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
          .where((currency) =>
              currency.code != null &&
              currency.code!.toLowerCase().contains(_searchQuery))
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
}

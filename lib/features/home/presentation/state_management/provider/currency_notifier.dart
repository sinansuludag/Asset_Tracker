import 'dart:async';

import 'package:asset_tracker/core/extensions/currency_code_extension.dart';
import 'package:asset_tracker/features/home/data/models/currency_data_model.dart';
import 'package:asset_tracker/features/home/data/models/curreny_response_model.dart';
import 'package:asset_tracker/features/home/domain/repositories/i_currency_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CurrencyNotifier extends StateNotifier<List<CurrencyResponse>> {
  final ICurrencyRepository _repository;

  String _searchQuery = '';
  CurrencyResponse? _originalResponse;
  bool isConnected = true;

  DateTime _lastUpdate = DateTime.fromMillisecondsSinceEpoch(0);
  late StreamSubscription<CurrencyResponse> _subscription;

  CurrencyNotifier(this._repository) : super([]) {
    _listenToCurrencyUpdates();
  }

  CurrencyResponse? get fullCurrencyResponse => _originalResponse;

  void _listenToCurrencyUpdates() {
    _subscription = _repository.getCurrencyUpdates().listen(
      (currencyResponse) {
        final now = DateTime.now();
        final difference = now.difference(_lastUpdate);

        // 30 saniyede bir güncelle
        if (difference.inSeconds >= 30) {
          _originalResponse = currencyResponse;
          _filterCurrencies();
          _lastUpdate = now;
          isConnected = true;
        } else {
          // Güncelleme aralığı geçmediği için yok say
        }
      },
      onError: (error) {
        print('WebSocket Error: $error');
      },
      onDone: () {
        print('WebSocket Stream closed');
        if (!isConnected) {
          _usePreviousData();
        }
      },
    );
  }

  void _usePreviousData() {
    if (_originalResponse != null) {
      state = [_originalResponse!];
    } else {
      state = [];
    }
  }

  void updateSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    _filterCurrencies();
  }

  void _filterCurrencies() {
    if (_originalResponse == null) return;

    final allCurrencies = _originalResponse!.currencies.values.toList();

    if (_searchQuery.isEmpty) {
      state = [_originalResponse!];
    } else {
      final filtered = allCurrencies
          .where((currency) => currency.code!
              .getCurrencyName()
              .toLowerCase()
              .contains(_searchQuery))
          .toList();

      state = [
        _originalResponse!.copyWith(
          currencies: {for (var currency in filtered) currency.code!: currency},
        )
      ];
    }
  }

  List<CurrencyData> get filteredCurrencies {
    if (state.isEmpty) return [];
    return state.first.currencies.values.toList();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

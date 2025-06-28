import 'dart:async';

import 'package:asset_tracker/core/extensions/currency_code_extension.dart';
import 'package:asset_tracker/core/riverpod/all_riverpod.dart';
import 'package:asset_tracker/features/home/data/models/currency_data_model.dart';
import 'package:asset_tracker/features/home/data/models/curreny_response_model.dart';
import 'package:asset_tracker/features/home/domain/repositories/i_currency_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  CurrencyResponse? get fullCurrencyResponse => _originalResponse;

  void _listenToCurrencyUpdates() {
    _subscription = _repository.getCurrencyUpdates().listen(
          (currencyResponse) {
            final now = DateTime.now();
            final difference = now.difference(_lastUpdate);
            final interval = _ref.read(refreshIntervalProvider);

            if (interval == Duration.zero)
              return; // Manuel modda otomatik güncelleme yok

            if (difference >= interval) {
              _originalResponse = currencyResponse;
              _filterCurrencies();
              _lastUpdate = now;
              isConnected = true;
            }
          },
          onError: (error) => print('WebSocket Error: $error'),
          onDone: () {
            print('WebSocket Stream closed');
            if (!isConnected) _usePreviousData();
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

  void manualRefresh() async {
    final response = await _repository.getCurrencyUpdates().first;
    _originalResponse = response;
    _filterCurrencies();
    state = [_originalResponse!];
    _lastUpdate = DateTime.now();
  }
}

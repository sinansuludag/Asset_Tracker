import 'package:asset_tracker/features/home/presentation/state_management/provider/all_providers.dart';
import 'package:asset_tracker/features/markets/data/datasources/market_data_processor.dart';
import 'package:asset_tracker/features/markets/data/models/markets_state_model.dart';
import 'package:asset_tracker/features/markets/data/models/market_model.dart';
import 'package:asset_tracker/features/markets/domain/entities/market_filter_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MarketsNotifier extends StateNotifier<MarketsStateModel> {
  final Ref _ref;

  MarketsNotifier(this._ref) : super(MarketsStateModel.initial()) {
    _initializeMarkets();
  }

  void _initializeMarkets() {
    // Listen to currency updates from home feature
    _ref.listen(currencyNotifierProvider, (previous, next) {
      if (next.isNotEmpty) {
        _updateMarketsFromCurrency(next.first);
      }
    });
  }

  void _updateMarketsFromCurrency(dynamic currencyResponse) {
    try {
      final markets =
          MarketDataProcessor.processMarketsFromCurrency(currencyResponse);
      final trendingMarkets = MarketDataProcessor.getTrendingMarkets(markets);

      state = state.copyWith(
        allMarkets: markets,
        filteredMarkets: _applyFilters(markets),
        trendingMarkets: trendingMarkets,
        isLoading: false,
        hasError: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        hasError: true,
        errorMessage: 'Piyasa verileri yüklenirken hata oluştu: $e',
      );
    }
  }

  void updateFilter(MarketFilterEntity newFilter) {
    state = state.copyWith(
      filter: newFilter,
      filteredMarkets: _applyFilters(state.allMarkets),
    );
  }

  void updateCategory(String category) {
    final newFilter = state.filter.copyWith(category: category);
    updateFilter(newFilter);
  }

  void updateSearchQuery(String query) {
    final newFilter = state.filter.copyWith(searchQuery: query);
    updateFilter(newFilter);
  }

  void updateSorting(String sortBy, bool ascending) {
    final newFilter = state.filter.copyWith(
      sortBy: sortBy,
      ascending: ascending,
    );
    updateFilter(newFilter);
  }

  List<MarketModel> _applyFilters(List<MarketModel> markets) {
    var filteredMarkets = markets;

    // Apply category filter
    if (state.filter.category != 'all') {
      filteredMarkets = MarketDataProcessor.filterMarkets(
        filteredMarkets,
        state.filter.category,
      );
    }

    // Apply search filter
    if (state.filter.searchQuery.isNotEmpty) {
      filteredMarkets = MarketDataProcessor.searchMarkets(
        filteredMarkets,
        state.filter.searchQuery,
      );
    }

    // Apply sorting
    filteredMarkets = MarketDataProcessor.sortMarkets(
      filteredMarkets,
      state.filter.sortBy,
      state.filter.ascending,
    );

    return filteredMarkets;
  }

  void refreshMarkets() {
    state = state.copyWith(isLoading: true);
    // Trigger refresh from currency notifier
    _ref.read(currencyNotifierProvider.notifier).manualRefresh();
  }
}

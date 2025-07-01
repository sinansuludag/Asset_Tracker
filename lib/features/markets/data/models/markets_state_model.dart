import 'package:asset_tracker/features/markets/data/models/market_model.dart';
import 'package:asset_tracker/features/markets/domain/entities/market_filter_entity.dart';

class MarketsStateModel {
  final List<MarketModel> allMarkets;
  final List<MarketModel> filteredMarkets;
  final List<MarketModel> trendingMarkets;
  final MarketFilterEntity filter;
  final bool isLoading;
  final bool hasError;
  final String errorMessage;

  const MarketsStateModel({
    required this.allMarkets,
    required this.filteredMarkets,
    required this.trendingMarkets,
    required this.filter,
    this.isLoading = false,
    this.hasError = false,
    this.errorMessage = '',
  });

  factory MarketsStateModel.initial() => MarketsStateModel(
        allMarkets: const [],
        filteredMarkets: const [],
        trendingMarkets: const [],
        filter: const MarketFilterEntity(
          category: 'all',
          sortBy: 'name',
          ascending: true,
          searchQuery: '',
        ),
        isLoading: true,
      );

  MarketsStateModel copyWith({
    List<MarketModel>? allMarkets,
    List<MarketModel>? filteredMarkets,
    List<MarketModel>? trendingMarkets,
    MarketFilterEntity? filter,
    bool? isLoading,
    bool? hasError,
    String? errorMessage,
  }) {
    return MarketsStateModel(
      allMarkets: allMarkets ?? this.allMarkets,
      filteredMarkets: filteredMarkets ?? this.filteredMarkets,
      trendingMarkets: trendingMarkets ?? this.trendingMarkets,
      filter: filter ?? this.filter,
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  // Summary calculations
  double get totalMarketCap => allMarkets.fold(
      0.0, (sum, market) => sum + (market.currentPrice * market.volume));
  int get positiveMarketsCount => allMarkets.where((m) => m.change > 0).length;
  int get negativeMarketsCount => allMarkets.where((m) => m.change < 0).length;
}

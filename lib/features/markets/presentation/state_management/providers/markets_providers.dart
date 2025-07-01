import 'package:asset_tracker/features/home/presentation/state_management/provider/all_providers.dart';
import 'package:asset_tracker/features/home/presentation/state_management/provider/currency_notifier.dart';
import 'package:asset_tracker/features/markets/data/datasources/abstract_markets_service.dart';
import 'package:asset_tracker/features/markets/data/datasources/markets_firestore_service.dart';
import 'package:asset_tracker/features/markets/data/models/markets_state_model.dart';
import 'package:asset_tracker/features/markets/data/models/market_watchlist_model.dart';
import 'package:asset_tracker/features/markets/data/repositories/markets_repository_impl.dart';
import 'package:asset_tracker/features/markets/domain/repositories/i_markets_repository.dart';

import 'package:asset_tracker/features/markets/presentation/state_management/providers/markets_notifier.dart';
import 'package:asset_tracker/features/markets/presentation/state_management/providers/watchlist_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Services
final marketsServiceProvider = Provider<IMarketsService>((ref) {
  return MarketsFirestoreService(FirebaseFirestore.instance);
});

// Repositories
final marketsRepositoryProvider = Provider<IMarketsRepository>((ref) {
  final service = ref.watch(marketsServiceProvider);
  return MarketsRepositoryImpl(service);
});

// Main Markets Provider
final marketsProvider =
    StateNotifierProvider<MarketsNotifier, MarketsStateModel>((ref) {
  return MarketsNotifier(ref);
});

// Watchlist Provider
final watchlistProvider =
    StateNotifierProvider<WatchlistNotifier, List<MarketWatchlistModel>>((ref) {
  final repository = ref.watch(marketsRepositoryProvider);
  final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  return WatchlistNotifier(repository, userId);
});

// UI State Providers
final selectedCategoryProvider = StateProvider<String>((ref) => 'all');
final searchQueryProvider = StateProvider<String>((ref) => '');
final sortByProvider = StateProvider<String>((ref) => 'name');
final sortAscendingProvider = StateProvider<bool>((ref) => true);

// Computed Providers
final filteredMarketsProvider = Provider<List<dynamic>>((ref) {
  final marketsState = ref.watch(marketsProvider);
  final selectedCategory = ref.watch(selectedCategoryProvider);
  final searchQuery = ref.watch(searchQueryProvider);

  if (marketsState.isLoading) return [];

  var markets = marketsState.allMarkets;

  // Filter by category
  if (selectedCategory != 'all') {
    markets =
        markets.where((market) => market.category == selectedCategory).toList();
  }

  // Filter by search query
  if (searchQuery.isNotEmpty) {
    final lowercaseQuery = searchQuery.toLowerCase();
    markets = markets.where((market) {
      return market.name.toLowerCase().contains(lowercaseQuery) ||
          market.code.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  return markets;
});

final trendingMarketsProvider = Provider((ref) {
  final marketsState = ref.watch(marketsProvider);
  return marketsState.trendingMarkets;
});

final marketSummaryProvider = Provider<Map<String, double>>((ref) {
  final marketsState = ref.watch(marketsProvider);
  final markets = marketsState.allMarkets;

  final totalMarkets = markets.length;
  final positiveMarkets = markets.where((m) => m.change > 0).length;
  final negativeMarkets = markets.where((m) => m.change < 0).length;
  final avgChange = markets.isNotEmpty
      ? markets.map((m) => m.changePercentage).reduce((a, b) => a + b) /
          markets.length
      : 0.0;

  return {
    'totalMarkets': totalMarkets.toDouble(),
    'positiveMarkets': positiveMarkets.toDouble(),
    'negativeMarkets': negativeMarkets.toDouble(),
    'avgChange': avgChange,
  };
});

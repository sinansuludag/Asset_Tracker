import 'package:asset_tracker/features/markets/data/models/market_watchlist_model.dart';
import 'package:asset_tracker/features/markets/domain/repositories/i_markets_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WatchlistNotifier extends StateNotifier<List<MarketWatchlistModel>> {
  final IMarketsRepository _repository;
  final String _userId;

  WatchlistNotifier(this._repository, this._userId) : super([]) {
    _loadWatchlist();
  }

  void _loadWatchlist() async {
    try {
      final watchlist = await _repository.getUserWatchlist(_userId);
      state = watchlist;
    } catch (e) {
      // Handle error
      state = [];
    }
  }

  Future<bool> addToWatchlist(
      String marketCode, double alertPrice, String alertType) async {
    final watchlistItem = MarketWatchlistModel(
      id: '', // Will be set by service
      userId: _userId,
      marketCode: marketCode,
      alertPrice: alertPrice,
      alertType: alertType,
      isActive: true,
      createdAt: DateTime.now(),
    );

    final success = await _repository.addToWatchlist(watchlistItem);
    if (success) {
      _loadWatchlist(); // Refresh
    }
    return success;
  }

  Future<bool> removeFromWatchlist(String watchlistId) async {
    final success = await _repository.removeFromWatchlist(watchlistId);
    if (success) {
      state = state.where((item) => item.id != watchlistId).toList();
    }
    return success;
  }

  Future<bool> updateAlert(MarketWatchlistModel watchlistItem) async {
    final success = await _repository.updateWatchlistAlert(watchlistItem);
    if (success) {
      _loadWatchlist(); // Refresh
    }
    return success;
  }

  bool isInWatchlist(String marketCode) {
    return state.any((item) => item.marketCode == marketCode && item.isActive);
  }
}

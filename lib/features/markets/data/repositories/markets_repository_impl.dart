import 'package:asset_tracker/features/markets/data/datasources/abstract_markets_service.dart';
import 'package:asset_tracker/features/markets/data/models/market_watchlist_model.dart';
import 'package:asset_tracker/features/markets/domain/repositories/i_markets_repository.dart';

class MarketsRepositoryImpl implements IMarketsRepository {
  final IMarketsService _marketsService;

  MarketsRepositoryImpl(this._marketsService);

  @override
  Future<List<MarketWatchlistModel>> getUserWatchlist(String userId) async {
    return await _marketsService.getUserWatchlist(userId);
  }

  @override
  Future<bool> addToWatchlist(MarketWatchlistModel watchlistItem) async {
    return await _marketsService.addToWatchlist(watchlistItem);
  }

  @override
  Future<bool> removeFromWatchlist(String watchlistId) async {
    return await _marketsService.removeFromWatchlist(watchlistId);
  }

  @override
  Future<bool> updateWatchlistAlert(MarketWatchlistModel watchlistItem) async {
    return await _marketsService.updateWatchlistAlert(watchlistItem);
  }

  @override
  Stream<List<MarketWatchlistModel>> getUserWatchlistStream(String userId) {
    return _marketsService.getUserWatchlistStream(userId);
  }
}

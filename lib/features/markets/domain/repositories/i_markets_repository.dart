import 'package:asset_tracker/features/markets/data/models/market_watchlist_model.dart';

abstract class IMarketsRepository {
  Future<List<MarketWatchlistModel>> getUserWatchlist(String userId);
  Future<bool> addToWatchlist(MarketWatchlistModel watchlistItem);
  Future<bool> removeFromWatchlist(String watchlistId);
  Future<bool> updateWatchlistAlert(MarketWatchlistModel watchlistItem);
  Stream<List<MarketWatchlistModel>> getUserWatchlistStream(String userId);
}

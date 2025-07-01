import 'package:asset_tracker/features/markets/data/datasources/abstract_markets_service.dart';
import 'package:asset_tracker/features/markets/data/models/market_watchlist_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class MarketsFirestoreService implements IMarketsService {
  final FirebaseFirestore _firestore;

  MarketsFirestoreService(this._firestore);

  @override
  Future<List<MarketWatchlistModel>> getUserWatchlist(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection('watchlists')
          .where('userId', isEqualTo: userId)
          .where('isActive', isEqualTo: true)
          .get();

      return querySnapshot.docs
          .map((doc) => MarketWatchlistModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      debugPrint('Error fetching user watchlist: $e');
      return [];
    }
  }

  @override
  Future<bool> addToWatchlist(MarketWatchlistModel watchlistItem) async {
    try {
      final id = _firestore.collection('watchlists').doc().id;
      final newWatchlistItem = watchlistItem.copyWith(id: id);

      await _firestore
          .collection('watchlists')
          .doc(id)
          .set(newWatchlistItem.toJson());

      return true;
    } catch (e) {
      debugPrint('Error adding to watchlist: $e');
      return false;
    }
  }

  @override
  Future<bool> removeFromWatchlist(String watchlistId) async {
    try {
      await _firestore
          .collection('watchlists')
          .doc(watchlistId)
          .update({'isActive': false});

      return true;
    } catch (e) {
      debugPrint('Error removing from watchlist: $e');
      return false;
    }
  }

  @override
  Future<bool> updateWatchlistAlert(MarketWatchlistModel watchlistItem) async {
    try {
      await _firestore
          .collection('watchlists')
          .doc(watchlistItem.id)
          .update(watchlistItem.toJson());

      return true;
    } catch (e) {
      debugPrint('Error updating watchlist alert: $e');
      return false;
    }
  }

  @override
  Stream<List<MarketWatchlistModel>> getUserWatchlistStream(String userId) {
    return _firestore
        .collection('watchlists')
        .where('userId', isEqualTo: userId)
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MarketWatchlistModel.fromJson(doc.data()))
            .toList());
  }
}

import 'package:asset_tracker/features/home/data/datasources/firebase_store/abstract_asset_service.dart';
import 'package:asset_tracker/features/home/data/models/buying_asset_model.dart';
import 'package:asset_tracker/features/home/domain/entities/asset_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// Firebase Firestore ile varlık CRUD işlemlerinin implementasyonu
class AssetFirestoreServiceImpl implements IAssetService {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  // Firestore collection adı
  static const String _collectionName = 'user_assets';

  AssetFirestoreServiceImpl(this._firestore, this._auth);

  @override
  Future<bool> saveAsset(AssetEntity asset) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        debugPrint('❌ User not authenticated');
        return false;
      }

      // Yeni document ID oluştur
      final docRef = _firestore.collection(_collectionName).doc();

      // Asset'i güncel user ID ile güncelle
      final assetWithId = asset.copyWith(
        id: docRef.id,
        userId: user.uid,
      );

      // Firestore'a kaydet
      await docRef.set(assetWithId.toJson());

      debugPrint('✅ Asset saved successfully: ${assetWithId.id}');
      return true;
    } catch (e) {
      debugPrint('❌ Error saving asset: $e');
      return false;
    }
  }

  @override
  Future<List<AssetEntity>> getUserAssets(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collectionName)
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true) // En yeni önce
          .get();

      final assets = querySnapshot.docs
          .map((doc) => BuyingAssetModel.fromJson(doc.data()))
          .toList();

      debugPrint('✅ Fetched ${assets.length} assets for user: $userId');
      return assets;
    } catch (e) {
      debugPrint('❌ Error fetching user assets: $e');
      return [];
    }
  }

  @override
  Future<bool> deleteAsset(String assetId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      // Güvenlik: Sadece kendi varlığını silebilir
      final doc =
          await _firestore.collection(_collectionName).doc(assetId).get();
      if (!doc.exists || doc.data()?['userId'] != user.uid) {
        debugPrint('❌ Asset not found or unauthorized');
        return false;
      }

      await _firestore.collection(_collectionName).doc(assetId).delete();

      debugPrint('✅ Asset deleted successfully: $assetId');
      return true;
    } catch (e) {
      debugPrint('❌ Error deleting asset: $e');
      return false;
    }
  }

  @override
  Future<bool> updateAsset(AssetEntity asset) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      // Güvenlik kontrolü
      final doc =
          await _firestore.collection(_collectionName).doc(asset.id).get();
      if (!doc.exists || doc.data()?['userId'] != user.uid) {
        debugPrint('❌ Asset not found or unauthorized');
        return false;
      }

      await _firestore
          .collection(_collectionName)
          .doc(asset.id)
          .update(asset.toJson());

      debugPrint('✅ Asset updated successfully: ${asset.id}');
      return true;
    } catch (e) {
      debugPrint('❌ Error updating asset: $e');
      return false;
    }
  }

  /// Real-time stream for user assets (bonus feature)
  Stream<List<AssetEntity>> getUserAssetsStream(String userId) {
    return _firestore
        .collection(_collectionName)
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => BuyingAssetModel.fromJson(doc.data()))
            .toList());
  }
}

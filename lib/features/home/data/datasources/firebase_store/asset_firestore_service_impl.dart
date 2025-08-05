import 'package:asset_tracker/features/home/data/datasources/firebase_store/abstract_asset_service.dart';
import 'package:asset_tracker/features/home/data/models/buying_asset_model.dart';
import 'package:asset_tracker/features/home/domain/entities/asset_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Firebase Firestore ile varlık CRUD işlemlerinin implementasyonu
class AssetFirestoreServiceImpl implements IAssetService {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  // Firestore collection adı
  static const String _collectionName = 'assets';

  AssetFirestoreServiceImpl(this._firestore, this._auth);

  @override
  Future<bool> saveAsset(AssetEntity asset) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
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

      return true;
    } catch (e) {
      return false;
    }
  }

  @override
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

  @override
  Future<bool> deleteAsset(String assetId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      // Güvenlik: Sadece kendi varlığını silebilir
      final doc =
          await _firestore.collection(_collectionName).doc(assetId).get();
      if (!doc.exists || doc.data()?['userId'] != user.uid) {
        return false;
      }

      await _firestore.collection(_collectionName).doc(assetId).delete();

      return true;
    } catch (e) {
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
        return false;
      }

      await _firestore
          .collection(_collectionName)
          .doc(asset.id)
          .update(asset.toJson());

      return true;
    } catch (e) {
      return false;
    }
  }
}

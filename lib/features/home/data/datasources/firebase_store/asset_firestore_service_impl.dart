import 'package:asset_tracker/features/home/data/datasources/firebase_store/abstract_asset_service.dart';
import 'package:asset_tracker/features/home/data/models/buying_asset_model.dart';
import 'package:asset_tracker/features/home/domain/entities/asset_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AssetFirestoreServiceImpl implements IAssetService {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  static const String _summaryCollection = 'asset_summary';
  static const String _transactionCollection = 'asset_transactions';

  AssetFirestoreServiceImpl(this._firestore, this._auth);

  @override
  Future<bool> saveAsset(AssetEntity asset) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      final buyingAsset = asset as BuyingAssetModel;

      // 1. Özet tablosunu kontrol et
      final summaryQuery = await _firestore
          .collection(_summaryCollection)
          .where('userId', isEqualTo: user.uid)
          .where('assetType', isEqualTo: buyingAsset.assetType)
          .where('assetSubType',
              isEqualTo: buyingAsset.assetSubType ?? 'normal')
          .get();

      if (summaryQuery.docs.isEmpty) {
        // İLK ALIM - Yeni özet oluştur
        final summaryDoc = _firestore.collection(_summaryCollection).doc();
        await summaryDoc.set({
          'id': summaryDoc.id,
          'userId': user.uid,
          'assetType': buyingAsset.assetType,
          'assetSubType': buyingAsset.assetSubType ?? 'normal',
          'totalQuantity': buyingAsset.quantity,
          'totalInvestment': buyingAsset.totalInvestment,
          'averagePrice': buyingAsset.buyingPrice,
          'totalGramWeight': buyingAsset.gramWeight,
          'ayarType': buyingAsset.ayarType,
          'transactionCount': 1,
          'lastUpdated': FieldValue.serverTimestamp(),
        });

        // İlk işlem kaydı
        final transactionDoc =
            _firestore.collection(_transactionCollection).doc();
        await transactionDoc.set({
          'id': transactionDoc.id,
          'userId': user.uid,
          'assetType': buyingAsset.assetType,
          'assetSubType': buyingAsset.assetSubType ?? 'normal',
          'quantity': buyingAsset.quantity,
          'buyingPrice': buyingAsset.buyingPrice,
          'buyingDate': buyingAsset.buyingDate.toIso8601String(),
          'totalInvestment': buyingAsset.totalInvestment,
          'gramWeight': buyingAsset.gramWeight,
          'ayarType': buyingAsset.ayarType,
          'transactionNumber': 1,
          'createdAt': FieldValue.serverTimestamp(),
        });
      } else {
        // MEVCUT VARLIK - Güncelle
        final summaryDoc = summaryQuery.docs.first;
        final oldData = summaryDoc.data();

        final newTotalQuantity =
            (oldData['totalQuantity'] ?? 0) + buyingAsset.quantity;
        final newTotalInvestment =
            (oldData['totalInvestment'] ?? 0) + buyingAsset.totalInvestment;
        final newTotalGramWeight =
            (oldData['totalGramWeight'] ?? 0) + (buyingAsset.gramWeight ?? 0);

        double newAveragePrice;
        if (buyingAsset.assetSubType == 'bracelet' && newTotalGramWeight > 0) {
          newAveragePrice = newTotalInvestment / newTotalGramWeight;
        } else if (newTotalQuantity > 0) {
          newAveragePrice = newTotalInvestment / newTotalQuantity;
        } else {
          newAveragePrice = buyingAsset.buyingPrice;
        }

        await _firestore
            .collection(_summaryCollection)
            .doc(summaryDoc.id)
            .update({
          'totalQuantity': newTotalQuantity,
          'totalInvestment': newTotalInvestment,
          'averagePrice': newAveragePrice,
          'totalGramWeight': newTotalGramWeight,
          'transactionCount': FieldValue.increment(1),
          'lastUpdated': FieldValue.serverTimestamp(),
        });

        final transactionCount = oldData['transactionCount'] ?? 0;
        final transactionDoc =
            _firestore.collection(_transactionCollection).doc();
        await transactionDoc.set({
          'id': transactionDoc.id,
          'userId': user.uid,
          'assetType': buyingAsset.assetType,
          'assetSubType': buyingAsset.assetSubType ?? 'normal',
          'quantity': buyingAsset.quantity,
          'buyingPrice': buyingAsset.buyingPrice,
          'buyingDate': buyingAsset.buyingDate.toIso8601String(),
          'totalInvestment': buyingAsset.totalInvestment,
          'gramWeight': buyingAsset.gramWeight,
          'ayarType': buyingAsset.ayarType,
          'transactionNumber': transactionCount + 1,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Stream<List<AssetEntity>> getUserAssetsStream(String userId) {
    return _firestore
        .collection(_summaryCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('lastUpdated', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              return BuyingAssetModel(
                id: data['id'],
                assetType: data['assetType'],
                buyingDate: (data['lastUpdated'] as Timestamp).toDate(),
                buyingPrice: data['averagePrice'],
                quantity: data['totalQuantity'],
                userId: data['userId'],
                totalInvestment: data['totalInvestment'],
                ayarType: data['ayarType'],
                gramWeight: data['totalGramWeight'],
                assetSubType: data['assetSubType'],
              );
            }).toList());
  }

  @override
  Future<bool> deleteAsset(String assetId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      final doc =
          await _firestore.collection(_summaryCollection).doc(assetId).get();
      if (!doc.exists || doc.data()?['userId'] != user.uid) {
        return false;
      }

      await _firestore.collection(_summaryCollection).doc(assetId).delete();
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

      final doc =
          await _firestore.collection(_summaryCollection).doc(asset.id).get();
      if (!doc.exists || doc.data()?['userId'] != user.uid) {
        return false;
      }

      await _firestore
          .collection(_summaryCollection)
          .doc(asset.id)
          .update(asset.toJson());

      return true;
    } catch (e) {
      return false;
    }
  }
}
